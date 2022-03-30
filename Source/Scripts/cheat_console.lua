-- ============================================================================
-- createCommand
-- ============================================================================
function cheat:createCommand(cmdName, cmdFunc, cmdArgsSet, cmdDocs, ...)
  local cmdHelp = "$8" .. cmdDocs .. "$8\n"
  
  if cmdArgsSet then
    cmdHelp = cmdHelp .. "\n$8Arguments:$8\n"
    for key,val in pairs(cmdArgsSet) do
      cmdHelp = cmdHelp .. "\t$6" .. tostring(key) .. ": $5" .. tostring(val(nil, key, true))  .. "\n"
    end
  end
  
  local examples = cheat:packTable(...)
  if examples and #examples > 0 then
    --cheat:logDebug("examples = " .. tostring(#examples))
    cmdHelp = cmdHelp .. "\n$8Examples:$8\n"
    local i = 1
    while i < examples.n do
      cmdHelp = cmdHelp .. "\t$6" .. tostring(examples[i]) .. ":\n\t$5" .. tostring(examples[i+1]) .. "\n\n"
      --cheat:logDebug(cmdHelp)
      i = i + 2
    end
  end
  
  if cheat.isCommandLineBuild then
    cmdHelp = " \n \n[size=4][b]" .. cmdName .. "[/b][/size]" .. "\n" .. cmdHelp
    cmdHelp = cmdHelp:gsub("$8Arguments:$8", "[b]Arguments:[/b]")
    cmdHelp = cmdHelp:gsub("$8Examples:$8", "[b]Examples:[/b]")
    
    for i=1,9 do
      cmdHelp = cmdHelp:gsub("$" .. tostring(i),"")
    end
    
    --print(cmdHelp)
    
    helpFile = io.open (cheat.devHome .. "/Source/Docs/help.txt", "a+")
    helpFile:write(cmdHelp)
    helpFile:flush()
    helpFile:close()
    
    table.insert(cheat.commands, cmdName)
  end
  
  System.AddCCommand(cmdName, cmdFunc, cmdHelp)
end

-- ============================================================================
-- cheat_eval
-- ============================================================================
cheat:createCommand("cheat_eval", "cheat:cheat_eval(%line)", nil,
  "Executes the given Lua code. This is not a cheat it is used for testing and debugging.",
  "Dump all methods on the cheat table", "cheat_eval cheat:print_methods(cheat)",
  "Dump all methods on player metatable", "cheat_eval cheat:print_methods(getmetatable(player))",
  "Log the value of something to the console", "cheat_eval cheat:logInfo(tostring(player.soul:GetState(\"health\")))")
function cheat:cheat_eval(line)
  cheat:logDebug("Begin eval [%s].", tostring(line))
  --Defining a function from the string and run it
  local func = load(line)
  System.LogAlways(tostring(func()))
  cheat:logDebug("End eval [%s].", tostring(line))
  return true
end

-- ============================================================================
-- cheat_save
-- ============================================================================
cheat:createCommand("cheat_save", "cheat:cheat_save()", nil,
  "This instantly saves your game. No item requirements or save limits.",
  "Save your game", "cheat_save")
function cheat:cheat_save()
  -- probably not needed..
  Game.RemoveSaveLock()
  if not Game.IsLoadingEngineSaveGame() then
    Game.SaveGameViaResting()
    return true
  else
    cheat:logError("Wait for the game to finish loading.")
  end
  return false
end

-- ============================================================================
-- cheat timer system
-- ============================================================================
cheat.g_cheat_timer_id = nil
cheat.g_cheat_timer_period_millis = 1000
cheat.g_cheat_timer_callbacks = {}

function cheat:cheat_timer_callback(nTimerId)
  --cheat:logDebug("cheat_timer_callback")
  cheat.g_cheat_timer_id = Script.SetTimer(cheat.g_cheat_timer_period_millis, function(nTimerId) cheat:cheat_timer_callback(nTimerId) end)
  for key,value in pairs(cheat.g_cheat_timer_callbacks) do
    --cheat:logDebug("call [%s]", tostring(key))
    value()
  end
end

function cheat:cheat_timer(enabled)
  if enabled == true and cheat.g_cheat_timer_id == nil then
    cheat.g_cheat_timer_id = Script.SetTimer(cheat.g_cheat_timer_period_millis,  function(nTimerId) cheat:cheat_timer_callback(nTimerId) end)
    cheat:logDebug("cheat timer on [%s] every [%s] ms", tostring(cheat.g_cheat_timer_id), tostring(cheat.g_cheat_timer_period_millis))
  end
  
  if enabled == false and cheat.g_cheat_timer_id ~= nil then
    Script.KillTimer(cheat.g_cheat_timer_id)
    cheat.g_cheat_timer_id = nil
    cheat:logInfo("cheat timer off")
  end
end

function cheat:cheat_timer_register(name, func)
  cheat.g_cheat_timer_callbacks[name] = func
end

-- ============================================================================
-- uiActionListener
-- ============================================================================
function cheat:uiActionListener(actionName, eventName, argTable)
  cheat:logDebug("ui-al: actionName[%s] eventName[%s]", tostring(actionName), tostring(eventName))
  if argTable then
    cheat:tprint(argTable)
  end
  
  if actionName == "sys_loadingimagescreen" and eventName == "OnEnd" then
    cheat:initOnLevelLoad()
  end
end
UIAction.RegisterActionListener(cheat, "", "", "uiActionListener")

-- ============================================================================
-- uiElementListener
-- ============================================================================
function cheat:uiElementListener(elementName, instanceId, eventName, argTable)
  cheat:logDebug("ui-el: elementName[%s] instanceId[%s] eventName[%s]", tostring(elementName), tostring(instanceId), tostring(eventName))
  if argTable then
    cheat:tprint(argTable)
  end
end
UIAction.RegisterElementListener(cheat, "", "", "", "uiElementListener")

-- ============================================================================
-- uiEventSystemListener
-- ============================================================================
function cheat:uiEventSystemListener(actionName, eventName, argTable)
  cheat:logDebug("ui-esl: actionName[%s] eventName[%s]", tostring(actionName), tostring(eventName))
  if argTable then
    cheat:tprint(argTable)
  end
end
UIAction.RegisterEventSystemListener(cheat, "", "", "uiEventSystemListener")

-- ============================================================================
-- end
-- ============================================================================
cheat:logDebug("cheat_console.lua loaded")
