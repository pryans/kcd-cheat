if cheat.isCommandLineBuild then  
  System = {}
  System["AddCCommand"] = function(cmdName, cmdFunc, cmdHelp)
    --cheat:logDebug("Fake System.AddCCommand(%s, %s, %s) called . ", cmdName, cmdFunc, cmdHelp)
  end
  
  System["LogAlways"] = function()
    --cheat:logDebug("Fake System.LogAlways called.")
  end
  
  System["ExecuteCommand"] = function()
    --cheat:logDebug("Fake System.ExecuteCommand called.")
  end
  
  Script = {}
  Script["SetTimer"] = function()
    --cheat:logDebug("Fake Script.SetTimer called.")
  end
  
  UIAction = {}
  UIAction["RegisterActionListener"] = function()
    --cheat:logDebug("Fake UIAction.RegisterActionListener called.")
  end
  
  UIAction["RegisterElementListener"] = function()
    --cheat:logDebug("Fake UIAction.RegisterElementListener called.")
  end
  
  UIAction["RegisterEventSystemListener"] = function()
    --cheat:logDebug("Fake UIAction.RegisterEventSystemListener called.")
  end
  
  cheat:logWarn("Stubs Active")
  
  -- ============================================================================
  -- end
  -- ============================================================================
  cheat:logDebug("cheat_stubs.lua loaded")
end