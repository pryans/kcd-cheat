-- ============================================================================
-- cheat_stash
-- ============================================================================
cheat:createCommand("cheat_stash", "cheat:cheat_stash()", nil,
  "Opens the player's stash. This only works if you have unlocked at least 1 stash.",
  "Open your stash", "cheat_stash")
function cheat:cheat_stash()
  for i,stash in pairs(System.GetEntitiesByClass("Stash")) do 
    local ownerWuid = EntityModule.GetInventoryOwner(stash.inventoryId)
    if ownerWuid == player.this.id then
      cheat:logInfo("Opening stash [%s].", tostring(stash.inventoryId))
      stash:Open(player)
      return
    end
  end
  cheat:logError("You don't have a stash yet.")
end

-- ============================================================================
-- cheat_loc
-- ============================================================================
cheat:createCommand("cheat_loc", "cheat:loc()", nil,
  "Shows player's world location.",
  "Example", "cheat_loc")
function cheat:loc()
  local loc = player:GetWorldPos();
  cheat:logInfo("Player's location x=%d y=%d z=%d", loc.x, loc.y, loc.z)
end

-- ============================================================================
-- cheat_teleport
-- ============================================================================
cheat.cheat_teleport_args = {
  x = function(args,name,showHelp) return cheat:argsGetRequiredNumber(args, name, showHelp, "X coordinate") end,
  y = function(args,name,showHelp) return cheat:argsGetRequiredNumber(args, name, showHelp, "Y coordinate") end,
  z = function(args,name,showHelp) return cheat:argsGetRequiredNumber(args, name, showHelp, "Z coordinate") end
}

cheat:createCommand("cheat_teleport", "cheat:teleport(%line)", cheat.cheat_teleport_args,
  "Teleports the player to the given coordinates.\n$8You can end up in the air or under the map.\n$8I suggest saving your game and turn on immortality first.",
  "Example", "cheat_teleport x:3000 y:1500 z:300")
function cheat:teleport(line)
  local args = cheat:argsProcess(line, cheat.cheat_teleport_args)
  local nx, nxErr = cheat:argsGet(args, 'x')
  local ny, nyErr = cheat:argsGet(args, 'y')
  local nz, nzErr = cheat:argsGet(args, 'z')
  if not nxErr and not nyErr and not nzErr then
    player:SetWorldPos({x=nx, y=ny, z=nz});
    cheat:logInfo("Teleported player to x=%d y=%d z=%d", nx, ny, nz)
  end
end

-- ============================================================================
-- cheat_teleport_to
-- ============================================================================
System.AddCCommand('cheat_teleport_to', 'cheat:teleport_to(%line)', "Teleports the player to the given place. Supported places (case insensitive):\n$8Budin, (Inn at the) Glade, (Rattay Mill) Home,\n$8Wagoners (Inn), Katzek, Kohelnitz,\n$8Ledetchko, Merhojed, Monastery,\n$8Neuhof, Pribyslavitz, Rattay,\n$8Rovna, Samopesh, Sasau,\n$8Skalitz, Talmberg, Uzhitz,\n$8Vranik, Wagoners (Inn), (Broken) Wheel")

function cheat:teleport_to(line)
  local args = string.gsub(tostring(line), "place:", "")
  local checkteste = "error"
  
  local places = {}
  places["BUDIN"] = "x:1405 y:1463 z:19"
  places["GLADE"] = "x:2849 y:1913 z:156"
  places["HOME"] = "x:2451 y:693 z:28"
  places["KATZEK"] = "x:1602 y:1838 z:20"
  places["KOHELNITZ"] = "x:2823 y:1232 z:25"
  places["LEDETCHKO"] = "x:2052 y:1304 z:30"
  places["MERHOJED"] = "x:1636 y:2618 z:126"
  places["MONASTERY"] = "x:929 y:1617 z:36"
  places["NEUHOF"] = "x:3522 y:1524 z:131"
  places["PRIBYSLAVITZ"] = "x:1557 y:3719 z:107"
  places["RATTAY"] = "x:2534 y:572 z:81"
  places["ROVNA"] = "x:1261 y:3129 z:25"
  places["SAMOPESH"] = "x:1139 y:2239 z:71"
  places["SASAU"] = "x:896 y:1186 z:27"
  places["SKALITZ"] = "x:829 y:3522 z:51"
  places["TALMBERG"] = "x:2360 y:2846 z:105"
  places["UZHITZ"] = "x:3041 y:3324 z:156"
  places["VRANIK"] = "x:930 y:913 z:130"
  places["WAGONERS"] = "x:938 y:1424 z:24"
  places["WHEEL"] = "x:2915 y:733 z:108 "
  
  if places[cheat:toUpper(args)] ~= nil then
    cheat:teleport(places[cheat:toUpper(args)])
  else
    for k,v in pairs(places) do
      if string.find(k, cheat:toUpper(args)) then
        checkteste = v
      end
    end
    if checkteste ~= "error" then
      cheat:teleport(checkteste)
    else
      cheat:logError("Invalid place - For a list of supported places type: 'cheat_teleport_to ?'")
    end
  end
