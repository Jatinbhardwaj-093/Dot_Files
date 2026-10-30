return {
  "NvChad/ui",
  opts = {
    statusline = {
      order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "venv", "cwd", "cursor" },
      modules = {
        -- Responsive file path module
        file = function()
          local path = vim.fn.expand("%:p:~:.")
          if path == "" then
            return ""
          end
          local utils = require "nvchad.stl.utils"
          local x = utils.file()
          local sep_style = require("nvconfig").ui.statusline.separator_style
          local sep_r = utils.separators[sep_style]["right"]

          -- Width check for current window:
          -- winwidth < 75: only filename (e.g. "bootstrap.py")
          -- winwidth >= 75: relative spaced path (e.g. "a / b / c.py")
          local win_w = vim.api.nvim_win_get_width(vim.g.statusline_winid or 0)
          local display_name
          if win_w < 75 then
            display_name = x[2]
          else
            display_name = path:gsub("/", " / ")
          end

          return "%#St_file# " .. x[1] .. " " .. display_name .. " %#St_file_sep#" .. sep_r
        end,

        -- Responsive git: hide on narrow windows
        git = function()
          local win_w = vim.api.nvim_win_get_width(vim.g.statusline_winid or 0)
          if win_w < 70 then
            return ""
          end
          return "%#St_gitIcons#" .. require("nvchad.stl.utils").git()
        end,

        -- Responsive LSP module: hide or simplify
        lsp = function()
          local win_w = vim.api.nvim_win_get_width(vim.g.statusline_winid or 0)
          if win_w < 60 then
            return ""
          end
          if rawget(vim, "lsp") then
            for _, client in ipairs(vim.lsp.get_clients()) do
              if client.attached_buffers[require("nvchad.stl.utils").stbufnr()] then
                if win_w < 100 then
                  return "   "
                else
                  return "   LSP ~ " .. client.name .. " "
                end
              end
            end
          end
          return ""
        end,

        -- Responsive Python Virtual Environment Indicator
        venv = function()
          local win_w = vim.api.nvim_win_get_width(vim.g.statusline_winid or 0)
          if win_w < 80 then
            return ""
          end
          local status, venv_selector = pcall(require, "venv-selector")
          if not status then
            return ""
          end
          local venv = venv_selector.get_active_venv()
          if venv then
            local name = venv:match("([^/]+)/?$")
            if name then
              return "%#St_Lsp#  " .. name .. " "
            end
          end
          return ""
        end,

        -- Responsive CWD: hide on narrow windows
        cwd = function()
          local win_w = vim.api.nvim_win_get_width(vim.g.statusline_winid or 0)
          if win_w < 85 then
            return ""
          end
          local utils = require "nvchad.stl.utils"
          local sep_style = require("nvconfig").ui.statusline.separator_style
          local sep_l = utils.separators[sep_style]["left"]
          local icon = "%#St_cwd_icon#󰉋 "
          local name = vim.uv.cwd()
          name = "%#St_cwd_text# " .. (name:match "([^/\\]+)[/\\]*$" or name) .. " "
          return "%#St_cwd_sep#" .. sep_l .. icon .. name
        end,
      },
    },
  },
}
