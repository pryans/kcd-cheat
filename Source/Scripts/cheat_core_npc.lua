-- GetEntities
-- GetEntitiesByClass
-- GetEntitiesInSphere
-- GetEntitiesInSphere(self:GetPos(), 50);

--"Localization/english_xml/text_ui_soul_def.xml"
--cheat.soulNames = CryAction.LoadXML("Localization/english_xml/text_ui_soul_def.xml","Localization/english_xml/text_ui_soul.xml");
-- cheat:logInfo("soul name localization table loaded [%s]", tostring(cheat.soulNames))
--cheat:print_methods(cheat.soulNames)
--cheat:logInfo("--")

-- System.GetEntitiesInSphere(player:GetPos(), range)

-- cheat_eval return #System.GetEntitiesByClass("Hare")

-- ============================================================================
-- get_npc_name
-- ============================================================================
function cheat:get_npc_name(npc)
  if npc and npc["GetNpcName"] then
    local name = cheat.soulTextLookup[npc:GetNpcName()]
    if name then
      return name:match("^%s*(.-)%s*$")
    end
  end
  
  if npc and npc["class"] then
    return npc.class
  end
  
  return "UNKNOWN_NAME"
end

-- ============================================================================
-- find_npc
-- ============================================================================
function cheat:find_npc(name, range)
  local searchKey = cheat:toUpper(name)
  local found = {}
  local npcs = nil
  
  if range then
    npcs = System.GetEntitiesInSphere(player:GetPos(), range)
  else
    npcs = System.GetEntities()
  end
  
  for i,npc in pairs(npcs) do
    local isActor = npc and npc["actorStats"] ~= nil
    if isActor then
      local npcName = cheat:get_npc_name(npc)
      if npcName then
        --npcName = npcName:match("^%s*(.-)%s*$")
        local npcNameUpper = cheat:toUpper(npcName)
        --cheat:logDebug("Checking NPC [%s] at [%d] against token [%s].", npcNameUpper, i, searchKey)
        if string.find(npcNameUpper, searchKey, 1, true) then
          --cheat:logDebug("Found NPC [%s].", npcName)
          table.insert(found,npc)
        end
      end
    end
  end
  return found
end

-- ============================================================================
-- get_npc_spawn_point
-- ============================================================================
function cheat:get_npc_spawn_point(isPlayerPosition,xPos,yPos,zPos,radius)
  if not radius or radius == 0 then
    radius = 5
  end
  
  while true do
    local spawnX = math.random(xPos-radius,xPos+radius)
    local spawnY = math.random(yPos-radius,yPos+radius)
    if isPlayerPosition then
      if spawnX ~= xPos and spawnY ~= yPos then
        -- make sure spawn point isn't on top of the player
        return {x=spawnX, y=spawnY, z=zPos}
      end
    else
      return {x=spawnX, y=spawnY, z=zPos}
    end
  end
end

-- ============================================================================
-- cheat_kill_npc
-- ============================================================================
cheat.cheat_kill_npc_args = {
  token = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "All or part of a the NPC's name.") end,
  radius = function(args,name,showHelp) return cheat:argsGetOptionalNumber(args, name, 5, showHelp, "The kill radius around player. Default 5.") end,
}

cheat:createCommand("cheat_kill_npc", "cheat:cheat_kill_npc(%line)", cheat.cheat_kill_npc_args,
  "Finds and kills all the killable NPCs within the given radius of the player.",
  "Kill Father Godwin", "cheat_kill_npc token:Father Godwin radius:2",
  "Kill all bandits near the player", "cheat_kill_npc token:bandit radius:10")
function cheat:cheat_kill_npc(line)
  local args = cheat:argsProcess(line, cheat.cheat_kill_npc_args)
  local token, tokenErr = cheat:argsGet(args, 'token', nil)
  local radius, radiusErr = cheat:argsGet(args, 'radius', nil)
  if not tokenErr and not radiusErr then
    local npcs = cheat:find_npc(token, radius)
    if npcs and #npcs > 0 then
      for i,npc in ipairs(npcs) do
        local npcName = cheat:get_npc_name(npc)
        npc.soul:DealDamage(9999,9999)
        cheat:logInfo("Killed NPC [%s] at position x=%d y=%d z=%d",
        npcName,
        npc:GetWorldPos().x,
        npc:GetWorldPos().y,
        npc:GetWorldPos().z)
      end
    else
      cheat:logError("NPC [%s] not found.", token)
    end
  end