end

-- ============================================================================
-- cheat_tp_tr
-- ============================================================================
cheat.cheat_tp_tr_args = {
  place = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "Teleport to treasure") end,
}

cheat:createCommand("cheat_tp_tr", "cheat:tp_tr(%line)", cheat.cheat_tp_tr_args,
"Teleports the player to the given place. Supported places (case insensitive):\n$8I, II, III, IV, V, VI, VII, VIII, IX, X, XI, XII, XIII, XIV, XV, XVI, XVII, XVIII, XIX, XX,\n$8XXI, XXII, XIII, XXIV, XXV, AI, AII, AII, AIII, AIV, AV",
"Example", "cheat_tp_tr place:XXV")
function cheat:tp_tr(line)
  local args = cheat:argsProcess(line, cheat.cheat_tp_tr_args)
  local nplace, nplaceErr = cheat:argsGet(args, 'place')
  
  local places = {}
  places["I"] = "x:650 y:1920 z:106"
  places["II"] = "x:382 y:1813 z:22" 
  places["III"] = "x:223 y:1695 z:71"
  places["IV"] = "x:2772 y:1449 z:106"
  places["V"] = "x:2086 y:2054 z:126"
  places["VI"] = "x:2268 y:1589 z:114"
  places["VII"] = "x:1860 y:1521 z:80"
  places["VIII"] = "x:2332 y:1120 z:54"
  places["IX"] = "x:869 y:3279 z:19"
  places["X"] = "x:1683 y:938 z:41"
  places["XI"] = "x:1445 y:1140 z:37"
  places["XII"] = "x:3175 y:335 z:136"
  places["XIII"] = "x:3610 y:721 z:100"
  places["XIV"] = "x:3692 y:1258 z:87"
  places["XV"] = "x:2942 y:1329 z:90"
  places["XVI"] = "x:482 y:2578 z:20"
  places["XVII"] = "x:769 y:2572 z:20"
  places["XVIII"] = "x:2494 y:2817 z:99"
  places["XIX"] = "x:856 y:1335 z:18"
  places["XX"] = "x:740 y:3699 z:30"
  places["XXI"] = "x:657 y:3141 z:41"
  places["XXII"] = "x:600 y:608 z:158"
  places["XXIII"] = "x:1011 y:3972 z:51"
  places["XXIV"] = "x:903 y:3841 z:66"
  places["XXV"] = "x:221 y:3474 z:77"
  places["AI"] = "x:3872 y:886 z:157"
  places["AII"] = "x:874 y:270 z:181"
  places["AIII"] = "x:3159 y:3840 z:167"
  places["AIV"] = "x:1723 y:778 z:74"
  places["AV"] = "x:474 y:3869 z:40"
  
  if not nplaceErr then
    if places[cheat:toUpper(nplace)] ~= nil then
      cheat:teleport(places[cheat:toUpper(nplace)])
    else
      cheat:logError("Invalid Place - See list of supported places type: 'cheat_tp_tr ?'")
    end
  end
end

-- ============================================================================
-- cheat_tp_to_npc
-- ============================================================================
cheat.cheat_tp_to_npc_args = {
  id = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "All or part of the NPC's name.") end,
  num = function(args,name,showHelp) return cheat:argsGetOptionalNumber(args, name, 0, showHelp, "Optional: The NPC's number in the list if there's more than one.\n$8Keep it greater than 0.") end
}
cheat:createCommand("cheat_tp_to_npc", "cheat:tp_to_npc(%line)", cheat.cheat_tp_to_npc_args,
  "Finds an NPC or list of NPCs and teleports to any of them.\n$8This only works if the NPC has been loaded into the world.\n$8Defaults to last NPC in the list if no num argument received.",
  "Teleport to Father Godwin", "cheat_tp_to_npc id:godwin")
