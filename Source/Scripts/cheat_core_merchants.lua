-- ============================================================================
-- cheat_set_all_merchants_fence
-- ============================================================================
cheat.cheat_set_all_merchants_fence_args = {
  enable = function(args,name,showHelp) return cheat:argsGetRequiredBoolean(args, name, showHelp, "true or false") end,
}

cheat:createCommand("cheat_set_all_merchants_fence", "cheat:cheat_set_all_merchants_fence(%line)", cheat.cheat_set_all_merchants_fence_args,
  "Flags all merchants so they accept stolen goods.\n$8Restarting the game reverts this effect.",
  "Turn it on", "cheat_set_all_merchants_fence enable:true",
  "Turn it off", "cheat_set_all_merchants_fence enable:false")
function cheat:cheat_set_all_merchants_fence(line)
  local args = cheat:argsProcess(line, cheat.cheat_set_all_merchants_fence_args)
  local enable, enableErr = cheat:argsGet(args, 'enable')
  if not enableErr then
    SocialClass.defaultValues.dealsWithStolenItems = enable
    cheat:logInfo("default dealsWithStolenItems[%s]", tostring(enable))
    
    for socialClassName,socialClassTable in pairs(SocialClass.data) do
      socialClassTable["dealsWithStolenItems"] = enable
      cheat:logInfo("%s dealsWithStolenItems[%s]", tostring(socialClassName), tostring(enable))
    end
    
    cheat:logInfo("Done.")
    return true
  end
  return false
end

-- ============================================================================
-- end
-- ============================================================================
cheat:logDebug("cheat_core_merchants.lua loaded")
