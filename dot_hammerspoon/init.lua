hs.loadSpoon("EmmyLua")
hs.loadSpoon("LeftRightHotkey")
spoon.LeftRightHotkey:start()

local function sendDownArrow()
    hs.eventtap.keyStroke({}, "down")
end

local function sendUpArrow()
    hs.eventtap.keyStroke({}, "up")
end

local function sendRightArrow()
    hs.eventtap.keyStroke({}, "right")
end

local function sendLeftArrow()
    hs.eventtap.keyStroke({}, "left")
end

hs.hotkey.bind({ "cmd", "ctrl", "alt", "shift" }, "j", sendDownArrow)
hs.hotkey.bind({ "cmd", "ctrl", "alt", "shift" }, "k", sendUpArrow)
hs.hotkey.bind({ "cmd", "ctrl", "alt", "shift" }, "h", sendLeftArrow)
hs.hotkey.bind({ "cmd", "ctrl", "alt", "shift" }, "l", sendRightArrow)
print("Arrow key navigation config created!")
