require("hs.ipc")

-- Restore minimized windows of the current application
hs.hotkey.bind({"cmd", "alt"}, "M", function()
    local app = hs.application.frontmostApplication()
    if app then
        for _, window in pairs(app:allWindows()) do
            if window:isMinimized() then
                window:unminimize()
            end
        end
    end
end)

-- =========================================================
-- Ninja Golden Window Focus Flash Animation
-- Draws a beautiful Gruvbox Gold border around focused window
-- that dynamically slides/fades out in 200ms
-- =========================================================
local focusFrame = nil

local function flashFocusedWindow()
    local win = hs.window.focusedWindow()
    if not win then return end
    
    local f = win:frame()
    
    -- Delete previous frame if active
    if focusFrame then
        focusFrame:delete()
        focusFrame = nil
    end
    
    -- Create custom canvas overlay matching window borders
    focusFrame = hs.canvas.new({x=f.x - 2, y=f.y - 2, w=f.w + 4, h=f.h + 4})
    
    -- Insert a stroke rectangle in Gruvbox Gold (#fabd2f)
    focusFrame:insertElement({
        type = "rectangle",
        action = "stroke",
        strokeColor = {red=250/255, green=189/255, blue=47/255, alpha=0.9},
        strokeWidth = 6,
        roundedRectRadii = {xRadius=10, yRadius=10}
    })
    
    focusFrame:show()
    
    -- Smooth Ninja Fade Out
    local alpha = 0.9
    local steps = 10
    local stepTime = 0.02
    
    hs.timer.doEvery(stepTime, function(timer)
        alpha = alpha - (0.9 / steps)
        if alpha <= 0 or not focusFrame then
            if focusFrame then
                focusFrame:delete()
                focusFrame = nil
            end
            timer:stop()
        else
            focusFrame:alpha(alpha)
        end
    end)
end

-- Subscribe to system-wide window focus events
local winFilter = hs.window.filter.new()
winFilter:subscribe(hs.window.filter.windowFocused, flashFocusedWindow)

-- =========================================================
-- Floating Window Precision Pixel Mover
-- =========================================================
local function nudgeWindow(dx, dy)
    local win = hs.window.focusedWindow()
    if not win or win:isFullScreen() then return end
    local f = win:frame()
    f.x = f.x + dx
    f.y = f.y + dy
    win:setFrame(f)
end

-- Helper to bind key with hold-to-repeat support
local function bindNudge(mods, key, dx, dy)
    local fn = function() nudgeWindow(dx, dy) end
    hs.hotkey.bind(mods, key, fn, nil, fn)
end

-- Fast nudge: Ctrl + Alt (25px) - Arrow keys & HJKL (hold to glide)
local FAST_STEP = 25
bindNudge({"ctrl", "alt"}, "Left",  -FAST_STEP, 0)
bindNudge({"ctrl", "alt"}, "Right",  FAST_STEP, 0)
bindNudge({"ctrl", "alt"}, "Up",     0, -FAST_STEP)
bindNudge({"ctrl", "alt"}, "Down",   0,  FAST_STEP)
bindNudge({"ctrl", "alt"}, "H",     -FAST_STEP, 0)
bindNudge({"ctrl", "alt"}, "L",      FAST_STEP, 0)
bindNudge({"ctrl", "alt"}, "K",      0, -FAST_STEP)
bindNudge({"ctrl", "alt"}, "J",      0,  FAST_STEP)

-- Precision nudge: Ctrl + Alt + Shift (2px) - Arrow keys & HJKL (hold to glide)
local FINE_STEP = 2
bindNudge({"ctrl", "alt", "shift"}, "Left",  -FINE_STEP, 0)
bindNudge({"ctrl", "alt", "shift"}, "Right",  FINE_STEP, 0)
bindNudge({"ctrl", "alt", "shift"}, "Up",     0, -FINE_STEP)
bindNudge({"ctrl", "alt", "shift"}, "Down",   0,  FINE_STEP)
bindNudge({"ctrl", "alt", "shift"}, "H",     -FINE_STEP, 0)
bindNudge({"ctrl", "alt", "shift"}, "L",      FINE_STEP, 0)
bindNudge({"ctrl", "alt", "shift"}, "K",      0, -FINE_STEP)
bindNudge({"ctrl", "alt", "shift"}, "J",      0,  FINE_STEP)

-- =========================================================
-- Mouse Grab Anywhere (Cmd + Ctrl + Click-Drag)
-- Hold Cmd + Ctrl, click anywhere on window to drag like Linux
-- =========================================================
local dragging = false
local dragWin = nil
local lastPos = nil

local mouseDragWatcher = hs.eventtap.new({
    hs.eventtap.event.types.leftMouseDown,
    hs.eventtap.event.types.leftMouseDragged,
    hs.eventtap.event.types.leftMouseUp
}, function(event)
    local flags = event:getFlags()
    local eType = event:getType()
    
    if flags.cmd and flags.ctrl and not flags.alt and not flags.shift then
        if eType == hs.eventtap.event.types.leftMouseDown then
            dragWin = hs.window.focusedWindow()
            if dragWin and not dragWin:isFullScreen() then
                dragging = true
                lastPos = hs.mouse.absolutePosition()
                return true
            end
        elseif eType == hs.eventtap.event.types.leftMouseDragged and dragging and dragWin then
            local curPos = hs.mouse.absolutePosition()
            local dx = curPos.x - lastPos.x
            local dy = curPos.y - lastPos.y
            local f = dragWin:frame()
            f.x = f.x + dx
            f.y = f.y + dy
            dragWin:setFrame(f)
            lastPos = curPos
            return true
        end
    end
    
    if eType == hs.eventtap.event.types.leftMouseUp and dragging then
        dragging = false
        dragWin = nil
        lastPos = nil
        return true
    end
    
    return false
end):start()

