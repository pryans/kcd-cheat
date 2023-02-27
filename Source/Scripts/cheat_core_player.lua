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
-- Thanks to these sources, and others for helping to find many of these places:
-- https://kingdomcomemap.github.io/
-- https://forum.kingdomcomerpg.com/t/map-enemy-camps/41266
-- https://www.reddit.com/r/kingdomcome/comments/tw7u1p/map_of_all_cuman_and_bandit_camp_locations/
-- https://kingdom-come-deliverance.fandom.com/
-- ============================================================================
System.AddCCommand('cheat_teleport_to', 'cheat:teleport_to(%line)', "Teleports the player to the given place. Supported places (case insensitive):\n$8Ledetchko, Merhojed, Monastery,\n$8Neuhof, Pribyslavitz, Rattay,\n$8Rovna, Samopesh, Sasau,\n$8Skalitz, Talmberg, Uzhitz, Vranik")

function cheat:teleport_to(line)
  if player.soul:GetGender() == 2 then
    cheat:logError("You can't use this command while playing Thereza!")
    return
  end
  
  local args = string.gsub(tostring(line), "place:", "")
  
  local places = {}
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
-- cheat_tp_bc (BANDIT CAMPS)
-- ============================================================================
cheat.cheat_tp_bc_args = {
  place = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "Teleport to bandit camp") end,
}

cheat:createCommand("cheat_tp_bc", "cheat:tp_bc(%line)", cheat.cheat_tp_bc_args,
"Teleports the player to the given place. Supported places (case insensitive):\n$8RN_1, RN_2, RN_3, RN_4, RS_1, RS_2, RS_3, RS_4, RS_5, IL_1, IL_2, IL_3,\n$8BC_1, BC_2, BC_3, BC_4, BC_5, BC_6, BC_7, BC_8, BC_9, BC_10",
"Example", "cheat_tp_bc place:RS_1")
function cheat:tp_bc(line)
  local gender = player.soul:GetGender()
  local args = cheat:argsProcess(line, cheat.cheat_tp_bc_args)
  local nplace, nplaceErr = cheat:argsGet(args, 'place')
  
  local places = {}
  -- As I am not a big fan of much typing I shortened all places names (WileCoyote68)
  -- All bandit camp locations for RUIN Quest.
  places["RN_1"] = "x:3385 y:633 z:60"
  places["RN_2"] = "x:1724 y:708 z:69"
  places["RN_3"] = "x:3212 y:1380 z:101"
  places["RN_4"] = "x:1726 y:951 z:47"
  
  -- All bandit camp locations for RAIDERS Quest.
  places["RS_1"] = "x:2464 y:2195 z:150"
  places["RS_2"] = "x:2668 y:3163 z:136"
  places["RS_3"] = "x:1669 y:3257 z:53"
  places["RS_4"] = "x:3615 y:3193 z:172"
  places["RS_5"] = "x:2454 y:2362 z:100"
  
  -- All bandit camp locations for INTERLOPERS Quest.
  places["IL_1"] = "x:188 y:3266 z:106"
  places["IL_2"] = "x:536 y:2840 z:87"
  places["IL_3"] = "x:536 y:2395 z:32"
  
  -- MOLDAVITE_BANDIT_CAMP
  places["BC_1"] = "x:365 y:1749 z:19"
  -- SKALITZ_SMELTERY_BANDIT_CAMP
  places["BC_2"] = "x:873 y:3279 z:23"
  -- SASAU_BANDIT_CAMP
  places["BC_3"] = "x:1295 y:1707 z:40"
  -- MONASTERY_BANDIT_CAMP
  places["BC_4"] = "x:696 y:2115 z:52"
  -- North of Merhojed
  places["BC_5"] = "x:1731 y:2977 z:132"
  -- east of skalitz
  places["BC_6"] = "x:1274 y:3499 z:87"
  -- west of Rattai
  places["BC_7"] = "x:1271 y:532 z:156"
  -- north of monastery
  places["BC_8"] = "x:692 y:2110 z:52"
  -- West of vranik (poachers)
  places["BC_9"] = "x:229 y:999 z:156"
  -- cumans southeast of talmberg (not raiders? they drop ears)
  places["BC_10"] = "x:2697 y:2187 z:126"
  
  if gender ~= 2 then
    if not nplaceErr then
      if places[cheat:toUpper(nplace)] ~= nil then
        cheat:teleport(places[cheat:toUpper(nplace)])
      else
        cheat:logError("Invalid Place - See list of supported places type: 'cheat_tp_bc ?'")
      end
    end
  else
    cheat:logError("You can't use this command while playing Thereza!")
  end
