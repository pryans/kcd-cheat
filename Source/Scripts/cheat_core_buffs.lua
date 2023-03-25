--[[
  -- Some buff_class_ids shouldn't be applied to the player after the game is loaded
  <row buff_class_id="0" buff_class_name="Testing Stat Buff" />
  <row buff_class_id="1" buff_class_name="System Buff" />
  <row buff_class_id="2" buff_class_name="Weapon Skill Buff" />
  <row buff_class_id="3" buff_class_name="Testing Combat Buff" />
  <row buff_class_id="4" buff_class_name="Perk Buff" />
  <row buff_class_id="5" buff_class_name="Injury" />
  <row buff_class_id="6" buff_class_name="Heal" />
  <row buff_class_id="7" buff_class_name="Poison" />
  <row buff_class_id="8" buff_class_name="Perception" />
  <row buff_class_id="9" buff_class_name="Overeat" />
  <row buff_class_id="10" buff_class_name="Alcohol" />
  <row buff_class_id="12" buff_class_name="Item Buff" />
  <row buff_class_id="13" buff_class_name="Potion" />
  <row buff_class_id="14" buff_class_name="Food Poison" />
  <row buff_class_id="15" buff_class_name="Script System" />
  <row buff_class_id="16" buff_class_name="Unconsciousness" />
  <row buff_class_id="17" buff_class_name="Hangover" />
  <row buff_class_id="18" buff_class_name="Satisfaction" />
]]
-- ============================================================================
-- find_buff
-- ============================================================================
function cheat:find_buff(searchKey, returnAll)
  local tableName = "buff"
  Database.LoadTable(tableName)
  local tableInfo = Database.GetTableInfo(tableName)
  local rows = tableInfo.LineCount - 1
  local searchKeyUpper = cheat:toUpper(searchKey)
  local buff_id = nil
  local buff_name = nil
  local buffs = {}
  local excludedIds = {1, 15}
  
  for i = 0, rows do
    local buffInfo = Database.GetTableLine(tableName, i)
    local found = false
    local skip = false
    
    -- Check if the current buff_id is in the excludedIds array
    for _, excludedId in ipairs(excludedIds) do
      if buffInfo.buff_id == excludedId then
        skip = true
        break
      end
    end
    
    if not skip then
      if not cheat:isBlank(searchKeyUpper) then
        if cheat:toUpper(buffInfo.buff_id) == searchKeyUpper then
          found = true
        end
        
        if string.find(cheat:toUpper(buffInfo.buff_name), searchKeyUpper, 1, true) then
          found = true
        end
      else
        found = true
      end
      
      if found then
        buff_id = buffInfo.buff_id
        buff_name = buffInfo.buff_name
        if returnAll then
          local buff = {}
          buff.buff_id = buff_id
          buff.buff_name = buff_name
          buffs[buff_id] = buff
        end
        cheat:logInfo("Found buff [%s] with id [%s].", tostring(buff_name), tostring(buff_id))
      end
    end
  end
  
  if returnAll then
    cheat:logDebug("Returning [%s] buffs.", tostring(#buffs))
    return buffs
  else
    cheat:logDebug("Returning buff [%s] with id [%s].", tostring(buff_name), tostring(buff_id))
    return buff_id, buff_name
  end
end

-- ============================================================================
-- cheat_find_buffs
-- ============================================================================
cheat.cheat_find_buffs_args = {
  token = function(args,name,showHelp) return cheat:argsGetOptional(args, name, nil, showHelp, "All or part of a the buff's name. Leave empty to list all buffs.") end
}

cheat:createCommand("cheat_find_buffs", "cheat:cheat_find_buffs(%line)", cheat.cheat_find_buffs_args,
  "Finds all of the buffs that match the given token.",
  "Show all buffs", "cheat_find_buffs token:",
  "Show all buffs with 'heal' in their name", "cheat_find_buffs token:heal")
function cheat:cheat_find_buffs(line)
  local args = cheat:argsProcess(line, cheat.cheat_find_buffs_args)
  local token, tokenErr = cheat:argsGet(args, 'token', nil)
  if not tokenErr then
    cheat:find_buff(token)
    return true
  end
  return false
end

-- ============================================================================
-- cheat_add_buff
-- ============================================================================
cheat.cheat_add_buff_args = {
  id = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "The buff ID or all or part of a the buff's name. Uses last match from cheat_find_buffs.") end
}

cheat:createCommand("cheat_add_buff", "cheat:cheat_add_buff(%line)", cheat.cheat_add_buff_args,
  "Adds the given buff to the player.",
  "Adds the last buff with 'heal' in its name", "cheat_add_buff id:heal",
  "Adds the buff poor_hearing buff by ID", "cheat_add_buff id:29336a21-dd76-447b-a4f0-94dd6b9db466",
  "Adds the buff healthEatSleep_instant buff by full name", "cheat_add_buff id:healthEatSleep_instant")
function cheat:cheat_add_buff(line)
  local args = cheat:argsProcess(line, cheat.cheat_add_buff_args)
  local id, idErr = cheat:argsGet(args, 'id')
  if not idErr then
    local buff_id, buff_name = cheat:find_buff(id)
    if not cheat:isBlank(buff_id) then
      player.soul:AddBuff(buff_id)
      cheat:logInfo("Added buff [%s] to player.", tostring(buff_name))
      return true
    else
      cheat:logError("buff [%s] not found.", tostring(id))
    end
  end
  return false
end

-- ============================================================================
-- cheat_add_potion_buff
-- ============================================================================
System.AddCCommand('cheat_add_potion_buff', 'cheat:add_potion_buff(%line)', "Usage: cheat_add_potion_buff id:number\n$8Adds a potion buff to the player. Supported buffs:\n$8 01. Aqua Vitalis\n$8 02. Embrocation\n$8 03. Bowman's Brew\n$8 04. Padfoot\n$8 05. Nighthawk\n$8 06. Bard\n$8 07. Aesop\n$8 08. Chamomile Brew\n$8 09. Marigold Deoction\n$8 10. Lazarus\n$8 11. Amor\n$8 12. Artemesia\n$8 13. Bivoj's Rage\n$8 14. Buck's Blood\n$8 15. Hair o' the Dog")

function cheat:add_potion_buff(line)
  local args = string.gsub(tostring(line), "id:", "")
  local checkteste = "error"
  
  local ids = {}
  ids["01"] = "id:27c2fd6a-9b87-4d1f-b434-44f5ec3fa426"
  ids["02"] = "id:ceb70cbf-9c4e-491a-8d75-7e8ab874db54"
  ids["03"] = "id:736fcb09-5554-4e6b-b3e0-f9bc6cc4fd0a"
  ids["04"] = "id:eacbd986-ad07-4698-bf81-59df608b56a1"
  ids["05"] = "id:fa2ad41e-5701-4fe7-8630-5cee49eb304f"
  ids["06"] = "id:1f398bd2-05ea-4a56-b883-9ac3ba3ad01a"
  ids["07"] = "id:f23dda25-6450-49c8-86f3-fc7bc1236199"
  ids["08"] = "id:679a7453-c1b4-4164-b7e5-8410d682e6da"
  ids["09"] = "id:8503216a-a34c-49f0-aefa-54d4502046f9"
  ids["10"] = "id:7690a860-a843-4609-8a67-9868b87b32b5"
  ids["11"] = "id:2edf8a8e-7eba-49e9-aa29-d3149d78c7fd"
  ids["12"] = "id:cdeed798-e09e-45c5-8523-8df75e8791a6"
  ids["13"] = "id:d0c97def-b9b3-48e7-beab-f46d6bf44d81"
  ids["14"] = "id:122c0e62-747e-4bb3-9650-1a14d0420b08"
  ids["15"] = "id:3f915710-1ccf-41a0-bc7f-67c8cc1a8e7b"
  
  if ids[args] ~= nil then
    cheat:cheat_add_buff(ids[args])
  else
	for k,v in pairs(ids) do
    if string.find(k, args) then
      checkteste = v
    end
	end
	if checkteste ~= "error" then
    cheat:cheat_add_buff(checkteste)
	else
    cheat:logError("Invalid Buff - See list of supported potion buffs: 'cheat_add_potion_buff ?'")
	end
  end
end

-- ============================================================================
-- cheat_remove_buff
-- ============================================================================
cheat.cheat_remove_buff_args = {
  id = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "The buff ID or all or part of a the buff's name. Uses last match from cheat_find_buffs.") end
}

