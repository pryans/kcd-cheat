-- ============================================================================
-- cheat_stash
-- ============================================================================
cheat:createCommand("cheat_stash", "cheat:cheat_stash()", nil,
  "Opens the player's stash. This only works if you have unlocked at least 1 stash.",
  "Open your stash", "cheat_stash")
function cheat:cheat_stash()
  local gender = player.soul:GetGender()
  if gender ~= 2 then
    for i,stash in pairs(System.GetEntitiesByClass("Stash")) do
      local ownerWuid = EntityModule.GetInventoryOwner(stash.inventoryId)
      if ownerWuid == player.this.id then
        cheat:logInfo("Opening stash [%s].", tostring(stash.inventoryId))
        stash:Open(player)
        return
      end
    end
    cheat:logError("You don't have a stash yet.")
  else
    cheat:logError("Thereza don't have a stash")
  end
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
System.AddCCommand('cheat_teleport_to', 'cheat:teleport_to(%line)',
  [["Teleports the player to the given place. Supported places (case insensitive):
  (Inn at the) Glade, Ratai_inn,
  Ledetchko, Merhojed,
  Monastery, Neuhof, Pribyslavitz,
  Rattay, Rovna, Samopesh,
  Sasau, Skalitz, Talmberg, Uzhitz, Vranik,
  Wagoners (Inn), (Broken) Wheel,
  Treasure_1, ..., Treasure_25,
  Ancient_Treasure_1, ... , Ancient_Treasure_5,
  Ruin_1,..., Ruin_4,
  Raiders_1,..., Raiders_5, (dog at 2 and 5)
  Interlopers_1,..., Interlopers_3,
  Bandits_1,...,Bandits_4,
  /*  MOLDAVITE_BANDIT_CAMP, SKALITZ_SMELTERY_BANDIT_CAMP,
  SASSAU_BANDIT_CAMP, MONASTERY_BANDIT_CAMP */
  Garden_1,...,Garden_2,
  GARDEN_WEST_RATTAY,GARDEN_WHEEL"]])
function cheat:teleport_to(line)
  if player.soul:GetGender() == 2 then
    cheat:logError("You can't use this command while playing Thereza!")
    return
  end

  local args = string.gsub(tostring(line), "place:", "")

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
  places["WHEEL"] = "x:2915 y:733 z:108"

  -- All treasure locations. I preferred arabic numerals to roman
  -- numerals because it is much easier to visit all of them in order.
  -- (You normally only need to change one digit and re-run the command)
  places["TREASURE_1"] = "x:650 y:1920 z:106"
  places["TREASURE_2"] = "x:382 y:1813 z:22"
  places["TREASURE_3"] = "x:223 y:1695 z:71"
  places["TREASURE_4"] = "x:2772 y:1449 z:106"
  places["TREASURE_5"] = "x:2086 y:2054 z:126"
  places["TREASURE_6"] = "x:2268 y:1589 z:114"
  places["TREASURE_7"] = "x:1860 y:1521 z:80"
  places["TREASURE_8"] = "x:2332 y:1120 z:54"
  places["TREASURE_9"] = "x:869 y:3279 z:19"
  places["TREASURE_10"] = "x:1683 y:938 z:41"
  places["TREASURE_11"] = "x:1445 y:1140 z:37"
  places["TREASURE_12"] = "x:3175 y:335 z:136"
  places["TREASURE_13"] = "x:3610 y:721 z:100"
  places["TREASURE_14"] = "x:3692 y:1258 z:87"
  places["TREASURE_15"] = "x:2942 y:1329 z:90"
  places["TREASURE_16"] = "x:482 y:2578 z:20"
  places["TREASURE_17"] = "x:769 y:2572 z:20"
  places["TREASURE_18"] = "x:2494 y:2817 z:99"
  places["TREASURE_19"] = "x:856 y:1335 z:18"
  places["TREASURE_20"] = "x:740 y:3699 z:30"
  places["TREASURE_21"] = "x:657 y:3141 z:41"
  places["TREASURE_22"] = "x:600 y:608 z:158"
  places["TREASURE_23"] = "x:1011 y:3972 z:51"
  places["TREASURE_24"] = "x:903 y:3841 z:66"
  places["TREASURE_25"] = "x:221 y:3474 z:77"
  places["ANCIENT_TREASURE_1"] = "x:3872 y:886 z:157"
  places["ANCIENT_TREASURE_2"] = "x:874 y:270 z:181"
  places["ANCIENT_TREASURE_3"] = "x:3159 y:3840 z:167"
  places["ANCIENT_TREASURE_4"] = "x:1723 y:778 z:74"
  places["ANCIENT_TREASURE_5"] = "x:474 y:3869 z:40"

  -- All bandit camp locations for RUIN Quest.
  places["RUIN_1"] = "x:3385 y:633 z:60"
  places["RUIN_2"] = "x:1724 y:708 z:69"
  places["RUIN_3"] = "x:3212 y:1380 z:101"
  places["RUIN_4"] = "x:1726 y:951 z:47"

  -- -- All bandit camp locations for RAIDERS Quest.
  places["RAIDERS_1"] = "x:2464 y:2195 z:150"
  places["RAIDERS_2"] = "x:2668 y:3163 z:136"
  places["RAIDERS_3"] = "x:1669 y:3257 z:53"
  places["RAIDERS_4"] = "x:3615 y:3193 z:172"
  places["RAIDERS_5"] = "x:2454 y:2362 z:100"

  -- All bandit camp locations for INTERLOPERS Quest.
  places["INTERLOPERS_1"] = "x:188 y:3266 z:106"
  places["INTERLOPERS_2"] = "x:536 y:2840 z:87"
  places["INTERLOPERS_3"] = "x:536 y:2395 z:32"

  -- MOLDAVITE_BANDIT_CAMP
  places["BANDITS_1"] = "x:365 y:1749 z:19"

  -- SKALITZ_SMELTERY_BANDIT_CAMP
  places["BANDITS_2"] = "x:873 y:3279 z:23"

  -- SASSAU_BANDIT_CAMP
  places["BANDITS_3"] = "x:1295 y:1707 z:40"

  -- MONASTERY_BANDIT_CAMP
  places["BANDITS_4"] = "x:696 y:2115 z:52"

  -- Gardens are a work in progress...
  places["GARDEN_WEST_RATTAY"] = "x:2305 y:623 z:39"
  places["GARDEN_WHEEL"] = "x:2836 y:769 z:92"

  -- For conveniently visiting all gardens.
  -- Work in progress.
  places["GARDEN_1"] = places["GARDEN_WEST_RATTAY"]
  places["GARDEN_2"] = places["GARDEN_WHEEL"]


  if places[cheat:toUpper(args)] ~= nil then
    cheat:teleport(places[cheat:toUpper(args)])
  else
    local checkteste = "error"
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
  local gender = player.soul:GetGender()
  local args = cheat:argsProcess(line, cheat.cheat_tp_tr_args)
  local nplace, nplaceErr = cheat:argsGet(args, 'place')

  local places = {}
  places["I"] = "x:645 y:1916 z:111"
  places["II"] = "x:384 y:1820 z:22"
  places["III"] = "x:220 y:1687 z:73"
  places["IV"] = "x:2777 y:1451 z:107"
  places["V"] = "x:2084 y:2056 z:126"
  places["VI"] = "x:2265 y:1592 z:114"
  places["VII"] = "x:1860 y:1525 z:81"
  places["VIII"] = "x:2330 y:1125 z:51"
  places["IX"] = "x:864 y:3280 z:21"
  places["X"] = "x:1683 y:943 z:41"
  places["XI"] = "x:1445 y:1137 z:37"
  places["XII"] = "x:3182 y:338 z:136"
  places["XIII"] = "x:3604 y:717 z:100"
  places["XIV"] = "x:3696 y:1258 z:87"
  places["XV"] = "x:2948 y:1316 z:85"
  places["XVI"] = "x:486 y:2571 z:21"
  places["XVII"] = "x:764 y:2572 z:20"
  places["XVIII"] = "x:2496 y:2805 z:101"
  places["XIX"] = "x:856 y:1341 z:18"
  places["XX"] = "x:734 y:3696 z:32"
  places["XXI"] = "x:658 y:3142 z:41"
  places["XXII"] = "x:594 y:608 z:159"
  places["XXIII"] = "x:1020 y:3968 z:52"
  places["XXIV"] = "x:900 y:3848 z:67"
  places["XXV"] = "x:212 y:3480 z:77"
  places["AI"] = "x:3879 y:889 z:159"
  places["AII"] = "x:877 y:262 z:180"
  places["AIII"] = "x:3158 y:3835 z:167"
  places["AIV"] = "x:1727 y:778 z:76"
  places["AV"] = "x:475 y:3864 z:39"

  if gender ~= 2 then
    if not nplaceErr then
      if places[cheat:toUpper(nplace)] ~= nil then
        cheat:teleport(places[cheat:toUpper(nplace)])
      else
        cheat:logError("Invalid Place - See list of supported places type: 'cheat_tp_tr ?'")
      end
    end
  else
    cheat:logError("You can't use this command while playing Thereza!")
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
  "Enables or disables the bow reticle. Won't take effect if bow is drawn.",
  "Turn it on", "cheat_set_bow_reticle enable:true",
  "Turn it off", "cheat_set_bow_reticle enable:false")
function cheat:cheat_set_bow_reticle(line)
  local args = cheat:argsProcess(line, cheat.cheat_set_bow_reticle_args)
  local enable, enableErr = cheat:argsGet(args, 'enable')
  if not enableErr then
    if enable then
      System.ExecuteCommand("wh_pl_showfirecursor 1")
      cheat:logInfo("Bow reticle on.")
    else
      System.ExecuteCommand("wh_pl_showfirecursor 0")
      cheat:logInfo("Bow reticle off.")
    end
    return true
  end
  return false
end

-- ============================================================================
-- cheat_set_chat_bubbles
-- ============================================================================
cheat.cheat_set_chat_bubbles_args = {
  enable = function(args,name,showHelp) return cheat:argsGetRequiredBoolean(args, name, showHelp, "true or false") end,
}

cheat:createCommand("cheat_set_chat_bubbles", "cheat:cheat_set_chat_bubbles(%line)", cheat.cheat_set_chat_bubbles_args,
  "Enables or disables chat cheat_set_chat_bubbles.",
  "Turn it on", "cheat_set_chat_bubbles enable:true",
  "Turn it off", "cheat_set_chat_bubbles enable:false")
function cheat:cheat_set_chat_bubbles(line)
  local args = cheat:argsProcess(line, cheat.cheat_set_chat_bubbles_args)
  local enable, enableErr = cheat:argsGet(args, 'enable')
  if not enableErr then
    if enable then
      System.ExecuteCommand("wh_dlg_chatbubbles 1")
      cheat:logInfo("Chat bubbles on.")
    else
      System.ExecuteCommand("wh_dlg_chatbubbles 0")
      cheat:logInfo("Chat bubbles off.")
    end
    return true
  end
  return false
end

-- ============================================================================
-- cheat_set_compass
-- ============================================================================
cheat.cheat_set_compass_args = {
  enable = function(args,name,showHelp) return cheat:argsGetRequiredBoolean(args, name, showHelp, "true or false") end,
}

cheat:createCommand("cheat_set_compass", "cheat:cheat_set_compass(%line)", cheat.cheat_set_compass_args,
  "Enables or disables the compass.",
  "Turn it on", "cheat_set_compass enable:true",
  "Turn it off", "cheat_set_compass enable:false")
function cheat:cheat_set_compass(line)
  local args = cheat:argsProcess(line, cheat.cheat_set_compass_args)
  local enable, enableErr = cheat:argsGet(args, 'enable')
  if not enableErr then
    if enable then
      System.ExecuteCommand("wh_ui_showCompass 1")
      cheat:logInfo("Compass on.")
    else
      System.ExecuteCommand("wh_ui_showCompass 0")
      cheat:logInfo("Compass off.")
    end
    return true
  end
  return false
end

-- ============================================================================
-- cheat_set_gevent_log_level
-- ============================================================================
cheat.cheat_set_gevent_log_level_args = {
  enable = function(args,name,showHelp) return cheat:argsGetRequiredBoolean(args, name, showHelp, "true or false") end,
}

cheat:createCommand("cheat_set_gevent_log_level", "cheat:cheat_set_gevent_log_level(%line)", cheat.cheat_set_gevent_log_level_args,
  "Enables or disables game event log level 3. Shows how much experience is gained for a skill/stat.",
  "Turn it on", "cheat_set_gevent_log_level enable:true",
  "Turn it off", "cheat_set_gevent_log_level enable:false")
function cheat:cheat_set_gevent_log_level(line)
  local args = cheat:argsProcess(line, cheat.cheat_set_gevent_log_level_args)
  local enable, enableErr = cheat:argsGet(args, 'enable')
  if not enableErr then
    if enable then
      System.ExecuteCommand("wh_ui_GameEventLogLevel 3")
      cheat:logInfo("Game event log level 3 on.")
    else
      System.ExecuteCommand("wh_ui_GameEventLogLevel 2")
      cheat:logInfo("Game event log level 3 off.")
    end
    return true
  end
  return false
end

-- ============================================================================
-- cheat_set_hud
-- ============================================================================
cheat.cheat_set_hud_args = {
  enable = function(args,name,showHelp) return cheat:argsGetRequiredBoolean(args, name, showHelp, "true or false") end,
}

cheat:createCommand("cheat_set_hud", "cheat:cheat_set_hud(%line)", cheat.cheat_set_hud_args,
  "Enables or disables the hud.",
  "Turn it on", "cheat_set_hud enable:true",
  "Turn it off", "cheat_set_hud enable:false")
function cheat:cheat_set_hud(line)
  local args = cheat:argsProcess(line, cheat.cheat_set_hud_args)
  local enable, enableErr = cheat:argsGet(args, 'enable')
  if not enableErr then
    if enable then
      System.ExecuteCommand("g_showHUD 1")
      cheat:logInfo("HUD on.")
    else
      System.ExecuteCommand("g_showHUD 0")
      cheat:logInfo("HUD off.")
    end
    return true
  end
  return false
end

-- ============================================================================
-- cheat_set_statusbar
-- ============================================================================
cheat.cheat_set_statusbar_args = {
  enable = function(args,name,showHelp) return cheat:argsGetRequiredBoolean(args, name, showHelp, "true or false") end,
}

cheat:createCommand("cheat_set_statusbar", "cheat:cheat_set_statusbar(%line)", cheat.cheat_set_statusbar_args,
  "Enables or disables the statusbar.",
  "Turn it on", "cheat_set_statusbar enable:true",
  "Turn it off", "cheat_set_statusbar enable:false")
function cheat:cheat_set_statusbar(line)
  local args = cheat:argsProcess(line, cheat.cheat_set_statusbar_args)
  local enable, enableErr = cheat:argsGet(args, 'enable')
  if not enableErr then
    if enable then
      System.ExecuteCommand("wh_ui_ShowStats 1")
      cheat:logInfo("Statusbar on.")
    else
      System.ExecuteCommand("wh_ui_ShowStats 0")
      cheat:logInfo("Statusbar off.")
    end
    return true
  end
  return false
end

-- ============================================================================
-- cheat_set_third_person
-- ============================================================================
cheat.cheat_set_third_person_args = {
  enable = function(args,name,showHelp) return cheat:argsGetRequiredBoolean(args, name, showHelp, "true or false") end,
}

cheat:createCommand("cheat_set_third_person", "cheat:cheat_set_third_person(%line)", cheat.cheat_set_third_person_args,
  "Enables or disables the third person view.",
  "Turn it on", "cheat_set_third_person enable:true",
  "Turn it off", "cheat_set_third_person enable:false")
function cheat:cheat_set_third_person(line)
  local args = cheat:argsProcess(line, cheat.cheat_set_third_person_args)
  local enable, enableErr = cheat:argsGet(args, 'enable')
  if not enableErr then
    if enable then
      System.ExecuteCommand("wh_pl_FollowEntity dude")
      cheat:logInfo("Third person view on.")
    else
      System.ExecuteCommand("wh_pl_FollowEntity 0")
      cheat:logInfo("Third person view off.")
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

  player.actor:WashDirtAndBlood(1)
  player.actor:WashItems(1)

  cheat:logInfo("All Clean!")
end

-- ============================================================================
-- cheat_charm
-- ============================================================================
cheat:createCommand("cheat_charm", "cheat:cheat_charm()", nil,
  "Automates your morning routine of bath-haircut-sex for maximum Charisma bonus.\n$8Washes all dirt and blood and applies Fresh Cut and Smitten buffs.",
  "Wash yourself and add Charisma buffs", "cheat_charm")
function cheat:cheat_charm()
  local gender = player.soul:GetGender()
  if gender ~= 2 then
    cheat:cheat_wash_dirt_and_blood()
    cheat:cheat_add_buff("id:fresh_cut")
    cheat:cheat_add_buff("id:alpha_male_in_love")
    player.soul:SetState("health", 1000)
    player.soul:SetState("stamina", 1000)
    player.soul:SetState("hunger", 100)
    player.soul:SetState("exhaust", 100)
    cheat:logInfo("All Clean and dandy!")
  else
    cheat:logError("You can't use this command while playing Thereza!")
  end
end

-- cheat_unlock_recipes
-- ============================================================================
cheat:createCommand("cheat_unlock_recipes", "cheat:cheat_unlock_recipes()", nil,
  "Saw this code to unlock recipes in a pak file.\n$8I have no idea what this really does or if it works.\n$8Let me know.",
  "Unlock all recipes", "cheat_unlock_recipes")
function cheat:cheat_unlock_recipes()
  local gender = player.soul:GetGender()
  if gender ~= 2 then
    for i=2,26 do
      for y=1,5 do RPG.UnlockRecipe(player, i, y); end
    end
    cheat:logInfo("Recipies unlocked.")
    return true
  else
    cheat:logError("You can't use this command while playing Thereza!")
  end
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