end

-- ============================================================================
-- cheat_tp_bh (BATH HOUSE)
-- ============================================================================
cheat.cheat_tp_bh_args = {
  place = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "Teleport to bath house") end,
}

cheat:createCommand("cheat_tp_bh", "cheat:tp_bh(%line)", cheat.cheat_tp_bh_args,
"Teleports the player to the given place. Supported places (case insensitive):\n$8LEDETCHKO, RATTAY, SASAU, TALMBERG",
"Example", "cheat_tp_bh place:SASAU")
function cheat:tp_bh(line)
  local gender = player.soul:GetGender()
  local args = cheat:argsProcess(line, cheat.cheat_tp_bh_args)
  local nplace, nplaceErr = cheat:argsGet(args, 'place')
  
  local places = {}
  places["LEDETCHKO"] = "x:2042 y:1282 z:28"
  places["RATTAY"] = "x:2380 y:595 z:31"
  places["SASAU"] = "x:959 y:1317 z:19"
  places["TALMBERG"] = "x:2390 y:2810 z:89"  
  
  if gender ~= 2 then
    if not nplaceErr then
      if places[cheat:toUpper(nplace)] ~= nil then
        cheat:teleport(places[cheat:toUpper(nplace)])
      else
        cheat:logError("Invalid Place - See list of supported places type: 'cheat_tp_bh ?'")
      end
    end
  else
    cheat:logError("You can't use this command while playing Thereza!")
  end
end

-- ============================================================================
-- cheat_tp_cb (CHARCOAL-BURNER CAMPS)
-- ============================================================================
cheat.cheat_tp_cb_args = {
  place = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "Teleport to charcoal-burner camp") end,
}

cheat:createCommand("cheat_tp_cb", "cheat:tp_cb(%line)", cheat.cheat_tp_cb_args,
"Teleports the player to the given place. Supported places (case insensitive):\n$8NH_NORTH, NH_SOUTH, RATTAY, ROVNA, SASAU, TALMBERG",
"Example", "cheat_tp_cb place:RATTAY")
function cheat:tp_cb(line)
  local gender = player.soul:GetGender()
  local args = cheat:argsProcess(line, cheat.cheat_tp_cb_args)
  local nplace, nplaceErr = cheat:argsGet(args, 'place')
  
  local places = {}
  places["NH_NORTH"] = "x:3256 y:2122 z:127"
  places["NH_SOUTH"] = "x:3634 y:942 z:86"
  places["RATTAY"] = "x:1909 y:677 z:28"
  places["ROVNA"] = "x:1316 y:3316 z:62"
  places["SASAU"] = "x:343 y:1981 z:18"
  places["TALMBERG"] = "x:2695 y:2317 z:102"  
  
  if gender ~= 2 then
    if not nplaceErr then
      if places[cheat:toUpper(nplace)] ~= nil then
        cheat:teleport(places[cheat:toUpper(nplace)])
      else
        cheat:logError("Invalid Place - See list of supported places type: 'cheat_tp_cb ?'")
      end
    end
  else
    cheat:logError("You can't use this command while playing Thereza!")
  end
end

-- ============================================================================
-- cheat_tp_gn (FOREST GARDEN)
-- ============================================================================
cheat.cheat_tp_gn_args = {
  place = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "Teleport to garden") end,
}