cheat:createCommand("cheat_remove_buff", "cheat:cheat_remove_buff(%line)", cheat.cheat_remove_buff_args,
  "Removes the given buff from the player.",
  "Removes the last buff with 'heal' in its name", "cheat_remove_buff id:heal",
  "Removes the buff poor_hearing buff by ID", "cheat_remove_buff id:29336a21-dd76-447b-a4f0-94dd6b9db466",
  "Removes the buff healthEatSleep_instant buff by full name", "cheat_remove_buff id:healthEatSleep_instant")
function cheat:cheat_remove_buff(line)
  local args = cheat:argsProcess(line, cheat.cheat_remove_buff_args)
  local id, idErr = cheat:argsGet(args, 'id')
  if not idErr then
    local buff_id, buff_name = cheat:find_buff(id)
    if not cheat:isBlank(buff_id) then
      player.soul:RemoveAllBuffsByGuid(buff_id)
      cheat:logInfo("Removed buff [%s] from player.", tostring(buff_name))
      return true
    else
      cheat:logError("buff [%s] not found.", tostring(id))
    end
  end
  return false
end

-- ============================================================================
-- cheat_remove_all_buffs
-- ============================================================================
cheat:createCommand("cheat_remove_all_buffs", "cheat:cheat_remove_all_buffs()", nil,
  "Removes all buffs from the player.",
  "Remove all buffs", "cheat_remove_all_buffs")
