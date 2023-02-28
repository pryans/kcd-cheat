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
    cheat:logError("Thereza doesn't have a stash")
  end
end

-- ============================================================================
-- cheat_loc
-- ============================================================================
cheat:createCommand("cheat_loc", "cheat:loc()", nil,
  "Shows player's world location.",
  "Type to console", "cheat_loc")
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
  "Type to console", "cheat_teleport x:3000 y:1500 z:300")
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

-- Thanks to these sources, and others for helping to find many of these places:
-- https://kingdomcomemap.github.io/
-- https://forum.kingdomcomerpg.com/t/map-enemy-camps/41266
-- https://www.reddit.com/r/kingdomcome/comments/tw7u1p/map_of_all_cuman_and_bandit_camp_locations/
-- https://kingdom-come-deliverance.fandom.com/

System.AddCCommand('cheat_teleport_to', 'cheat:teleport_to(%line)',
"Teleports the player to the given town or village.\n$8\n$8\n$8Supported places:\n$8LEDETCHKO (1), MERHOJED (2), MONASTERY (3),\n$8NEUHOF (4), PRIBYSLAVITZ (5), RATTAY (6),\n$8ROVNA (7), SAMOPESH (8), SASAU (9),\n$8SKALITZ (10), TALMBERG (11), UZHITZ (12), VRANIK (13)")

function cheat:teleport_to(line)
  if player.soul:GetGender() == 2 then
    cheat:logError("You can't use this command while playing Thereza!")
    return
  end
  
  local args = string.gsub(tostring(line), "place:", "")
  
  local places = {}
  places["1"] = "x:2052 y:1304 z:30"
  places["2"] = "x:1636 y:2618 z:126"
  places["3"] = "x:929 y:1617 z:36"
  places["4"] = "x:3522 y:1524 z:131"
  places["5"] = "x:1557 y:3719 z:107"
  places["6"] = "x:2534 y:572 z:81"
  places["7"] = "x:1261 y:3129 z:25"
  places["8"] = "x:1139 y:2239 z:71"
  places["9"] = "x:896 y:1186 z:27"
  places["10"] = "x:829 y:3522 z:51"
  places["11"] = "x:2360 y:2846 z:105"
  places["12"] = "x:3041 y:3324 z:156"
  places["13"] = "x:930 y:913 z:130"

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
"Teleports the player to the given bandit camp.\n$8\n$8\n$8Camps are numbered as follows:\n$8\n$81 to 4 for camps related to the Ruin quest\n$85 to 9 related to the Raiders quest\n$810 to 12 for the Interloopers quest\n$8\n$8For all other bandit camps as noted below:\n$8\n$8MOLDAVIT CAMP (13), SKALITZ SMELTERY (14), SASAU (15),\n$8MONASTERY (16), NORTH OF MONASTERY (17), NORTH OF MERHOJED (18),\n$8EAST OF SKALITZ (19), WEST OF RATTAY (20), WEST OF VRANIK (21), SOUTH EAST OF TALMBERG (22)",
"Type to console", "cheat_tp_bc place:1")
function cheat:tp_bc(line)
  local gender = player.soul:GetGender()
  local args = cheat:argsProcess(line, cheat.cheat_tp_bc_args)
  local nplace, nplaceErr = cheat:argsGet(args, 'place')
  
  local places = {}
  -- As I am not a big fan of much typing I shortened all places names (WileCoyote68)
  -- All bandit camp locations for RUIN Quest.
  places["1"] = "x:3385 y:633 z:60"
  places["2"] = "x:1724 y:708 z:69"
  places["3"] = "x:3212 y:1380 z:101"
  places["4"] = "x:1726 y:951 z:47"
  
  -- All bandit camp locations for RAIDERS Quest.
  places["5"] = "x:2464 y:2195 z:150"
  places["6"] = "x:2668 y:3163 z:136"
  places["7"] = "x:1669 y:3257 z:53"
  places["8"] = "x:3615 y:3193 z:172"
  places["9"] = "x:2454 y:2362 z:100"
  
  -- All bandit camp locations for INTERLOPERS Quest.
  places["10"] = "x:188 y:3266 z:106"
  places["11"] = "x:536 y:2840 z:87"
  places["12"] = "x:536 y:2395 z:32"
  
  -- MOLDAVITE_BANDIT_CAMP
  places["13"] = "x:365 y:1749 z:19"
  -- SKALITZ_SMELTERY_BANDIT_CAMP
  places["14"] = "x:873 y:3279 z:23"
  -- SASAU_BANDIT_CAMP
  places["15"] = "x:1295 y:1707 z:40"
  -- MONASTERY_BANDIT_CAMP
  places["16"] = "x:696 y:2115 z:52"
  -- NORTH OF MONASTERY
  places["17"] = "x:692 y:2110 z:52"
  -- NORTH OF MERHOJED
  places["18"] = "x:1731 y:2977 z:132"
  -- EAST OF SKALITZ
  places["19"] = "x:1274 y:3499 z:87"
  -- WEST OF RATTAY
  places["20"] = "x:1271 y:532 z:156"
  -- WEST OF VRANIK (poachers)
  places["21"] = "x:229 y:999 z:156"
  -- SOUTH EAST OF TALMBERG (not raiders? they drop ears)
  places["22"] = "x:2697 y:2187 z:126"
  
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
-- cheat_tp_bh (BATH HOUSES)
-- ============================================================================
cheat.cheat_tp_bh_args = {
  place = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "Teleport to bath house") end,
}

