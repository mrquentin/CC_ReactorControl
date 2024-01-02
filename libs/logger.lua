-- Log levels
local FATAL = 16
local ERROR = 8
local WARN = 4
local INFO = 2
local DEBUG = 1

local debugMode = false
local logfile = nil

local function init(name, isDebug)
    debugMode = isDebug
    logfile = fs.open(name..".log", "w")
    if logfile then
        logfile.writeLine("Minecraft Date: "..os.date("%Y-%m-%d %H:%M:%S"))
    else
        error("Could not open file "..name..".log for writting")
    end
    logfile = fs.open(name..".log", "a")
end

local function printLog(printStr, logLevel)
    logLevel = logLevel or INFO

    if (logLevel == INFO) then
        term.setTextColor(colors.lightGray)
        print(printStr)
        term.setTextColor(colors.white)
    elseif debugMode then
        local color = colors.lightGray
        if (logLevel == WARN) then
            color = color.white
        elseif (logLevel == ERROR) then
            color = colors.red
        elseif (logLevel == FATAL) then
            color = colors.black
            term.setBackgroundColor(colors.red)
        end
        term.setTextColor(color)
        print(printStr)
        term.setBackgroundColor(colors.black)
    end
    if logfile then
        logfile.writeLine(printStr)
    else
        error("Could not open logFile for appending")
    end
end

local function logD(printStr)
    printLog(printStr, DEBUG)    
end

local function logI(printStr)
    printLog(printStr, INFO)    
end

local function logW(printStr)
    printLog(printStr, WARN)    
end

local function logE(printStr)
    printLog(printStr, ERROR)    
end

local function logF(printStr)
    printLog(printStr, FATAL)    
end

return {init=init,logD=logD,logI=logI,logW=logW,logE=logE,logF=logF}