end

-- ============================================================================
-- cheat_resurrect_npc
-- ============================================================================
cheat.cheat_resurrect_npc_args = {
  token = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "All or part of a the NPC's name.") end,
  radius = function(args,name,showHelp) return cheat:argsGetOptionalNumber(args, name, 5, showHelp, "The resurrect radius around player. Default 5.") end,
}

cheat:createCommand("cheat_resurrect_npc", "cheat:cheat_resurrect_npc(%line)", cheat.cheat_resurrect_npc_args,
  "Finds and resurrects all the dead NPCs within the given radius of the player.",
  "Resurrect Father Godwin", "cheat_resurrect_npc token:Father Godwin radius:2",
  "Resurrects all bandits near the player", "cheat_resurrect_npc token:bandit radius:10")
function cheat:cheat_resurrect_npc(line)
  local args = cheat:argsProcess(line, cheat.cheat_resurrect_npc_args)
  local token, tokenErr = cheat:argsGet(args, 'token', nil)
  local radius, radiusErr = cheat:argsGet(args, 'radius', nil)
  if not tokenErr and not radiusErr then
    local npcs = cheat:find_npc(token, radius)
    if npcs and #npcs > 0 then
      for i,npc in ipairs(npcs) do
		if npc:IsDead() then
          local npcName = cheat:get_npc_name(npc)
		  local pos = npc:GetWorldPos()
          npc.actor:ReviveToDefaults()
		  pos = cheat:get_npc_spawn_point(false, pos.x, pos.y, pos.z, 1)
		  npc:SetWorldPos(pos)
          cheat:logInfo("Resurrected NPC [%s] at position x=%d y=%d z=%d",
          npcName,
          pos.x,
          pos.y,
          pos.z)
		end
      end
    else
      cheat:logError("NPC [%s] not found.", token)
    end
  end
end

-- ============================================================================
-- cheat_find_npc
-- ============================================================================
cheat.cheat_find_npc_args = {
  token = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "All or part of a the NPC's name.") end
}

cheat:createCommand("cheat_find_npc", "cheat:cheat_find_npc(%line)", cheat.cheat_find_npc_args,
  "Finds and shows information about an NPC.\n$8This only works if the NPC has been loaded into the world.",
  "Find Father Godwin", "cheat_find_npc token:godwin")
function cheat:cheat_find_npc(line)
  local args = cheat:argsProcess(line, cheat.cheat_find_npc_args)
  local token, tokenErr = cheat:argsGet(args, 'token', nil)
  if not tokenErr then
    local npcs = cheat:find_npc(token)
    if npcs and #npcs > 0 then
      for i,npc in ipairs(npcs) do
        local npcName = cheat:get_npc_name(npc)
        cheat:logInfo("Found NPC [%s] at position x=%d y=%d z=%d",
        npcName,
        npc:GetWorldPos().x,
        npc:GetWorldPos().y,
        npc:GetWorldPos().z)
      end
    else
      cheat:logError("NPC [%s] not found.", token)
    end
  end
end

-- ============================================================================
-- cheat_teleport_npc_to_loc
-- ============================================================================
cheat.cheat_teleport_npc_to_loc_args = {
  token = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "All or part of a the NPC's name.") end,
  x = function(args,name,showHelp) return cheat:argsGetRequiredNumber(args, name, showHelp, "X coordinate.") end,
  y = function(args,name,showHelp) return cheat:argsGetRequiredNumber(args, name, showHelp, "Y coordinate.") end,
  z = function(args,name,showHelp) return cheat:argsGetRequiredNumber(args, name, showHelp, "Z coordinate.") end,
  radius = function(args,name,showHelp) return cheat:argsGetOptionalNumber(args, name, 5, showHelp, "The teleport radius around the x,y,z target. Default 5.") end,
  max = function(args,name,showHelp) return cheat:argsGetOptionalNumber(args, name, 10, showHelp, "The maximum NPCs to teleport. Default 10.") end
}

cheat:createCommand("cheat_teleport_npc_to_loc", "cheat:cheat_teleport_npc_to_loc(%line)", cheat.cheat_teleport_npc_to_loc_args,
  "Teleports one or more NPCs to the given coordinates. Use cheat_loc to get locations.",
  "Teleport Father Godwin to somewhere...", "cheat_teleport_npc_to_loc token:Father_Godwin x:1 y:2 z:3")