cheat:createCommand("cheat_tp_bh", "cheat:tp_bh(%line)", cheat.cheat_tp_bh_args,
"Teleports the player to the given bath house.\n$8\n$8\n$8Supported places:\n$8LEDETCHKO (1), RATTAY (2), SASAU (3), TALMBERG (4)",
"Type to console", "cheat_tp_bh place:1")
function cheat:tp_bh(line)
  local gender = player.soul:GetGender()
  local args = cheat:argsProcess(line, cheat.cheat_tp_bh_args)
  --local args = string.gsub(tostring(line), "place:", "")
  local nplace, nplaceErr = cheat:argsGet(args, 'place')
  
  local places = {}
  places["1"] = "x:2042 y:1282 z:28"
  places["2"] = "x:2380 y:595 z:31"
  places["3"] = "x:959 y:1317 z:19"
  places["4"] = "x:2390 y:2810 z:89"  
  
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
"Teleports the player to the given charcoal-burner camp.\n$8\n$8\n$8Supported places:\n$8NEUHOF NORTH (1), NEUHOF SOUTH (2), RATTAY (3), ROVNA (4), SASAU (5), TALMBERG (6)",
"Type to console", "cheat_tp_cb place:1")
function cheat:tp_cb(line)
  local gender = player.soul:GetGender()
  local args = cheat:argsProcess(line, cheat.cheat_tp_cb_args)
  local nplace, nplaceErr = cheat:argsGet(args, 'place')
  
  local places = {}
  places["1"] = "x:3256 y:2122 z:127"
  places["2"] = "x:3634 y:942 z:86"
  places["3"] = "x:1909 y:677 z:28"
  places["4"] = "x:1316 y:3316 z:62"
  places["5"] = "x:343 y:1981 z:18"
  places["6"] = "x:2695 y:2317 z:102"  
  
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
-- cheat_tp_gn (WOODLAND GARDENS)
-- ============================================================================
cheat.cheat_tp_gn_args = {
  place = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "Teleport to garden") end,
}

