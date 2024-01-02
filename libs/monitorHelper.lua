local logger = require("libs.logger")
local manager = require("libs.deviceManager")

local monitorList = {}

local function init(monitors, log)
    monitorList = monitors
    logger = log
end

local function clear(monitorIndex)
    monitorList[monitorIndex].clear()
end

local function clearAll()
    for index = 1, #monitorList do
        clear(index)
        monitorList[index].setTextScale(0.5)
    end
end

local function drawBar(monitorIndex, startX, startY, endX, endY, color)
    local monitor = monitorList[monitorIndex]

    if not monitor then
        logger.logE("monitor["..monitorIndex.."] in drawBar() is NOT a valid monitor")
        return
    end

    term.redirect(monitor)
    paintutils.drawLine(startX,startY,endX,endY,color)
    monitor.setBackgroundColor(colors.black)

    local native = term.native()
    term.redirect(native)
end

local function drawBox(monitorIndex, startX, startY, endX, endY, color)
    local monitor = monitorList[monitorIndex]

    if not monitor then
        logger.logE("monitor["..monitorIndex.."] in drawBox() is NOT a valid monitor")
        return
    end

    term.redirect(monitor)
    paintutils.drawBox(startX,startY,endX,endY,color)
    monitor.setBackgroundColor(colors.black)

    local native = term.native()
    term.redirect(native)
end

local function drawFilledBox(monitorIndex, startX, startY, endX, endY, color)
    local monitor = monitorList[monitorIndex]

    if not monitor then
        logger.logE("monitor["..monitorIndex.."] in drawBox() is NOT a valid monitor")
        return
    end

    term.redirect(monitor)
    paintutils.drawFilledBox(startX,startY,endX,endY,color)
    monitor.setBackgroundColor(colors.black)

    local native = term.native()
    term.redirect(native)
end

local function write(monitorIndex, x, y, color, text)
    local monitor = monitorList[monitorIndex]
    monitor.setTextColor(color)
    monitor.setCursorPos(x, y)
    monitor.write(text)
    monitor.setTextColor(colors.white)
end

return {init=init, drawBar=drawBar, drawBox=drawBox, clear=clear, drawFilledBox=drawFilledBox, clearAll=clearAll, write=write}