function cheat:cheat_teleport_npc_to_loc(line)
  local args = cheat:argsProcess(line, cheat.cheat_teleport_npc_to_loc_args)
  local token, tokenErr = cheat:argsGet(args, 'token', nil)
  local x, xErr = cheat:argsGet(args, 'x', nil)
  local y, yErr = cheat:argsGet(args, 'y', nil)
  local z, zErr = cheat:argsGet(args, 'z', nil)
  local radius, radiusErr = cheat:argsGet(args, 'radius', nil)
  local max, maxErr = cheat:argsGet(args, 'max', nil)
  if not tokenErr and not xErr and not yErr and not zErr and not radiusErr and not maxErr then
    local npcs = cheat:find_npc(token)
    if npcs and #npcs > 0 then
      local spawnCount = 0
      for i,npc in ipairs(npcs) do
        if spawnCount < max then
          local npcName = cheat:get_npc_name(npc)
          npc:SetWorldPos(cheat:get_npc_spawn_point(false, x, y, z, radius));
          spawnCount = spawnCount + 1
          cheat:logInfo("Teleported NPC [%s] to position x=%d y=%d z=%d",
          npcName,
          npc:GetWorldPos().x,
          npc:GetWorldPos().y,
          npc:GetWorldPos().z)
        else
          break
        end
      end
    else
      cheat:logError("NPC(s) [%s] not found.", token)
    end
  end
end

-- ============================================================================
-- cheat_teleport_npc_to_player
-- ============================================================================
cheat.cheat_teleport_npc_to_player_args = {
  token = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "All or part of a the NPC's name.") end,
  radius = function(args,name,showHelp) return cheat:argsGetOptionalNumber(args, name, 5, showHelp, "The teleport radius around the player. Default 5.") end,
  max = function(args,name,showHelp) return cheat:argsGetOptionalNumber(args, name, 10, showHelp, "The maximum NPCs to teleport. Default 10.") end
}

cheat:createCommand("cheat_teleport_npc_to_player", "cheat:cheat_teleport_npc_to_player(%line)", cheat.cheat_teleport_npc_to_player_args,
  "Teleports one or more NPCs to the player's location.",
  "Teleport Father Godwin to ???", "cheat_teleport_npc_to_loc token:Father_Godwin x:1 y:2 z:3")
function cheat:cheat_teleport_npc_to_player(line)
  local args = cheat:argsProcess(line, cheat.cheat_teleport_npc_to_player_args)
  local token, tokenErr = cheat:argsGet(args, 'token', nil)
  local radius, radiusErr = cheat:argsGet(args, 'radius', nil)
  local max, maxErr = cheat:argsGet(args, 'max', nil)
  if not tokenErr and not radiusErr and not maxErr then
    local playerPosition = player:GetWorldPos();
    local npcs = cheat:find_npc(token)
    local spawnCount = 0
    if npcs and #npcs > 0 then
      for i,npc in ipairs(npcs) do
        if spawnCount < max then
          local npcName = cheat:get_npc_name(npc)
          npc:SetWorldPos(cheat:get_npc_spawn_point(true, playerPosition.x, playerPosition.y, playerPosition.z, radius));
          spawnCount = spawnCount + 1
          cheat:logInfo("Teleported NPC [%s] to position x=%d y=%d z=%d",
          npcName,
          npc:GetWorldPos().x,
          npc:GetWorldPos().y,
          npc:GetWorldPos().z)
        else
          break
        end
      end
    else
      cheat:logError("NPC(s) [%s] not found.", token)
    end
  end
end

-- ============================================================================
-- cheat_target_entity
-- ============================================================================
cheat:createCommand("cheat_target_entity", "cheat:cheat_target_entity()", nil,
  "Tracks the entity being targeted by the player.\n$8" ..
  "This will allow you to use other commands on the entity.\n$8"..
  "This command is bound to the F4 key.")
cheat.entity_target = nil
function cheat:cheat_target_entity()
  local from = player:GetPos();
  from.z = from.z + 1.615;
  
  local dir = System.GetViewCameraDir(); 
  dir = vecScale(dir, 50);
  
  local skip = player.id;
  
  local hitData = {};
  local hits = Physics.RayWorldIntersection(from, dir, 1, ent_all, skip, nil, hitData);
  cheat:logDebug("hits=" .. tostring(hits))
  cheat:logDebug("foundent=" .. tostring( hits > 0 and hitData[1].entity))
  cheat:print_methods(hitData[1])
  
  if hits > 0 and hitData[1].entity then
    local entity = hitData[1].entity
    cheat.entity_target = entity
    cheat:logInfo("Targeted entity [%s] (class=[%s] id=[%s]).", tostring(entity:GetName()), tostring(entity.class), tostring(entity.this.id))
  end
