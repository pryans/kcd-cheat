-- file IO no longer seems to work on KCD 1.93
-- this file is no longer loaded from main.lua

function cheat:execReset()
  cheat.execList = {}
  cheat.execListIndex = 1
  cheat.execListTimerId = nil
  cheat.execListTimerDelayMs = 0
end

-- ============================================================================
-- processExecList
-- ============================================================================
function cheat:processExecList(nTimerId)
  while true do
    local command = cheat.execList[cheat.execListIndex]
    if command then
      cheat.execListIndex = cheat.execListIndex + 1
      cheat:logInfo("Running command [%s].", tostring(command))
      System.ExecuteCommand(command)
      if cheat.execListTimerDelayMs > 0 then
        cheat.execListTimerI = Script.SetTimer(cheat.execListTimerDelayMs, function(nTimerId) cheat:processExecList(nTimerId) end)
        cheat.execListTimerDelayMs = 0
        return
      end
    else
      cheat:execReset()
      return
    end
  end
end

-- ============================================================================
-- cheat_exec_delay
-- ============================================================================
cheat.cheat_exec_delay_args = {
  ms=function(args,name,showHelp) return cheat:argsGetRequiredNumber(args, name, showHelp, "The number of milliseconds to delay the next command.") end,
}
cheat:createCommand("cheat_exec_delay", "cheat:cheat_exec_delay(%line)", cheat.cheat_exec_delay_args,
  "Sets the number of milliseconds to delay execution of the next command.",
  "1 second delay", "cheat_exec_delay ms:1000")
function cheat:cheat_exec_delay(line)
  local args = cheat:argsProcess(line, cheat.cheat_exec_delay_args)
  local ms, msErr = cheat:argsGet(args, 'ms', nil)
  if not msErr then
    cheat.execListTimerDelayMs = ms
  end
end

-- ============================================================================
-- cheat_exec_file
-- ============================================================================
cheat.cheat_exec_file_args = {
  file=function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "The file to execute.") end
}
cheat:createCommand("cheat_exec_file", "cheat:cheat_exec_file(%line)", cheat.cheat_exec_file_args,
  "Executes a file of console commands. Use an absolute path or\n$8path relative to SteamLibrary\\steamapps\\common\\KingdomComeDeliverance.",
  "Manually run autocheat.txt", "cheat_exec_file file:Data\\autocheat.txt")
function cheat:cheat_exec_file(line)
  local args = cheat:argsProcess(line, cheat.cheat_exec_file_args)
  local filename, filenameErr = cheat:argsGet(args, 'file', nil)
  if not filenameErr then
    local file, fileErr = io.open (filename, "r")
    if not fileErr then
      cheat:logInfo("Loading commands from file [%s].", filename)
      cheat:execReset()
      while true do
        local command = file:read("*line")
        if command then
          table.insert(cheat.execList, command)
        else
          break
        end
      end
      file:close()
      cheat:logInfo("Executing [%d] commands.", #cheat.execList)
      cheat:processExecList(0)
    else
      cheat:logError("Unable to open file [%s].", filename)
    end
  end
end

-- ============================================================================
-- cheat_auto_exec
-- ============================================================================
cheat:createCommand("cheat_auto_exec", "cheat:cheat_auto_exec()", nil,
  "This command does nothing and is here for documentation only.\n$8"..
  "You can run cheat commands automatically when a level loads by placing them in file Data\autocheat.txt.\n$8"..
  "This is useful for commands that are not permanent.")
function cheat:cheat_auto_exec()
  local filename = "Data\\autocheat.txt"
  local file, fileErr = io.open (filename, "r")
  if not fileErr then
    cheat:logInfo("Loading commands from file [%s].", filename)
    cheat:execReset()
    while true do
      local command = file:read("*line")
      if command then
        table.insert(cheat.execList, command)
      else
        break
      end
    end
    file:close()
    cheat:logInfo("Executing [%d] commands.", #cheat.execList)
    cheat:processExecList(0)
  else
    cheat:logWarn("Unable to open file [%s]. You can ignore this if you aren't using autocheat.txt.", filename)
  end
end

-- ============================================================================
-- end
-- ============================================================================
cheat:logDebug("cheat_core_exec.lua loaded")