function cheat:tp_to_npc(line)
  local args = cheat:argsProcess(line, cheat.cheat_tp_to_npc_args)
  local id, idErr = cheat:argsGet(args, 'id', nil)
  local num, numErr = cheat:argsGet(args, 'num', 0)
  if not idErr and not numErr then
    cheat:cheat_find_npc("token:" .. id)
    local npcs = cheat:find_npc(id)
    
    if num == nil or num <= 0 then
      num = #npcs
    end
    
    if num > #npcs then
      cheat:logError("Sorry, this number is greater than the amount of found NPCS.")
      return
    end
    if npcs and #npcs > 0 then
      local nx = npcs[num]:GetWorldPos().x
      local ny = npcs[num]:GetWorldPos().y
      local nz = npcs[num]:GetWorldPos().z
      cheat:teleport("x:" .. nx .. " y:" .. ny .. " z:" .. nz)
    else
      cheat:logError("NPC [%s] not found.", id)
    end
  end
end

-- ============================================================================
-- cheat_set_state
-- ============================================================================
cheat.cheat_set_state_args = {
  state=function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "One of: health, exhaust, hunger, or stamina.") end,
  value=function(args,name,showHelp) return cheat:argsGetRequiredNumber(args, name, showHelp, "The number to assign to the given state.") end
}

cheat:createCommand("cheat_set_state", "cheat:cheat_set_state(%line)", cheat.cheat_set_state_args,
  "Sets one of the player's states to the given value.",
  "Set health to 100 points", "cheat_set_state state:health value:100",
  "Set exhaust to 100 points", "cheat_set_state state:exhaust value:100")
function cheat:cheat_set_state(line)
  local args = cheat:argsProcess(line, cheat.cheat_set_state_args)
  local state, stateErr = cheat:argsGet(args, 'state')
  local value, valueErr = cheat:argsGet(args, 'value')
  if not stateErr and not valueErr then
    player.soul:SetState(state, value)
    cheat:logInfo("Set state [%s] to value [%s].", tostring(state), tostring(value))
    return true
  end
  return false
end

-- ============================================================================
-- cheat_add_stat_xp
-- ============================================================================
cheat.cheat_add_stat_xp_args = {
  stat = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "One of: str, agi, vit, or spc.") end,
  xp = function(args,name,showHelp) return cheat:argsGetRequiredNumber(args, name, showHelp, "The desired XP to add.") end
}

cheat:createCommand("cheat_add_stat_xp", "cheat:cheat_add_stat_xp(%line)", cheat.cheat_add_stat_xp_args,
  "Adds XP to one of the player's stats.",
  "Add 100 XP to player's strength stat", "cheat_add_stat_xp stat:str xp:100")
function cheat:cheat_add_stat_xp(line)
  local args = cheat:argsProcess(line, cheat.cheat_add_stat_xp_args)
  local stat, statErr = cheat:argsGet(args, 'stat')
  local xp, xpErr = cheat:argsGet(args, 'xp')
  if not statErr and not xpErr then
    player.soul:AddStatXP(stat, xp)
    cheat:logInfo("Added [%s] XP to stat [%s].", tostring(xp), tostring(stat))
    return true
  end
  return false
end

-- ============================================================================
-- cheat_set_stat_level
-- ============================================================================
cheat.cheat_set_stat_level_args = {
  stat = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "One of: str, agi, vit, or spc.") end,
  level = function(args,name,showHelp) return cheat:argsGetRequiredNumber(args, name, showHelp, "The desired level for the given stat (max 20). Level cannot lowered.") end
}

cheat:createCommand("cheat_set_stat_level", "cheat:cheat_set_stat_level(%line)", cheat.cheat_set_stat_level_args,
  "Sets one of the player's stats to the given level.",
  "Set player's strength to level 20", "cheat_set_stat_level stat:str level:20",
  "Set player's agility to level 5", "cheat_set_stat_level stat:agi level:5")