end

-- ============================================================================
-- cheat_kill_target
-- ============================================================================
cheat:createCommand("cheat_kill_target", "cheat:cheat_kill_target()", nil,
  "Kills the entity targeted using by F4 or the cheat_target_entity command.")
function cheat:cheat_kill_target()
  if cheat.entity_target then
    if cheat.entity_target.soul then
      cheat.entity_target.soul:DealDamage(9999,9999)
      cheat:logInof("Entity killed.")
    else
      cheat:logError("Targeted entity has no soul, can't kill it.")
    end
  else
    cheat:logError("You don't have a targt, use F4 or cheat_target_entity command.")
  end
end

-- ============================================================================
-- find_soul
-- ============================================================================
function cheat:find_soul(searchKey, returnAll)
  local tableName = "v_soul_character_data"
  Database.LoadTable(tableName)
  local tableInfo = Database.GetTableInfo(tableName)
  local rows = tableInfo.LineCount - 1
  local searchKeyUpper = cheat:toUpper(searchKey)
  local soul_id = nil
  local soul_ui_name = nil
  local soul_name = nil
  local souls = {}
  
  for i=0,rows do
    local rowInfo = Database.GetTableLine(tableName, i)
    local found = false
    soul_id = nil
    soul_ui_name = nil
    soul_name = nil
    
    if not cheat:isBlank(searchKeyUpper) then
      if cheat:toUpper(rowInfo.soul_id) == searchKeyUpper then
        found = true
      end
      
      if not found then
        if string.find(cheat:toUpper(rowInfo.name_string_id), searchKeyUpper, 1, true) then
          found = true
        end
      end
      
      if not found then
        soul_name = cheat.soulTextLookup[rowInfo.name_string_id]
        if soul_name then
          if string.find(cheat:toUpper(soul_name), searchKeyUpper, 1, true) then
            found = true
          end
        end
      end
    else
      found = true
    end
    
    if found then
      soul_id = rowInfo.soul_id
      soul_ui_name = rowInfo.name_string_id
      if not soul_name then
        soul_name = cheat.soulTextLookup[soul_ui_name]
      end
      
      if returnAll then
        local soul={}
        soul.soul_id = soul_id
        soul.soul_ui_name = soul_ui_name
        soul.soul_name = soul_name
        table.insert(souls, soul)
      end
      cheat:logInfo("Found soul [%s] ([%s]) with id [%s].", tostring(soul_name), tostring(soul_ui_name), tostring(soul_id))
    end
  end
  
  if returnAll then
    cheat:logDebug("Returning [%s] souls.", tostring(#souls))
    return souls
  else
    cheat:logDebug("Returning soul [%s] ([%s]) with id [%s].", tostring(soul_name), tostring(soul_ui_name), tostring(soul_id))
    return soul_id, soul_ui_name, soul_name
  end
end

-- ============================================================================
-- cheat_spawn_entity
-- ============================================================================
cheat.spawn_counter = 0
function cheat:cheat_spawn_entity(entityName, entityClass, entitySoul, entityPos, entityDir)
  if not entityName then
    entityName = entityClass .. tostring(cheat.spawn_counter)
    cheat.spawn_counter = cheat.spawn_counter + 1
  end
  
  if not entityPos then
    local playerPosition = player:GetWorldPos();
    entityPos = cheat:get_npc_spawn_point(true, playerPosition.x, playerPosition.y, playerPosition.z, 5)
  end
  
  if not entityDir then
    entityDir = player:GetWorldPos();
  end
  
  local spawnParams = {}
  spawnParams.class = entityClass
  spawnParams.position = entityPos
  spawnParams.orientation = entityDir
  spawnParams.name = entityName
  spawnParams.properties = {}
  spawnParams.properties.sharedSoulGuid = entitySoul
  
  local spawnedEnt = System.SpawnEntity(spawnParams)
  if spawnedEnt then
    cheat:logDebug("Spawned entity [%s] of type [%s].", entityName, entityClass)
    --spawnedEnt.OnSpawn(false)
  end
end

-- ============================================================================
-- cheat_spawn
-- ============================================================================
--[[
<AddLink From="&quot;spawnEnt&quot;" To="&quot;this.id&quot;" Tag="&quot;animalSpawner&quot;" Data="&quot;&quot;" LinkOpHandleMode="&quot;Error&quot;" />
entity:CreateLink(?)
Entity.CreateLink( name, targetId )
name	Name of the link. Does not have to be unique among all the links of this entity. Multiple links with the same name can perfectly co-exist.
(optional) targetId	If specified, the ID of the entity the link shall target. If not specified or 0 then the link will not target anything. Default value: 0
--]]
cheat.cheat_spawn_args = {
  class = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "bandit|cuman|hare|horse|boar|sheep|pig|cow|buck|doe|reddeer") end,
  count = function(args,name,showHelp) return cheat:argsGetOptionalNumber(args, name, 1, showHelp, "Number of things to spawn. Default 1.") end,
  radius = function(args,name,showHelp) return cheat:argsGetOptionalNumber(args, name, 5, showHelp, "The spawn radius around the player. Default 5.") end
}

cheat:createCommand("cheat_spawn", "cheat:cheat_spawn(%line)", cheat.cheat_spawn_args,
  "Spawns bandits, cuman, or animals.\n$8"..
  "For some reason most of the animals and some bandits/cuman just stand around. No idea why.\n$8"..
  "The spawned entities are not managed so you should kill them off or load a clean save.",
  "Spawn 10 bandits", "cheat_spawn class:bandit count:10")
function cheat:cheat_spawn(line)
  local args = cheat:argsProcess(line, cheat.cheat_spawn_args)
  local class, classErr = cheat:argsGet(args, 'class', nil)
  local count, countErr = cheat:argsGet(args, 'count', nil)
  local radius, radiusErr = cheat:argsGet(args, 'radius', nil)
  if not classErr and not countErr and not radiusErr then
    
    local playerPosition = player:GetWorldPos();
    
    local key = cheat:toUpper(class)
    if key == "HARE" then
      for i=0,count do
        local entityPos = cheat:get_npc_spawn_point(true, playerPosition.x, playerPosition.y, playerPosition.z, radius)
        cheat:cheat_spawn_entity(nil, "Hare", "4d9275e7-744b-2390-1e8d-943e0f2501a4", entityPos, nil)
      end
    elseif key == "HORSE" then
      for i=0,count do
        local entityPos = cheat:get_npc_spawn_point(true, playerPosition.x, playerPosition.y, playerPosition.z, radius)
        cheat:cheat_spawn_entity(nil, "Horse", "4669b957-cd91-b597-2f2a-977ba81d1c80", entityPos, nil)
      end
    elseif key == "BOAR" then
      for i=0,count do
        local entityPos = cheat:get_npc_spawn_point(true, playerPosition.x, playerPosition.y, playerPosition.z, radius)
        cheat:cheat_spawn_entity(nil, "Boar", "4ba0a861-869f-30e3-941b-aa3872f1c6a3", entityPos, nil)
      end
    elseif key == "SHEEP" then
      for i=0,count do
        local entityPos = cheat:get_npc_spawn_point(true, playerPosition.x, playerPosition.y, playerPosition.z, radius)
        cheat:cheat_spawn_entity(nil, "Sheep", "43049911-d3fe-9315-b963-fb4ecc601d8f", entityPos, nil)
      end
    elseif key == "PIG" then
      for i=0,count do
        local entityPos = cheat:get_npc_spawn_point(true, playerPosition.x, playerPosition.y, playerPosition.z, radius)
        cheat:cheat_spawn_entity(nil, "Pig", "400d68c1-ab31-864a-bf3f-557fcc5922a8", entityPos, nil)
      end
    elseif key == "COW" then
      for i=0,count do
        local entityPos = cheat:get_npc_spawn_point(true, playerPosition.x, playerPosition.y, playerPosition.z, radius)
        cheat:cheat_spawn_entity(nil, "Cow", "47991ed1-84fd-6233-0f27-046e5db1698b", entityPos, nil)
      end
    elseif key == "BUCK" then
      for i=0,count do
        local entityPos = cheat:get_npc_spawn_point(true, playerPosition.x, playerPosition.y, playerPosition.z, radius)
        cheat:cheat_spawn_entity(nil, "RoeBuck", "41f5c883-299d-645f-5a42-92db0d6c6c91", entityPos, nil)
      end
    elseif key == "DOE" then
      for i=0,count do
        local entityPos = cheat:get_npc_spawn_point(true, playerPosition.x, playerPosition.y, playerPosition.z, radius)
        cheat:cheat_spawn_entity(nil, "DeerDoe", "4eca3014-efa1-e85e-414d-c454aaed1baf", entityPos, nil)
      end
    elseif key == "REDDEER" then
      for i=0,count do
        local entityPos = cheat:get_npc_spawn_point(true, playerPosition.x, playerPosition.y, playerPosition.z, radius)
        cheat:cheat_spawn_entity(nil, "RedDeer", "4edc5ad5-51be-0cd2-be9d-6ead0aabcf88", entityPos, nil)
      end
    elseif key == "BANDIT" then
      local souls = cheat:find_soul("bandit", true)
      for i=1,count do
        local entityPos = cheat:get_npc_spawn_point(true, playerPosition.x, playerPosition.y, playerPosition.z, radius)
        local soul_id = souls[math.random(1,#souls)].soul_id
        cheat:cheat_spawn_entity(nil, "NPC", soul_id, entityPos, nil)
      end
    elseif key == "CUMAN" then
      local souls = cheat:find_soul("cuman", true)
      for i=1,count do
        local entityPos = cheat:get_npc_spawn_point(true, playerPosition.x, playerPosition.y, playerPosition.z, radius)
        local soul_id = souls[math.random(1,#souls)].soul_id
        cheat:cheat_spawn_entity(nil, "NPC", soul_id, entityPos, nil)
      end
    elseif key == "GUARD" then
      local souls = cheat:find_soul("guard", true)
      for i=1,count do
        local entityPos = cheat:get_npc_spawn_point(true, playerPosition.x, playerPosition.y, playerPosition.z, radius)
        local soul_id = souls[math.random(1,#souls)].soul_id
        cheat:cheat_spawn_entity(nil, "NPC", soul_id, entityPos, nil)
      end
    end
  end
end

-- ============================================================================
-- cheat_spawn_npc
-- ============================================================================
cheat.cheat_spawn_npc_args = {
  token = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "The sould ID, all/part of the soul name, or all/part of localized soul name.") end
}

cheat:createCommand("cheat_spawn_npc", "cheat:cheat_spawn_npc(%line)", cheat.cheat_spawn_npc_args,
  "Searches through the database of souls and spawns 1 NPC for each match.\n$8"..
  "This is intended to be used to spawn specific NPCs.\n$8"..
  "The list of souls is in v_soul_character_data.xml in tables.pak.",
  "Spawn Olena by name (spawns 2 NPCs, 1 is invisible)", "cheat_spawn_npc token:olena",
  "Spawn all NPCs with 'father' in their name", "cheat_spawn_npc token:father",
  "Spawn by soul ID", "cheat_spawn_npc token:4d69f4f4-6b78-7b1f-5a61-8fa8045b7aac",
  "Spawn by ui name", "cheat_spawn_npc token:char_452_uiName")
function cheat:cheat_spawn_npc(line)
  local args = cheat:argsProcess(line, cheat.cheat_spawn_npc_args)
  local token, tokenErr = cheat:argsGet(args, 'token', nil)
  if not tokenErr then
    local souls = cheat:find_soul(token, true)
    if #souls > 0 then
      for i,soul in ipairs(souls) do
        cheat:cheat_spawn_entity(nil, "NPC", soul.soul_id, nil, nil)
      end
    else
      cheat:logError("Soul [%s] not found.", soul)
    end
  end
end

function cheat:getnpcs(range, name)
  local npcs = System.GetEntitiesInSphere(player:GetPos(), range)
  for i,npc in pairs(npcs) do
    if npc.class == "NPC" then
      if cheat:toUpper(npc.GetNpcName()) == cheat:toUpper(name) then
        cheat:logDebug("Found NPC [%s].", tostring(npc.GetNpcName()))
        return npc
      end
    end
  end
  return nil
end

function cheat:getitems(range)
  local items = System.GetEntitiesInSphere(player:GetPos(), range)
  for i,item in pairs(items) do
    if item.class == "PickableItem" then
      cheat:print_methods(item)
    end
  end
end

function cheat:getEntitiesInRange(range)
  local ents = System.GetEntitiesInSphere(player:GetPos(), range)
  for i,ent in pairs(ents) do
    -- ent.class
    -- NPC, PickableItem, Player
    if ent.class == "NPC" then
      cheat:print_methods(ent)
    end
  end
end

-- ============================================================================
-- end
-- ============================================================================
cheat:logDebug("cheat_core_npc.lua loaded")