cheat:createCommand("cheat_tp_gn", "cheat:tp_gn(%line)", cheat.cheat_tp_gn_args,
"Teleports the player to the given place. Supported places (case insensitive):\n$8GN_1, GN_2, GN_3, GN_4, GN_5, GN_6, GN_7, GN_8, GN_9, GN_10, GN_11, GN_12, GN_13, GN_14, GN_15,\n$8GN_16, GN_17, GN_18, GN_19, GN_20, GN_21, GN_22, GN_23, GN_24, GN_25, GN_26, GN_27, GN_28, GN_29, GN30, GN_31, GN_32, GN_33, GN_34, GN_35, GN_36, GN_37, GN_38, GN_39",
"Example", "cheat_tp_gn place:GN_1")
function cheat:tp_gn(line)
  local gender = player.soul:GetGender()
  local args = cheat:argsProcess(line, cheat.cheat_tp_gn_args)
  local nplace, nplaceErr = cheat:argsGet(args, 'place')
  
  local places = {}
  -- Credit to https://kingdomcomemap.github.io/#1.97/2325.6/1592.8
  places["GN_1"] = "x:974 y:3896 z:62"
  places["GN_2"] = "x:427 y:3670 z:40"
  places["GN_3"] = "x:1205 y:3681 z:32"
  places["GN_4"] = "x:128 y:3326 z:109"
  places["GN_5"] = "x:2330 y:3518 z:160"
  places["GN_6"] = "x:3554 y:3581 z:156"
  places["GN_7"] = "x:2812 y:3233 z:151"
  places["GN_8"] = "x:3092 y:2675 z:179"
  places["GN_9"] = "x:3632 y:2622 z:168"
  places["GN_10"] = "x:1731 y:2977 z:132"
  places["GN_11"] = "x:1630 y:2868 z:122"
  places["GN_12"] = "x:1215 y:2641 z:27"
  places["GN_13"] = "x:1917 y:2553 z:128"
  places["GN_14"] = "x:2617 y:2459 z:136"
  places["GN_15"] = "x:924 y:2356 z:50"
  places["GN_16"] = "x:991 y:2321 z:55"
  places["GN_17"] = "x:957 y:2275 z:62"
  places["GN_18"] = "x:1181 y:2151 z:74"
  places["GN_19"] = "x:541 y:1850 z:83"
  places["GN_20"] = "x:1484 y:1764 z:35"
  places["GN_21"] = "x:1102 y:1252 z:43"
  places["GN_22"] = "x:784 y:908 z:124"
  places["GN_23"] = "x:1204 y:744 z:66"
  places["GN_24"] = "x:1581 y:1272 z:36"
  places["GN_25"] = "x:1897 y:1064 z:29"
  places["GN_26"] = "x:2307 y:616 z:40"
  places["GN_27"] = "x:2836 y:766 z:94"
  places["GN_28"] = "x:3143 y:504 z:71"
  places["GN_29"] = "x:3170 y:331 z:137"
  places["GN_30"] = "x:3604 y:725 z:102"
  places["GN_31"] = "x:3803 y:1121 z:107"
  places["GN_32"] = "x:3830 y:1681 z:121"
  places["GN_33"] = "x:3280 y:1979 z:154"
  places["GN_34"] = "x:2868 y:1626 z:131"
  places["GN_35"] = "x:2572 y:1871 z:138"
  places["GN_36"] = "x:2559 y:2031 z:162"
  places["GN_37"] = "x:2159 y:1524 z:65"
  places["GN_38"] = "x:1860 y:1519 z:80"
  places["GN_39"] = "x:1581 y:1272 z:35"
  
  if gender ~= 2 then
    if not nplaceErr then
      if places[cheat:toUpper(nplace)] ~= nil then
        cheat:teleport(places[cheat:toUpper(nplace)])
      else
        cheat:logError("Invalid Place - See list of supported places type: 'cheat_tp_gn ?'")
      end
    end
  else
    cheat:logError("You can't use this command while playing Thereza!")
  end
end

-- ============================================================================
-- cheat_tp_hl (HERBALISTS)
-- ============================================================================
cheat.cheat_tp_hl_args = {
  place = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "Teleport to herbalist") end,
}