cheat:createCommand("cheat_tp_gn", "cheat:tp_gn(%line)", cheat.cheat_tp_gn_args,
"Teleports the player to the given woodland garden.\n$8Use a number between 1 and 39 to teleport to a specific garden",
"Type to console", "cheat_tp_gn place:1")
function cheat:tp_gn(line)
  local gender = player.soul:GetGender()
  local args = cheat:argsProcess(line, cheat.cheat_tp_gn_args)
  local nplace, nplaceErr = cheat:argsGet(args, 'place')
  
  -- Credit to https://kingdomcomemap.github.io/#1.97/2325.6/1592.8
  local places = {}
  places["1"] = "x:974 y:3896 z:62"
  places["2"] = "x:427 y:3670 z:40"
  places["3"] = "x:1205 y:3681 z:32"
  places["4"] = "x:128 y:3326 z:109"
  places["5"] = "x:2330 y:3518 z:160"
  places["6"] = "x:3554 y:3581 z:156"
  places["7"] = "x:2812 y:3233 z:151"
  places["8"] = "x:3092 y:2675 z:179"
  places["9"] = "x:3632 y:2622 z:168"
  places["10"] = "x:1731 y:2977 z:132"
  places["11"] = "x:1630 y:2868 z:122"
  places["12"] = "x:1215 y:2641 z:27"
  places["13"] = "x:1917 y:2553 z:128"
  places["14"] = "x:2617 y:2459 z:136"
  places["15"] = "x:924 y:2356 z:50"
  places["16"] = "x:991 y:2321 z:55"
  places["17"] = "x:957 y:2275 z:62"
  places["18"] = "x:1181 y:2151 z:74"
  places["19"] = "x:541 y:1850 z:83"
  places["20"] = "x:1484 y:1764 z:35"
  places["21"] = "x:1102 y:1252 z:43"
  places["22"] = "x:784 y:908 z:124"
  places["23"] = "x:1204 y:744 z:66"
  places["24"] = "x:1581 y:1272 z:36"
  places["25"] = "x:1897 y:1064 z:29"
  places["26"] = "x:2307 y:616 z:40"
  places["27"] = "x:2836 y:766 z:94"
  places["28"] = "x:3143 y:504 z:71"
  places["29"] = "x:3170 y:331 z:137"
  places["30"] = "x:3604 y:725 z:102"
  places["31"] = "x:3803 y:1121 z:107"
  places["32"] = "x:3830 y:1681 z:121"
  places["33"] = "x:3280 y:1979 z:154"
  places["34"] = "x:2868 y:1626 z:131"
  places["35"] = "x:2572 y:1871 z:138"
  places["36"] = "x:2559 y:2031 z:162"
  places["37"] = "x:2159 y:1524 z:65"
  places["38"] = "x:1860 y:1519 z:80"
  places["39"] = "x:1581 y:1272 z:35"
  
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
"Teleports the player to the given herbalist.\n$8\n$8\n$8Supported places:\n$8GERTRUDE (1), KUNHUTA (2), NEUHOF (3), SAMOPESH (4)",
"Type to console", "cheat_tp_hl place:1")
function cheat:tp_hl(line)
  local gender = player.soul:GetGender()
  local args = cheat:argsProcess(line, cheat.cheat_tp_hl_args)
  local nplace, nplaceErr = cheat:argsGet(args, 'place')
  
  local places = {}
  places["1"] = "x:2318 y:3295 z:150"
  places["2"] = "x:1980 y:1624 z:100"
  places["3"] = "x:3247 y:1518 z:117"
  places["4"] = "x:948 y:2338 z:53"  
  
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
"Teleports the player to the given mill.\n$8\n$8\n$8Supported places:\n$8BUDIN (1), KATZEK (2), KOHELNITZ (3), LEDETCHKO (4), RATTAY (5)",
"Type to console", "cheat_tp_ml place:1")
function cheat:tp_ml(line)
  local gender = player.soul:GetGender()
  local args = cheat:argsProcess(line, cheat.cheat_tp_ml_args)
  local nplace, nplaceErr = cheat:argsGet(args, 'place')
  
  local places = {}
  places["1"] = "x:1405 y:1463 z:19"
  places["2"] = "x:1602 y:1838 z:20"
  places["3"] = "x:2823 y:1232 z:25"
  places["4"] = "x:2099 y:1317 z:27"
  places["5"] = "x:2451 y:693 z:28"
  
  if gender ~= 2 then
    if not nplaceErr then
      if places[cheat:toUpper(nplace)] ~= nil then
        cheat:teleport(places[cheat:toUpper(nplace)])
      else
        cheat:logError("Invalid Place - See list of supported places type: 'cheat_tp_ml ?'")
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
"Teleports the player to the given taverns.\n$8\n$8\n$8Supported places:\n$8RATTAY_EAST (1), GLADE (2), TALMBERG (3), WAGONERS (4), RATTAY_WEST (5), WHEEL (6)",
"Type to console", "cheat_tp_tvn place:1")
function cheat:tp_tvn(line)
  local gender = player.soul:GetGender()
  local args = cheat:argsProcess(line, cheat.cheat_tp_tvn_args)
  local nplace, nplaceErr = cheat:argsGet(args, 'place')
  
  local places = {}
  places["1"] = "x:2718 y:625 z:95"
  places["2"] = "x:2849 y:1913 z:156"
  places["3"] = "x:2395 y:2727 z:87"
  places["4"] = "x:938 y:1424 z:24"
  places["5"] = "x:2635 y:620 z:89"
  places["6"] = "x:2915 y:733 z:108"
  
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
-- cheat_tp_tr (TREASURE MAPS)
-- ============================================================================
cheat.cheat_tp_tr_args = {
  place = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "Teleport to treasure") end,
}

