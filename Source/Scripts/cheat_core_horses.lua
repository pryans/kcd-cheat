-- ============================================================================
-- find_horse
-- ============================================================================
function cheat:find_horse(searchKey)
  local searchKeyUpper = cheat:toUpper(searchKey)
  local horsesData = {}
  local horse_name = nil
  for stableCode, stableData in pairs(Horsetraders.__data__.stables) do
    for _, horseData in pairs(stableData.horses) do
      table.insert(horsesData, horseData)
    end
  end
  for _, horseData in ipairs(horsesData) do
    local entity = System.GetEntityByName(horseData.name)
    if entity then
      local agi = tostring(entity.soul:GetStatLevel('agi'))
      local cou = tostring(entity.soul:GetStatLevel('cou'))
      local str = tostring(entity.soul:GetStatLevel('str'))
      local vit = tostring(entity.soul:GetStatLevel('vit'))
      local total = tostring(tonumber(agi) + tonumber(cou) + tonumber(str) + tonumber(vit))
      
      local found = false
      if not cheat:isBlank(searchKeyUpper) then
        if string.find(cheat:toUpper(horseData.name), searchKeyUpper, 1, true) then
          found = true
        end
      else
        found = true
      end
      
      if found then
        horse_name = horseData.name
        cheat:logInfo("Found horse [%s] agi[%s] cou[%s] str[%s] vit[%s] total[%s].", tostring(horse_name), agi, cou, str, vit, total)
      end
    else
      cheat:logError("Horse [%s] not found (entity couldn't be loaded/found, load the level?).", tostring(horseData.name))
    end
  end
  cheat:logDebug("Returning horse [%s].", tostring(horse_name))
  return horse_name
end

-- ============================================================================
-- show_horse_stats
-- ============================================================================
function cheat:show_horse_stats()
  local entity = XGenAIModule.GetEntityByWUID(player.player:GetPlayerHorse());
  if entity then
    -- none of these can be changed at runtime it seems
    local agi = tostring(entity.soul:GetStatLevel('agi')) -- confirmed 17
    local cou = tostring(entity.soul:GetStatLevel('cou')) -- confirmed 17.85
    local str = tostring(entity.soul:GetStatLevel('str')) -- confirmed 17
    local vit = tostring(entity.soul:GetStatLevel('vit')) -- confirmed 17
    local health = tostring(entity.soul:GetState("health")) -- confirmed 100 (same as entity.actor:GetHealth())
    local stamina = tostring(entity.soul:GetState("stamina")) -- confirmed 450
    local capacity = tostring(entity.soul:GetDerivedStat("cap")) --confirmed 268
    local walk = tostring(entity.AIMovementAbility.walkSpeed)
    local run = tostring(entity.AIMovementAbility.runSpeed)
    local sprint = tostring(entity.AIMovementAbility.sprintSpeed)
    cheat:logInfo("horse agi[%s] cou[%s] str[%s] vit[%s] health[%s] stamina[%s] cap[%s] walk[%s] run[%s] sprint[%s]", agi, cou, str, vit, health, stamina, capacity, walk, run, sprint)
  end
end

-- ============================================================================
-- cheat_find_horses
-- ============================================================================
cheat.cheat_find_horses_args = {
  token = function(args,name,showHelp) return cheat:argsGetOptional(args, name, nil, showHelp, "All or part of a horse's name. Leave blank to list all horses.") end
}

cheat:createCommand("cheat_find_horses", "cheat:cheat_find_horses(%line)", cheat.cheat_find_horses_args,
  "Find and display stats of horses.",
  "List all horses", "cheat_find_horses token:",
  "Find all horses in MRH stable", "cheat_find_horses token:mrh")
function cheat:cheat_find_horses(line)
  local args = cheat:argsProcess(line, cheat.cheat_find_horses_args)
  local token, tokenErr = cheat:argsGet(args, "token")
  if not tokenErr then
    cheat:find_horse(token)
  end
end

-- ============================================================================
-- cheat_set_horse
-- ============================================================================
cheat.cheat_set_horse_args = {
  id = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "The UUID or all or part of a horse's name (last match is used).") end
}

cheat:createCommand("cheat_set_horse", "cheat:cheat_set_horse(%line)", cheat.cheat_set_horse_args,
  "Sets the player's horse. Use command cheat_find_horses to display a list of horse UUIDs.",
  "Set horse by name part", "cheat_set_horse id:mrh_05",
  "Remove horse", "cheat_set_horse id:nil")
function cheat:cheat_set_horse(line)
  local args = cheat:argsProcess(line, cheat.cheat_set_horse_args)
  local id, idErr = cheat:argsGet(args, "id")
  local gender = player.soul:GetGender()
  if not idErr and gender ~= 2 then
    if id == 'nil' then
      player.player:SetPlayerHorse(__null)
      cheat:logInfo("Removed player horse.")
      return true
    end
    local horseName = cheat:find_horse(id)
    local horse = System.GetEntityByName(horseName)
    player.player:SetPlayerHorse(horse.id)
    cheat:logInfo("Set player horse to [%s].", tostring(horseName))
    cheat:show_horse_stats()
    return true
  else
    cheat:logError("Thereza can't own a horse!")
  end
  return false
end

-- ============================================================================
-- cheat_teleport_horse
-- ============================================================================
cheat:createCommand("cheat_teleport_horse", "cheat:cheat_teleport_horse()", nil,
  "Teleports your horse to you.",
  "Teleport your horse to you", "cheat_teleport_horse")
function cheat:cheat_teleport_horse()
  local horse = XGenAIModule.GetEntityByWUID(player.player:GetPlayerHorse());
  local playerPosition = player:GetWorldPos();
  local gender = player.soul:GetGender()
  if horse and gender  ~= 2 then
    horse:SetWorldPos({x=playerPosition.x-1, y=playerPosition.y-1, z=playerPosition.z});
    cheat:logInfo("Teleported your horse to you.")
  elseif gender == 2 then
    cheat:logError("Theresa doesn't own a horse!")
  else
    cheat:logError("You don't have a horse.")
  end
end

-- ============================================================================
-- end
-- ============================================================================
cheat:logDebug("cheat_core_horses.lua loaded")