cheat:createCommand("cheat_tp_hl", "cheat:tp_hl(%line)", cheat.cheat_tp_hl_args,
"Teleports the player to the given place. Supported places (case insensitive):\n$8GERTRUDE, KUNHUTA, NEUHOF, SAMOPESH",
"Example", "cheat_tp_hl place:KUNHUTA")
function cheat:tp_hl(line)
  local gender = player.soul:GetGender()
  local args = cheat:argsProcess(line, cheat.cheat_tp_hl_args)
  local nplace, nplaceErr = cheat:argsGet(args, 'place')
  
  local places = {}
  places["GERTRUDE"] = "x:2318 y:3295 z:150"
  places["KUNHUTA"] = "x:1980 y:1624 z:100"
  places["NEUHOF"] = "x:3247 y:1518 z:117"
  places["SAMOPESH"] = "x:948 y:2338 z:53"  
  
  if gender ~= 2 then
    if not nplaceErr then
      if places[cheat:toUpper(nplace)] ~= nil then
        cheat:teleport(places[cheat:toUpper(nplace)])
      else
        cheat:logError("Invalid Place - See list of supported places type: 'cheat_tp_hl ?'")
      end
    end
  else
    cheat:logError("You can't use this command while playing Thereza!")
  end
end

-- ============================================================================
-- cheat_tp_ml (MILLS)
-- ============================================================================
cheat.cheat_tp_ml_args = {
  place = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "Teleport to herbalist") end,
}

cheat:createCommand("cheat_tp_ml", "cheat:tp_ml(%line)", cheat.cheat_tp_ml_args,
"Teleports the player to the given place. Supported places (case insensitive):\n$8BUDIN, KATZEK, KOHELNITZ, LEDETCHKO, RATTAY",
"Example", "cheat_tp_ml place:BUDIN")
function cheat:tp_ml(line)
  local gender = player.soul:GetGender()
  local args = cheat:argsProcess(line, cheat.cheat_tp_ml_args)
  local nplace, nplaceErr = cheat:argsGet(args, 'place')
  
  local places = {}
  places["BUDIN"] = "x:1405 y:1463 z:19"
  places["KATZEK"] = "x:1602 y:1838 z:20"
  places["KOHELNITZ"] = "x:2823 y:1232 z:25"
  places["LEDETCHKO"] = "x:2099 y:1317 z:27"
  places["RATTAY"] = "x:2451 y:693 z:28"
  
  if gender ~= 2 then
    if not nplaceErr then
      if places[cheat:toUpper(nplace)] ~= nil then
        cheat:teleport(places[cheat:toUpper(nplace)])
      else
        cheat:logError("Invalid Place - See list of supported places type: 'cheat_tp_gn ?'")
      end
    end
  else
    cheat:logError("You can't use this command while playing Thereza!")
  end
end

-- ============================================================================
-- cheat_tp_tvn (TAVERNS)
-- ============================================================================
cheat.cheat_tp_tvn_args = {
  place = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "Teleport to tavern") end,
}

cheat:createCommand("cheat_tp_tvn", "cheat:tp_tvn(%line)", cheat.cheat_tp_tvn_args,
"Teleports the player to the given place. Supported places (case insensitive):\n$8EAST, GLADE, TALMBERG, WAGONERS, WEST, WHEEL",
"Example", "cheat_tp_tvn place:GLADE")
function cheat:tp_tvn(line)
  local gender = player.soul:GetGender()
  local args = cheat:argsProcess(line, cheat.cheat_tp_tvn_args)
  local nplace, nplaceErr = cheat:argsGet(args, 'place')
  
  local places = {}
  places["RATTAY_EAST"] = "x:2718 y:625 z:95"
  places["GLADE"] = "x:2849 y:1913 z:156"
  places["TALMBERG"] = "x:2395 y:2727 z:87"
  places["WAGONERS"] = "x:938 y:1424 z:24"
  places["RATTAY_WEST"] = "x:2635 y:620 z:89"
  places["WHEEL"] = "x:2915 y:733 z:108"
  
  if gender ~= 2 then
    if not nplaceErr then
      if places[cheat:toUpper(nplace)] ~= nil then
        cheat:teleport(places[cheat:toUpper(nplace)])
      else
        cheat:logError("Invalid Place - See list of supported places type: 'cheat_tp_tvn ?'")
      end
    end
  else
    cheat:logError("You can't use this command while playing Thereza!")
  end
end

-- ============================================================================
-- cheat_tp_tr
-- ============================================================================
cheat.cheat_tp_tr_args = {
  place = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "Teleport to treasure") end,
}

