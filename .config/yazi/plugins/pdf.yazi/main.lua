local M = {}

local info_cache = {}

local function get_pdf_info(url)
	local s = tostring(url)
	if info_cache[s] then
		return info_cache[s]
	end

	local output = Command("pdfinfo"):arg(s):output()
	if not output or not output.status.success then
		return nil
	end

	local stdout = output.stdout
	local pages = tonumber(stdout:match("Pages:%s+(%d+)")) or 1
	local pw, ph = stdout:match("Page size:%s+([%d%.]+)%s+x%s+([%d%.]+)")
	pw = tonumber(pw) or 612
	ph = tonumber(ph) or 792

	local info = {
		pages = pages,
		w = pw,
		h = ph,
		ratio = pw / ph,
	}
	info_cache[s] = info
	return info
end

local function calc_count(job, info)
	if not info or info.pages <= 1 then
		return 1
	end

	local remaining = info.pages - job.skip
	if remaining <= 1 then
		return 1
	end

	if job.args and #job.args > 0 then
		local req = tonumber(job.args[1])
		if req and req > 0 then
			return math.min(req, remaining)
		end
	end

	local area_w = (job.area and job.area.w and job.area.w > 0) and (job.area.w * 0.5) or 40
	local area_h = (job.area and job.area.h and job.area.h > 0) and job.area.h or 40

	local page_h_cells = area_w / info.ratio
	local fit = area_h / page_h_cells

	local target = 1
	if fit >= 1.6 then
		target = math.min(3, math.floor(fit + 0.35))
	end

	return math.min(target, remaining)
end

function M:peek(job)
	local start, cache = os.clock(), ya.file_cache(job)
	if not cache then
		return
	end

	local ok, err = self:preload(job)
	if not ok or err then
		return
	end

	ya.sleep(math.max(0, rt.preview.image_delay / 1000 + start - os.clock()))
	ya.image_show(cache, job.area)
	ya.preview_widgets(job, {})
end

function M:seek(job)
	local h = cx.active.current.hovered
	if h and h.url == job.file.url then
		local step = ya.clamp(-1, job.units, 1)
		ya.mgr_emit("peek", { math.max(0, cx.active.preview.skip + step), only_if = job.file.url })
	end
end

function M:preload(job)
	local cache = ya.file_cache(job)
	if not cache or fs.cha(cache) then
		return true
	end

	local info = get_pdf_info(job.file.url)
	if info and job.skip > 0 and job.skip >= info.pages then
		ya.mgr_emit("peek", { math.max(0, info.pages - 1), only_if = job.file.url, upper_bound = true })
		return true
	end

	local count = calc_count(job, info)
	local start_page = job.skip + 1
	local end_page = job.skip + count

	local script = [[
pdf="$1"
start="$2"
end="$3"
quality="$4"
max_w="$5"
cache="$6"

tmpdir=$(mktemp -d /tmp/yazi_pdf_XXXXXX)
trap 'rm -rf "$tmpdir"' EXIT INT TERM

if [ "$start" -eq "$end" ]; then
	pdftoppm -f "$start" -l "$start" -singlefile -jpeg -jpegopt quality="$quality" -scale-to-x "$max_w" -scale-to-y -1 "$pdf" "$tmpdir/page" && \
	mv "$tmpdir/page.jpg" "$cache"
else
	pdftoppm -f "$start" -l "$end" -jpeg -jpegopt quality="$quality" -scale-to-x "$max_w" -scale-to-y -1 "$pdf" "$tmpdir/page" && \
	magick "$tmpdir"/page-*.jpg -bordercolor "#282828" -border 0x6 -append "$cache"
fi
]]

	local output, err = Command("sh")
		:args({
			"-c",
			script,
			"--",
			tostring(job.file.url),
			tostring(start_page),
			tostring(end_page),
			tostring(rt.preview.image_quality),
			tostring(rt.preview.max_width),
			tostring(cache),
		})
		:stderr(Command.PIPED)
		:output()

	if not output then
		return true, Err("Failed to start preview command, error: %s", err)
	elseif not output.status.success then
		local pages = tonumber(output.stderr:match("the last page %((%d+)%)")) or 0
		if job.skip > 0 and pages > 0 then
			ya.mgr_emit("peek", { math.max(0, pages - 1), only_if = job.file.url, upper_bound = true })
		end
		return true, Err("Failed to convert PDF, stderr: %s", output.stderr)
	end

	return true
end

return M
