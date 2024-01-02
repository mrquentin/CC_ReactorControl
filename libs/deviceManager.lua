local CURRENT_VERSION = "0.1"

local wpp = require("libs.wpp")
local logger = require("libs.logger")

local function init(givenLogger)
    logger = givenLogger
end

local function getDevices(deviceType)
    local deviceName = nil
    local deviceIndex = 1
    local deviceList, deviceNames = {}, {}
    local peripheralList = wpp.peripheral.getNames()

    deviceType = deviceType:lower()

    for peripheralIndex = 1, #peripheralList do
        if (string.lower(wpp.peripheral.getType(peripheralList[peripheralIndex])) == deviceType) then
            logger.logD("Found "..wpp.peripheral.getType(peripheralList[peripheralIndex]).."["..peripheralIndex.."] as index \"["..deviceIndex.."]\" attached as \""..peripheralList[peripheralIndex].."\".")
            deviceNames[deviceIndex] = peripheralList[peripheralIndex]
            deviceList[deviceIndex] = wpp.peripheral.wrap(peripheralList[peripheralIndex])
            deviceIndex = deviceIndex + 1
        end
    end
    return deviceList, deviceNames
end

local function findMonitors()
    local monitorList, monitorNames = getDevices("monitor")

    if (#monitorList == 0) then
        print("No monitor found, continuing headless")
    else
        for monitorIndex = 1, #monitorList do
            local monitor, monitorX, monitorY = nil, nil, nil
            monitor = monitorList[monitorIndex]

            if not monitor then
                table.remove(monitorList, monitorIndex)
                if monitorIndex ~= #monitorList then
                    monitorIndex = monitorIndex - 1
                end
                break
            else
                monitor.setTextScale(1.0)
            end
        end
    end
    return monitorList, monitorNames
end

return {init=init, getDevices=getDevices, findMonitors=findMonitors}