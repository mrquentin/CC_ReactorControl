local wpp = require("libs.wpp")
local deviceManager = require("libs.deviceManager")
local logger = require("libs.logger")
local monitorHelper = require("libs.monitorHelper")

local monitorList = {}
local monitorNames = {}
local matrixList = {}
local matrixNames = {}

wpp.wireless.connect("induction-matrix")

-- Format number with [k,M,G,T,P,E] postfix or exponent, depending on how large it is
function formatUnits(number)
    local units = {"", "k", "M", "G", "T", "P", "E"}  -- Add more as needed
    local absNumber, unitIndex = math.abs(number), 1
    while absNumber >= 1000 and unitIndex < #units do
        absNumber, unitIndex = absNumber / 1000, unitIndex + 1
    end
    return (number < 0 and "-" or "") .. string.format("%.2f", absNumber) .. units[unitIndex]
end -- local function formatReadableSIUnit(num)

local function getEnergy()
    local maxEnergy, energy = 0, 0
    for matrixIndex = 1, #matrixList do
        local matrix=matrixList[matrixIndex]
        maxEnergy = maxEnergy + matrix.getMaxEnergy()
        energy = energy + matrix.getEnergy()
    end
    return (energy/2.5), (maxEnergy/2.5) -- Convert from J to FE
end

local function drawEnergy()
    for monitorIndex = 1, #monitorList do
        local x, y = monitorList[monitorIndex].getSize()

        -- Draw contour box
        monitorHelper.drawBox(monitorIndex, 1, 1, x, y, colors.gray)

        -- Draw energy level Bar
        local energy, maxEnergy = getEnergy()
        local barWidth = math.floor((energy/maxEnergy)*(x-2))
        monitorHelper.drawFilledBox(monitorIndex, 2, 2, 2 + barWidth, y - 1, colors.green)
        monitorHelper.drawFilledBox(monitorIndex, 2 + barWidth + 1, 2, x - 1, y - 1, colors.black)

        -- Write Energy level
        local text = formatUnits(energy).." / "..formatUnits(maxEnergy).." FE"
        local textX = math.floor((x - #text) / 2)
        local textY = math.floor(y / 2)+ (y % 2)
        for xIndex = textX, textX + #text - 1 do
            monitorList[monitorIndex].setBackgroundColor(colors.black)
            if (xIndex <= (2 + barWidth)) then
                monitorList[monitorIndex].setBackgroundColor(colors.green)
            end
            local letterIndex = xIndex - textX + 1
            monitorHelper.write(monitorIndex, xIndex, textY,  colors.white, string.sub(text, letterIndex, letterIndex))
        end
    end
end

-- monitorList, monitorNames = deviceManager.getDevices("monitor")
logger.init("matrixcontrol")
deviceManager.init(logger)

monitorList, monitorNames = deviceManager.getDevices("monitor")
monitorHelper.init(monitorList, logger)

matrixList, matrixNames = deviceManager.getDevices("inductionPort")

monitorHelper.clearAll()

sleep(5) -- Give time to the multiblock to form

while(1) do
    drawEnergy()
    sleep(10)
end
