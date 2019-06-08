-- ============================================================================
-- cheat_hover
-- ============================================================================
cheat.g_cheat_hover_enabled = false
cheat.g_cheat_hover_force = 1
cheat.g_cheat_hover_timer_id = nil
cheat.g_cheat_hover_timer_period_millis = 50

function cheat:onHover(nTimerId)
  if cheat.g_cheat_hover_enabled then
    local pos = {x=0,y=0,z=0}
    CopyVector(pos,player:GetWorldPos());
    player:AwakePhysics(1);
    player:AddImpulse( -1, pos, g_Vectors.v001, player:GetPhysicalStats().mass * cheat.g_cheat_hover_force);
    cheat.g_cheat_hover_timer_id = Script.SetTimer(cheat.g_cheat_hover_timer_period_millis, function(nTimerId) cheat:onHover(nTimerId) end)
  end
end

cheat:createCommand("cheat_phys_hover", "cheat:hover()", nil, "Use F1 key to toggle hover on and off.\n$8This uses physics to push the player slightly up.\n$8This is intended to be used with F2 push.")
function cheat:hover()
  if not cheat.g_cheat_hover_enabled then
    cheat.g_cheat_hover_enabled = true
    cheat.g_cheat_hover_timer_id = Script.SetTimer(cheat.g_cheat_hover_timer_period_millis, function(nTimerId) cheat:onHover(nTimerId) end)
    --cheat:logInfo("Hover On")
  else
    cheat.g_cheat_hover_enabled = false
    --cheat:logInfo("Hover Off")
    if cheat.g_cheat_hover_timer_id then
      Script.KillTimer(cheat.g_cheat_hover_timer_id)
      cheat.g_cheat_hover_timer_id = nil
    end
  end
end

-- ============================================================================
-- cheat_push
-- ============================================================================
cheat.g_cheat_push_enabled = false
cheat.g_cheat_push_force = 10
cheat.g_cheat_push_timer_id = nil
cheat.g_cheat_push_timer_period_millis = 50

function cheat:onPush(nTimerId)
  if cheat.g_cheat_push_enabled then
    local pos = {x=0,y=0,z=0}
    local dir = {x=0,y=0,z=0}
    CopyVector(pos,player:GetWorldPos());
    CopyVector(dir,player:GetWorldDir());
    player:AwakePhysics(1);
    player:AddImpulse(-1, pos, dir, player:GetPhysicalStats().mass * cheat.g_cheat_push_force);
    cheat.g_cheat_push_timer_id = Script.SetTimer(cheat.g_cheat_push_timer_period_millis, function(nTimerId) cheat:onPush(nTimerId) end)
  end
end

cheat:createCommand("cheat_phys_push", "cheat:push()", nil, "Use F2 key to toggle push on and off.\n$8This uses physics to push the player forward.\n$8This is intended to be used with F1 hover.")
function cheat:push()
  if not cheat.g_cheat_push_enabled then
    cheat.g_cheat_push_enabled = true
    cheat.g_cheat_push_timer_id = Script.SetTimer(cheat.g_cheat_push_timer_period_millis, function(nTimerId) cheat:onPush(nTimerId) end)
  else
    cheat.g_cheat_push_enabled = false
    if cheat.g_cheat_push_timer_id then
      Script.KillTimer(cheat.g_cheat_push_timer_id)
      cheat.g_cheat_push_timer_id = nil
    end
  end
end

-- ============================================================================
-- cheat_sprint
-- ============================================================================
cheat.g_cheat_sprint_enabled = false
cheat.g_cheat_sprint_force = 8
cheat.g_cheat_sprint_timer_id = nil
cheat.g_cheat_sprint_timer_period_millis = 50
cheat.g_cheat_down_vector = {x=0,y=0,z=-1}

function cheat:onSprint(nTimerId)
  if cheat.g_cheat_sprint_enabled then
    local pos = {x=0,y=0,z=0}
    local dir = {x=0,y=0,z=0}
    CopyVector(pos,player:GetWorldPos());
    CopyVector(dir,player:GetWorldDir());
    player:AwakePhysics(1);
    -- push player down into the ground for friction
    -- if the player leaves the ground things get crazy
    player:AddImpulse(-1, pos, cheat.g_cheat_down_vector, player:GetPhysicalStats().mass * 9.81);
    player:AddImpulse(-1, pos, dir, player:GetPhysicalStats().mass * cheat.g_cheat_sprint_force);
    cheat.g_cheat_sprint_timer_id = Script.SetTimer(cheat.g_cheat_sprint_timer_period_millis, function(nTimerId) cheat:onSprint(nTimerId) end)
  end
end

cheat:createCommand("cheat_phys_sprint", "cheat:sprint()", nil, "Use F3 key to toggle sprinting on and off.\n$8This uses physics to push the player forward (and down for friction).")
function cheat:sprint()
  if not cheat.g_cheat_sprint_enabled then
    cheat.g_cheat_sprint_enabled = true
    cheat.g_cheat_sprint_timer_id = Script.SetTimer(cheat.g_cheat_sprint_timer_period_millis, function(nTimerId) cheat:onSprint(nTimerId) end)
  else
    cheat.g_cheat_sprint_enabled = false
    if cheat.g_cheat_sprint_timer_id then
      Script.KillTimer(cheat.g_cheat_sprint_timer_id)
      cheat.g_cheat_sprint_timer_id = nil
    end
  end