cheat:createCommand("cheat_tp_tr", "cheat:tp_tr(%line)", cheat.cheat_tp_tr_args,
"Teleports the player to the given treasure.\n$8\n$8\n$8Each map has its own number:\n$8\n$8For Treasure Maps use: 1 to 25 and\n$8For Ancient Treasure Maps use: 26 to 30",
"Type to console", "cheat_tp_tr place:1")
function cheat:tp_tr(line)
  local gender = player.soul:GetGender()
  local args = cheat:argsProcess(line, cheat.cheat_tp_tr_args)
  local nplace, nplaceErr = cheat:argsGet(args, 'place')
  
  -- All treasure locations. I preferred arabic numerals to roman
  -- numerals because it is much easier to visit all of them in order.
  -- (You normally only need to change one digit and re-run the command)
  local places = {}
  places["1"] = "x:650 y:1920 z:106"
  places["2"] = "x:382 y:1813 z:22"
  places["3"] = "x:223 y:1695 z:71"
  places["4"] = "x:2772 y:1449 z:106"
  places["5"] = "x:2086 y:2054 z:126"
  places["6"] = "x:2268 y:1589 z:114"
  places["7"] = "x:1860 y:1521 z:80"
  places["8"] = "x:2332 y:1120 z:54"
  places["9"] = "x:869 y:3279 z:19"
  places["10"] = "x:1683 y:938 z:41"
  places["11"] = "x:1445 y:1140 z:37"
  places["12"] = "x:3175 y:335 z:136"
  places["13"] = "x:3610 y:721 z:100"
  places["14"] = "x:3692 y:1258 z:87"
  places["15"] = "x:2942 y:1329 z:90"
  places["16"] = "x:482 y:2578 z:20"
  places["17"] = "x:769 y:2572 z:20"
  places["18"] = "x:2494 y:2817 z:99"
  places["19"] = "x:856 y:1335 z:18"
  places["20"] = "x:740 y:3699 z:30"
  places["21"] = "x:657 y:3141 z:41"
  places["22"] = "x:600 y:608 z:158"
  places["23"] = "x:1011 y:3972 z:51"
  places["24"] = "x:903 y:3841 z:66"
  places["25"] = "x:221 y:3474 z:77"
  places["26"] = "x:3872 y:886 z:157"
  places["27"] = "x:874 y:270 z:181"
  places["28"] = "x:3159 y:3840 z:167"
  places["29"] = "x:1723 y:778 z:74"
  places["30"] = "x:474 y:3869 z:40"
  
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
-- cheat_tp_wc (WOODCUTTER CAMPS)
-- ============================================================================
cheat.cheat_tp_wc_args = {
  place = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "Teleport to tavern") end,
}

cheat:createCommand("cheat_tp_wc", "cheat:tp_wc(%line)", cheat.cheat_tp_wc_args,
"Teleports the player to the given woodcutter camp.\n$8\n$8\n$8Supported places:\n$8LEDETCHKO (1), RATTAY (2), RATTAY_WOODS (3), TALMBERG (4), UZHITZ (5)",
"Type to console", "cheat_tp_wc place:1")
function cheat:tp_wc(line)
  local gender = player.soul:GetGender()
  local args = cheat:argsProcess(line, cheat.cheat_tp_wc_args)
  local nplace, nplaceErr = cheat:argsGet(args, 'place')
  
  local places = {}
  places["1"] = "x:1631 y:1447 z:65"
  places["2"] = "x:1950 y:926 z:71"
  places["3"] = "x:2697 y:1742 z:132"
  places["4"] = "x:2221 y:3153 z:131"
  places["5"] = "x:2296 y:3833 z:155"  
  
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

-- ============================================================================
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