function cheat:cheat_set_stat_level(line)
  local args = cheat:argsProcess(line, cheat.cheat_set_stat_level_args)
  local stat, statErr = cheat:argsGet(args, 'stat')
  local level, levelErr = cheat:argsGet(args, 'level')
  if not statErr and not levelErr then
    player.soul:AdvanceToStatLevel(stat, level)
    cheat:logInfo("Set stat [%s] to level [%s].", tostring(stat), tostring(level))
    return true
  end
  return false
end

-- ============================================================================
-- cheat_add_money
-- ============================================================================
cheat.cheat_add_money_args = {
  amount = function(args,name,showHelp) return cheat:argsGetRequiredNumber(args, name, showHelp, "The amount of groschen to add.") end
}

cheat:createCommand("cheat_add_money", "cheat:cheat_add_money(%line)", cheat.cheat_add_money_args,
  "Adds the given amount of groschen to the player's inventory.",
  "Add 200 groschen", "cheat_add_money amount:200")
function cheat:cheat_add_money(line)
  local args = cheat:argsProcess(line, cheat.cheat_add_money_args)
  local amount, amountErr = cheat:argsGet(args, 'amount')
  if not amountErr then
    AddMoneyToInventory(player,amount)
    cheat:logInfo("Added [%s] to player inventory.", tostring(amount))
    return true
  end
  return false
end

-- ============================================================================
-- cheat_set_bow_reticle
-- ============================================================================
cheat.cheat_set_bow_reticle_args = {
  enable = function(args,name,showHelp) return cheat:argsGetRequiredBoolean(args, name, showHelp, "true or false") end,
}

cheat:createCommand("cheat_set_bow_reticle", "cheat:cheat_set_bow_reticle(%line)", cheat.cheat_set_bow_reticle_args,
  "Enabled or disables the bow reticle. Won't take effect if bow is drawn.",
  "Turn it on", "cheat_set_bow_reticle enable:true",
  "Turn it off", "cheat_set_bow_reticle enable:false")
function cheat:cheat_set_bow_reticle(line)
  local args = cheat:argsProcess(line, cheat.cheat_set_bow_reticle_args)
  local enable, enableErr = cheat:argsGet(args, 'enable')
  if not enableErr then
    if enable then
      System.ExecuteCommand("wh_pl_showfirecursor=1")
      cheat:logInfo("Bow reticle on.")
    else
      System.ExecuteCommand("wh_pl_showfirecursor=0")
      cheat:logInfo("Bow reticle off.")
    end
    return true
  end
  return false
end

-- ============================================================================
-- cheat_set_wanted_level
-- ============================================================================
cheat.cheat_set_wanted_level_args = {
  level = function(args,name,showHelp) return cheat:argsGetRequiredNumber(args, name, showHelp, "0=not wanted, 1=wanted for money, 2=wanted for jail, 3=wanted dead") end,
}

cheat:createCommand("cheat_set_wanted_level", "cheat:cheat_set_wanted_level(%line)", cheat.cheat_set_wanted_level_args,
  "Set or clears the player's wanted level. This doesn't affect faction reputation.",
  "Clear wanted status", "cheat_set_wanted_level level:0",
  "Make the guards kill me on sight", "cheat_set_wanted_level level:4")
function cheat:cheat_set_wanted_level(line)
  local args = cheat:argsProcess(line, cheat.cheat_set_wanted_level_args)
  local level, levelErr = cheat:argsGet(args, 'level')
  
  if not levelErr then
    if level < 0 then
      level = 0
    end
    
    if level > 3 then
      level = 3
    end
    
    Game.SetWantedLevel(level)
    cheat:logInfo("Player's wanted level set to [%s].", tostring(level))
    return true
  end
  return false
end

-- ============================================================================
-- cheat_wash_dirt_and_blood
-- ============================================================================
cheat:createCommand("cheat_wash_dirt_and_blood", "cheat:cheat_wash_dirt_and_blood()", nil,
  "Washes all blood and dirt from the player and player's horse.\n$8Do horses need this?\n$8Can items be washed?\n$8Let me know.",
  "Wash yourself and your horse", "cheat_wash_dirt_and_blood")
  function cheat:cheat_wash_dirt_and_blood()
    local entity = XGenAIModule.GetEntityByWUID(player.player:GetPlayerHorse());
    
    player.actor:WashDirtAndBlood(1)
    player.actor:WashItems(1)
    
    if entity then
      entity.actor:WashDirtAndBlood(1)
      entity.actor:WashItems(1)
    end
    
    cheat:logInfo("All Clean!")
  end

