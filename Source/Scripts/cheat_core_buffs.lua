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

  for i=0,rows do
    local buffInfo = Database.GetTableLine(tableName, i)
    local found = false

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
  token=function(args,name,showHelp) return cheat:argsGetOptional(args, name, nil, showHelp, "All or part of a the buff's name. Leave empty to list all buffs.") end
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
  id=function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "The buff ID or all or part of a the buff's name. Uses last match from cheat_find_buffs.") end
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
-- cheat_remove_buff
-- ============================================================================
cheat.cheat_remove_buff_args = {
  id=function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "The buff ID or all or part of a the buff's name. Uses last match from cheat_find_buffs.") end
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
  "Adds buffs to make the player immortal. Use cheat_remove_buff_immortal to remove this.",
  "Add immortality", "cheat_add_buff_immortal")
function cheat:cheat_add_buff_immortal()
  cheat:cheat_add_buff_heal()
  cheat:cheat_add_buff("id:85aca9c5-ec41-400d-a563-53df7b2399e8")
  cheat:cheat_add_buff("id:7ead0083-026d-4567-80b3-68ac82693b77")
  cheat:cheat_add_buff("id:98d2764a-bdbf-473f-903a-1209813d2e15")
  cheat:cheat_add_buff("id:6cf0aa39-e09c-42fa-bf67-10f2d03991b7")
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
  cheat:cheat_remove_buff("id:85aca9c5-ec41-400d-a563-53df7b2399e8")
  cheat:cheat_remove_buff("id:7ead0083-026d-4567-80b3-68ac82693b77")
  cheat:cheat_remove_buff("id:98d2764a-bdbf-473f-903a-1209813d2e15")
  cheat:cheat_remove_buff("id:6cf0aa39-e09c-42fa-bf67-10f2d03991b7")
  cheat:logInfo("Immortality buffs removed.")
  return true
end

-- ============================================================================
-- cheat_add_buff_invisible
-- ============================================================================
cheat:createCommand("cheat_add_buff_invisible", "cheat:cheat_add_buff_invisible()", nil,
  "Adds invisible buff to player. For now this just sets conspicuousness to zero.\n$8Use cheat_remove_buff_invisible to remove this.",
  "Add invisible buff to player", "cheat_add_buff_invisible")
function cheat:cheat_add_buff_invisible()
  cheat:cheat_add_buff("id:cf787871-d151-43b7-a7c9-39acac116f0f") -- vib=-10,con=-10
  cheat:cheat_add_buff("id:07db9dfd-0e0c-4cbe-bf8a-10aaa1add262") -- ors=-1
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
  cheat:cheat_remove_buff("id:cf787871-d151-43b7-a7c9-39acac116f0f")
  cheat:cheat_remove_buff("id:07db9dfd-0e0c-4cbe-bf8a-10aaa1add262")
  cheat:logInfo("Invisibility buff removed.")
  return true
end

-- ============================================================================
-- end
-- ============================================================================
cheat:logDebug("cheat_core_buffs.lua loaded")
