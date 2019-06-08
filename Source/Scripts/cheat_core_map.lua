-- ============================================================================
-- cheat_show_map
-- ============================================================================
cheat:createCommand("cheat_reveal_map", "cheat:cheat_show_map()", nil,
  "Reveals the entire map (removes fog of war).",
  "Reveal the entire map", "cheat_show_map")
function cheat:cheat_show_map()
  cheat:cheat_add_perk("id:34e03c47-de53-482f-b3f5-555e7e36d70c")
  cheat:logInfo("Map revealed.")
  return true
end

-- ============================================================================
-- end
-- ============================================================================
cheat:logDebug("cheat_core_map.lua loaded")