-- ============================================================================
-- cheat_charm
-- ============================================================================
cheat:createCommand("cheat_charm", "cheat:cheat_charm()", nil,
  "Automates your morning routine of bath-haircut-sex for maximum Charisma bonus.\n$8Washes all dirt and blood and applies Fresh Cut and Smitten buffs.",
  "Wash yourself and add Charisma buffs", "cheat_charm")
function cheat:cheat_charm()
  cheat:cheat_wash_dirt_and_blood()
  cheat:cheat_add_buff("id:fresh_cut")
  cheat:cheat_add_buff("id:alpha_male_in_love")
  cheat:logInfo("All Clean and dandy!")
end

-- cheat_unlock_recipes
-- ============================================================================
cheat:createCommand("cheat_unlock_recipes", "cheat:cheat_unlock_recipes()", nil,
  "Saw this code to unlock recipes in a pak file.\n$8I have no idea what this really does or if it works.\n$8Let me know.",
  "Unlock all recipes", "cheat_unlock_recipes")
function cheat:cheat_unlock_recipes()
  for i=2,26 do
		for y=1,5 do RPG.UnlockRecipe(player, i, y); end
	end
  cheat:logInfo("Recipies unlocked.")
  return true
end

-- ============================================================================
-- g_passive_stamina_regen
-- ============================================================================
cheat.g_passive_stamina_regen = false
cheat.g_passive_stamina_regen_amount = 1
cheat.g_passive_stamina_regen_highwater = 100

cheat:cheat_timer_register("g_passive_stamina_regen", function()
  if cheat.g_passive_stamina_regen then
    local stamina = player.soul:GetState("stamina")
    
    if stamina > cheat.g_passive_stamina_regen_highwater then
      cheat.g_passive_stamina_regen_highwater = stamina
      cheat:logDebug("current stamina highwater [%s]", tostring(cheat.g_passive_stamina_regen_highwater))
    end
    
    if stamina < cheat.g_passive_stamina_regen_highwater then
      local realAmount = cheat:min(stamina + cheat.g_passive_stamina_regen_amount, cheat.g_passive_stamina_regen_highwater)
      player.soul:SetState("stamina", realAmount)
      --cheat:logDebug("+%s stamina (%s)", tostring(realAmount), tostring(stamina))
    end
  end
end)

-- ============================================================================
-- g_passive_exhaust_regen
-- ============================================================================
cheat.g_passive_exhaust_regen = false
cheat.g_passive_exhaust_regen_amount = 1
cheat.g_passive_exhaust_regen_highwater = 100

cheat:cheat_timer_register("g_passive_exhaust_regen", function()
  if cheat.g_passive_exhaust_regen then
    local exhaust = player.soul:GetState("exhaust")
    
    if exhaust > cheat.g_passive_exhaust_regen_highwater then
      cheat.g_passive_exhaust_regen_highwater = exhaust
      cheat:logDebug("current exhaust highwater [%s]", tostring(cheat.g_passive_exhaust_regen_highwater))
    end
    
    if exhaust < cheat.g_passive_exhaust_regen_highwater then
      local realAmount = cheat:min(exhaust + cheat.g_passive_exhaust_regen_amount, cheat.g_passive_exhaust_regen_highwater)
      player.soul:SetState("exhaust", realAmount)
      --cheat:logDebug("+%s exhaust (%s)", tostring(realAmount), tostring(exhaust))
    end
  end
end)

-- ============================================================================
-- g_passive_hunger_regen
-- ============================================================================
cheat.g_passive_hunger_regen = false
cheat.g_passive_hunger_regen_amount = 1
cheat.g_passive_hunger_regen_highwater = 100

cheat:cheat_timer_register("g_passive_hunger_regen", function()
  if cheat.g_passive_hunger_regen then
    local hunger = player.soul:GetState("hunger")
    
    if hunger > cheat.g_passive_hunger_regen_highwater then
      cheat.g_passive_hunger_regen_highwater = hunger
      cheat:logDebug("current hunger highwater [%s]", tostring(cheat.g_passive_hunger_regen_highwater))
    end
    
    if hunger < cheat.g_passive_hunger_regen_highwater then
      local realAmount = cheat:min(hunger + cheat.g_passive_hunger_regen_amount, cheat.g_passive_hunger_regen_highwater)
      player.soul:SetState("hunger", realAmount)
      --cheat:logDebug("+%s hunger (%s)", tostring(realAmount), tostring(hunger))
    end
  end
end)