end




--[[
ch_props =
	{
		commrange = 30,
		SpawnedEntityName = "Bob0",
    name = "Bob1",
		bSpeciesHostility = 1,
		soclasses_SmartObjectClass = "Actor",
		attackrange = 70,
		special = 0,
		aicharacter_character = "Cover",
		Perception =
		{
			stanceScale = 1.8,
			sightrange = 50,
			FOVSecondary = 160,
			FOVPrimary = 80,
			audioScale = 1,
		},
		species = 1,
		bInvulnerable = 0,
		accuracy = 1.0,
		fileModel = "",
	}

chpropinst=
	{
		aibehavior_behaviour = "Job_StandIdle",
		soclasses_SmartObjectClass = "",
		groupid = 173,
	}

function cheat:spawn(pclass)
  local params = {
    class = "Grunt";
    position = player:GetPos(),
    orientation = player:GetDirectionVector(1),
    scale = player:GetScale(),
    --archetype = nil,
    properties = ch_props,
    propertiesInstance = chpropinst,
  }

  local ent = System.SpawnEntity(params)

  if ent then
--    self.spawnedEntity = ent.id
--    self.lastSpawnedEntity = ent.id;
--    if not ent.Events then ent.Events = {} end
--    local evts = ent.Events
--    for name, data in pairs(self.FlowEvents.Outputs) do
--      if not evts[name] then evts[name] = {} end
--      table.insert(evts[name], {self.id, name})
--    end
--    ent.whoSpawnedMe = self;

    ent:SetupTerritoryAndWave();
    ent:ActivateOutput("Spawned", ent.id);
    --return self.id;
    cheat:logInfo("spawned")
  end
end

--]]











-- player.gameParams type=table methods=yes metamethods=no
--    jumpHeight=1
--    sprintMultiplier=1.5
--    strafeMultiplier=.75
--    backwardMultiplier=.7
--    slopeSlowdown=3

-- cheat_eval return player.gameParams.slopeSlowdown
-- ent:AddImpulse( -1, pos, g_Vectors.v001, UpImpulse );
-- cheat_eval cheat:print_methods(player:GetPhysicalStats())
-- flags=1.84617...
-- gravity=-13
-- mass=80

-- SetCharacterPhysicParams
-- ActivatePlayerPhysics




-- all cheats, don't work
function cheat:set_timewarp()
  -- Time of fade in during PB time warp defined relative to hit point.
  System.SetCVar("wh_cs_TimeWarpFadeIn", 0)

  --Time of fade out during PB time warp defined relative to hit point.
  System.SetCVar("wh_cs_TimeWarpFadeOut", 0)

  --Time of fade out during PB time warp defined relative to hit point.
  System.SetCVar("wh_cs_TimeWarpDuration", 0)

  --Time warp maximum bias of duration to start or end of hit point (0 / 1).
  System.SetCVar("wh_cs_TimeWarpBias", 0)

  --Speed of PB time warp for player. 1 - disabled
  System.SetCVar("wh_cs_TimeWarpPBFadeSpeedForPlayer", 1)

  --Speed of PB time warp for player's opponent. 1 - disabled
  System.SetCVar("wh_cs_TimeWarpPBFadeSpeedForOpp", 1)

  --Speed of Dodge time warp for player. 1 - disabled
  System.SetCVar("wh_cs_TimeWarpDodgeFadeSpeedForPlayer", 1)

  --Speed of Dodge time warp for player's opponent. 1 - disabled
  System.SetCVar("wh_cs_TimeWarpDodgeFadeSpeedForOpp", 1)

  cheat:logInfo("done")
end


-- cheat_eval cheat:cheat_set_player_physics(5,0,0)
function cheat:cheat_set_player_physics(p_gravity, p_zerog, p_air_control)

  -- does not work
  --System.SetCVar( "p_gravity_z", tonumber(p_gravity))
  --cheat:logInfo("gravity=" .. tostring(System.GetCVar("p_gravity_z")))
  --return

  local originalFunc = _G["EntityUpdateGravity"]
  _G["EntityUpdateGravity"] = function(ent)

    cheat:logInfo("new method")

    if ent.type ~= "Player" then
      cheat:logInfo("calling orig")
      originalFunc(ent)
      return
    end

    cheat:logInfo("gravity=" .. tostring(ent:GetPhysicalStats().gravity))

    if not ent.TempPhysicsParams then
      ent:AwakePhysics(1);
    end
    ent.TempPhysicsParams = {
      gravity = -p_gravity,
      gravityz = p_gravity,
      freefall_gravityz = p_gravity,
      lying_gravityz = p_gravity,
      zeroG = p_zerog,
      air_control = p_air_control,
    };
    ent:SetPhysicParams(PHYSICPARAM_PLAYERDYN, ent.TempPhysicsParams);
    cheat:logInfo("gravity=" .. tostring(ent:GetPhysicalStats().gravity))
  end

  EntityUpdateGravity(player)
end

-- ============================================================================
-- end
-- ============================================================================
cheat:logDebug("cheat_core_physics.lua loaded")