cheat:createCommand("cheat_tp_tr", "cheat:tp_tr(%line)", cheat.cheat_tp_tr_args,
"Teleports the player to the given place. Supported places (case insensitive):\n$8TR_1, TR_2, TR_3, TR_4, TR_5, TR_6, TR_7, TR_8, TR_9, TR_10, TR_11, TR_12, TR_13, TR_14, TR_15,\n$8TR_16, TR_17, TR_18, TR_19, TR_20, TR_21, TR_22, TR_23, TR_24, TR_25, ATR_1, ATR_2, ATR_3, ATR_4, ATR_5",
"Example", "cheat_tp_tr place:TR_1")
function cheat:tp_tr(line)
  local gender = player.soul:GetGender()
  local args = cheat:argsProcess(line, cheat.cheat_tp_tr_args)
  local nplace, nplaceErr = cheat:argsGet(args, 'place')
  
  -- All treasure locations. I preferred arabic numerals to roman
  -- numerals because it is much easier to visit all of them in order.
  -- (You normally only need to change one digit and re-run the command)
  local places = {}
  places["TR_1"] = "x:650 y:1920 z:106"
  places["TR_2"] = "x:382 y:1813 z:22"
  places["TR_3"] = "x:223 y:1695 z:71"
  places["TR_4"] = "x:2772 y:1449 z:106"
  places["TR_5"] = "x:2086 y:2054 z:126"
  places["TR_6"] = "x:2268 y:1589 z:114"
  places["TR_7"] = "x:1860 y:1521 z:80"
  places["TR_8"] = "x:2332 y:1120 z:54"
  places["TR_9"] = "x:869 y:3279 z:19"
  places["TR_10"] = "x:1683 y:938 z:41"
  places["TR_11"] = "x:1445 y:1140 z:37"
  places["TR_12"] = "x:3175 y:335 z:136"
  places["TR_13"] = "x:3610 y:721 z:100"
  places["TR_14"] = "x:3692 y:1258 z:87"
  places["TR_15"] = "x:2942 y:1329 z:90"
  places["TR_16"] = "x:482 y:2578 z:20"
  places["TR_17"] = "x:769 y:2572 z:20"
  places["TR_18"] = "x:2494 y:2817 z:99"
  places["TR_19"] = "x:856 y:1335 z:18"
  places["TR_20"] = "x:740 y:3699 z:30"
  places["TR_21"] = "x:657 y:3141 z:41"
  places["TR_22"] = "x:600 y:608 z:158"
  places["TR_23"] = "x:1011 y:3972 z:51"
  places["TR_24"] = "x:903 y:3841 z:66"
  places["TR_25"] = "x:221 y:3474 z:77"
  places["ATR_1"] = "x:3872 y:886 z:157"
  places["ATR_2"] = "x:874 y:270 z:181"
  places["ATR_3"] = "x:3159 y:3840 z:167"
  places["ATR_4"] = "x:1723 y:778 z:74"
  places["ATR_5"] = "x:474 y:3869 z:40"
  
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
-- cheat_tp_wc (WOODCUTTER CAMP)
-- ============================================================================
cheat.cheat_tp_wc_args = {
  place = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "Teleport to tavern") end,
}

cheat:createCommand("cheat_tp_wc", "cheat:tp_wc(%line)", cheat.cheat_tp_wc_args,
"Teleports the player to the given place. Supported places (case insensitive):\n$8LEDETCHKO, RATTAY, RATTAY_WOODS, TALMBERG, UZHITZ",
"Example", "cheat_tp_wc place:RATTAY")
function cheat:tp_wc(line)
  local gender = player.soul:GetGender()
  local args = cheat:argsProcess(line, cheat.cheat_tp_wc_args)
  local nplace, nplaceErr = cheat:argsGet(args, 'place')
  
  local places = {}
  places["LEDETCHKO"] = "x:1631 y:1447 z:65"
  places["RATTAY"] = "x:1950 y:926 z:71"
  places["RATTAY_WOODS"] = "x:2697 y:1742 z:132"
  places["TALMBERG"] = "x:2221 y:3153 z:131"
  places["UZHITZ"] = "x:2296 y:3833 z:155"  
  
  if gender ~= 2 then
    if not nplaceErr then
      if places[cheat:toUpper(nplace)] ~= nil then
        cheat:teleport(places[cheat:toUpper(nplace)])
      else
        cheat:logError("Invalid Place - See list of supported places type: 'cheat_tp_wc ?'")
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