function cheat:cheat_remove_all_buffs(line)
  local buffs = cheat:find_buff(id, true)
  for buff_id,buff_name in pairs(buffs) do
    player.soul:RemoveAllBuffsByGuid(buff_id)
    if player.soul:RemoveAllBuffsByGuid(buff_id) then
      cheat:logInfo("Removed buff [%s] from player.", tostring(buff_name))
    end
  end
  cheat:logInfo("All buffs removed.")
  return true
end

-- ============================================================================
-- cheat_add_buff_heal
-- ============================================================================
cheat:createCommand("cheat_add_buff_heal", "cheat:cheat_add_buff_heal()", nil,
  "Stop bleeding, removes injuries, and restores all health, stamina, hunger, and exhaust.",
  "Heal bleeding and injuries", "cheat_add_buff_heal")
function cheat:cheat_add_buff_heal()
  for i=1,6,1 do player.soul:HealBleeding(1, i) end
  cheat:logInfo("Bleeding Stopped.")
  cheat:cheat_add_buff("id:46683e3b-e261-412f-b402-99ee17dda62a")
  cheat:logInfo("Injuries Removed.")
  player.soul:SetState("health", 1000)
  player.soul:SetState("stamina", 1000)
  player.soul:SetState("hunger", 100)
  player.soul:SetState("exhaust", 100)
  return true
end

-- ============================================================================
-- cheat_add_buff_immortal
-- ============================================================================
cheat:createCommand("cheat_add_buff_immortal", "cheat:cheat_add_buff_immortal()", nil,
  "Adds buff to make the player immortal. Use cheat_remove_buff_immortal to remove this.",
  "Add immortality", "cheat_add_buff_immortal")
function cheat:cheat_add_buff_immortal()
  cheat:cheat_add_buff_heal()
  cheat:cheat_add_buff("id:a218af80-b2a5-11ed-afa1-0242ac120002")
  cheat:logInfo("Immortality buffs added.")
  return true
end

-- ============================================================================
-- cheat_remove_buff_immortal
-- ============================================================================
cheat:createCommand("cheat_remove_buff_immortal", "cheat:cheat_remove_buff_immortal()", nil,
  "Removes the buffs making the player immortal.",
  "Remove immortality", "cheat_remove_buff_immortal")
function cheat:cheat_remove_buff_immortal()
  cheat:cheat_remove_buff("id:a218af80-b2a5-11ed-afa1-0242ac120002")
  cheat:logInfo("Immortality buffs removed.")
  return true
end

-- ============================================================================
-- cheat_add_buff_invisible
-- ============================================================================
cheat:createCommand("cheat_add_buff_invisible", "cheat:cheat_add_buff_invisible()", nil,
  "Adds invisible buff to player. Should set visibility, conspicuousness and noise to zero.\n$8Use cheat_remove_buff_invisible to remove this.",
  "Add invisible buff to player", "cheat_add_buff_invisible")
function cheat:cheat_add_buff_invisible()
  cheat:cheat_add_buff("id:a218b534-b2a5-11ed-afa1-0242ac120002") -- tweaked using patched table files
  cheat:logInfo("Invisibility buff added.")
  return true
end

-- ============================================================================
-- cheat_remove_buff_invisible
-- ============================================================================
cheat:createCommand("cheat_remove_buff_invisible", "cheat:cheat_remove_buff_invisible()", nil,
  "Removes invisible buff from player.",
  "Remove invisible buff from player", "cheat_remove_buff_invisible")
function cheat:cheat_remove_buff_invisible()
  cheat:cheat_remove_buff("id:a218b534-b2a5-11ed-afa1-0242ac120002")
  cheat:logInfo("Invisibility buff removed.")
  return true
end

-- ============================================================================
-- end
-- ============================================================================
cheat:logDebug("cheat_core_buffs.lua loaded")