-- ============================================================================
-- g_passive_health_regen
-- ============================================================================
cheat.g_passive_health_regen = false
cheat.g_passive_health_regen_amount = 1
cheat.g_passive_health_regen_highwater = 100

cheat:cheat_timer_register("g_passive_health_regen", function()
  if cheat.g_passive_health_regen then
    local health = player.soul:GetState("health")
    local maxHealth = player.actor:GetMaxHealth();
    
    if health > cheat.g_passive_health_regen_highwater then
      cheat.g_passive_health_regen_highwater = health
      cheat:logDebug("current health highwater [%s]", tostring(cheat.g_passive_health_regen_highwater))
    end
    
    if health < cheat.g_passive_health_regen_highwater then
      local realAmount = cheat:min(health + cheat.g_passive_health_regen_amount, cheat.g_passive_health_regen_highwater)
      player.soul:SetState("health", realAmount)
      --cheat:logDebug("+%s health (%s)(%s)", tostring(realAmount), tostring(health), tostring(maxHealth))
    end
  end
end)

-- ============================================================================
-- cheat_set_regen
-- ============================================================================
cheat.cheat_set_regen_args = {
  enable = function(args,name,showHelp) return cheat:argsGetRequiredBoolean(args, name, showHelp, "true to enable state regen; false to disable") end,
  state = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "The state to regen: all, health, stamina, or exhaust.") end,
  amount = function(args,name,showHelp) return cheat:argsGetOptionalNumber(args, name, 1, showHelp, "The amount to regen every second.") end
}

cheat:createCommand("cheat_set_regen", "cheat:cheat_set_regen(%line)", cheat.cheat_set_regen_args,
  "Regenerates the given player state over time; pulses once per second.",
  "Adds 1 to all states every second.", "cheat_set_regen enable:true state:all amount:1",
  "Adds 100 to player's stamina every second.", "cheat_set_regen enable:true state:stamina amount:100",
  "Disable all state regeneration.", "cheat_set_regen enable:false state:all")
function cheat:cheat_set_regen(line)
  local args = cheat:argsProcess(line, cheat.cheat_set_regen_args)
  local enable, enableErr = cheat:argsGet(args, 'enable')
  local state, stateErr = cheat:argsGet(args, 'state')
  local amount, amountErr = cheat:argsGet(args, 'amount', 1)
  
  if enableErr or stateErr or amountErr then
    return
  end
  
  if state == "health" or state == "all" then
    cheat.g_passive_health_regen = enable
    if enable then
      cheat.g_passive_health_regen_amount = amount
    end
    cheat:logInfo("Heath regen state [%s] and amount [%s].", tostring(cheat.g_passive_health_regen), tostring(cheat.g_passive_health_regen_amount))
  end
  
  if state == "stamina" or state == "all" then
    cheat.g_passive_stamina_regen = enable
    if enable then
      cheat.g_passive_stamina_regen_amount = amount
    end
    cheat:logInfo("Stamina regen state [%s] and amount [%s].", tostring(cheat.g_passive_stamina_regen), tostring(cheat.g_passive_stamina_regen_amount))
  end
  
  if state == "hunger" or state == "all" then
    cheat.g_passive_hunger_regen = enable
    if enable then
      cheat.g_passive_hunger_regen_amount = amount
    end
    cheat:logInfo("Hunger regen state [%s] and amount [%s].", tostring(cheat.g_passive_hunger_regen), tostring(cheat.g_passive_hunger_regen_amount))
  end
  
  if state == "exhaust" or state == "all" then
    cheat.g_passive_exhaust_regen = enable
    if enable then
      cheat.g_passive_exhaust_regen_amount = amount
    end
    cheat:logInfo("Exhaust regen state [%s] and amount [%s].", tostring(cheat.g_passive_exhaust_regen), tostring(cheat.g_passive_exhaust_regen_amount))
  end
  
  return true
end

-- ============================================================================
-- end
-- ============================================================================
cheat:logDebug("cheat_core_player.lua loaded")
