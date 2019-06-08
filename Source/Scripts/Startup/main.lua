--[[
TODO
=====================================================================
-- localize items, perks, skills, buffs
-- spawn enemies/entities
-- dummy quest to grant rep
-- alter Charisma, Noise, Visibility, Speed
-- complete a quest
-- gravity
-- removes fog of war, but also unlocks all on the map? Camp sites, graveyards, caves etc?
-- player speed
-- horse speed
-- max skills, stats

Change Log
=====================================================================
1.29
-- Merged latest defaultProfile.xml.
-- Fixed documentation error on command cheat_set_horse.
-- Released additional version of mod without any key bindings.

1.27/1.28
-- Merged 1.4.1 action map.

1.26
-- The cheat_spawn command now had radius option and can spawn guards.

1.25
-- Removed version section from mod.manifest since it works like shit.

1.24
-- Added cheat_spawn and cheat_spawn_npc.
-- Added required health argument to cheat_damage_all_items.

1.23
-- Fixed startup logging so missing autocheat.txt isn't logged as an error.
-- Added cheat_target_entity command bound to F4.
-- Added cheat_kill_target comand to kill an entity targeted with F4 or the cheat_target_entity command.
-- Added cheat_damage_all_items.

1.22
-- Added support for GOG versions.

1.21
-- Fixed packaging issues causing wrong file to get uploaded to nexus.

1.20
-- Switched mod to use new 1.3 mod structure
-- Mod should now be unzipped into steamapps\common\KingdomComeDeliverance\Mods
-- See https://wiki.nexusmods.com/index.php/Modding_guide_for_KCD

1.19
-- Fixed a bug with autocheat.txt not loading.

1.18
-- Added cheat_exec_file and cheat_exec_delay.

Create Data\exec.txt will following 6 lines:
cheat_exec_delay ms:5000
cheat_eval cheat:logWarn("1")
cheat_exec_delay ms:5000
cheat_eval cheat:logWarn("2")
cheat_exec_delay ms:5000
cheat_eval cheat:logWarn("3")

Run command cheat_exec_file file:Data\exec.txt

1.17
-- Added cheat_set_weather.

1.16
-- Added cheat_kill_npc to kill matching NPCs within a specified radius of the player.

1.15
-- Added cheat_stash to open player's stash.
-- Added max parameter to cheat_teleport_npc_to_loc to limit total number of NPCs teleported.
-- Added max parameter to cheat_teleport_npc_to_player to limit total number of NPCs teleported.
-- Changed cheat_find_npc, cheat_teleport_npc_to_loc, and cheat_teleport_npc_to_player to work with any actor like hare, pig, deer, etc.
-- Added cheat_add_buff_invisible and cheat_remove_buff_invisible

1.14
-- Added cheat_find_npc to display an NPC's location assuming the NPC has been loaded into the game world.
-- Added cheat_teleport_npc_to_loc to teleport one or more NPCs to a specific x,y,z location.
-- Added cheat_teleport_npc_to_player to teleport one or more NPCs to the player's location.
-- Added cheat_teleport_horse to teleport the player's horse to the player's location.

1.13
-- Excluded Always Drunk perk from cheat_add_all_perks
-- Added cheat_loc to get player's location on map
-- Fixed cheat_teleport so it actually works

1.12
-- Added required "exclude" argument to cheat_add_all_perks to control excluding negative, test, and obsolete perks.
-- Added cheat_teleport
-- Added cheat_phys_hover (F1 key)
-- Added cheat_phys_push (F2 key)
-- Added cheat_phys_sprint (F3 key)

1.11
-- Added actionmap with F5 quicksave keybind

1.10
-- Added cheat_remove_all_stolen_items
-- Added cheat_own_all_stolen_items
-- Added cheat_repair_all_items

1.9
-- Added cheat_reveal_map
-- Fixed cheat_set_bow_reticle
-- Added cheat_get_time, cheat_set_time_speed, cheat_set_time_paused

1.8
-- Automatically run cheats when after you load a level. Create file Data\autocheat.txt and put 1 console command per line in the file.
-- cheat_remove_all_buffs - Attempts to remove every buff in the buff database from the player's character.
-- cheat_add_buff_heal - Now restores health, stamina, hunger, and exhuast in addition to bleeding and injuries.
-- cheat_add_buff_immortal - Now calls cheat_add_buff_heal before adding immortal buffs.
-- cheat_remove_all_perks - Attempts to remove every perk in the perk database from the player's character.
-- cheat_add_all_items - Adds all items in the item database to the player inventory which is about 5300 punds of items. Don't worry somehow you can still walk.
-- cheat_add_stat_xp -- Adds XP to the a player's stat like str.
--]]



-- player.actorStats.flatSpeed
-- player type=table, class=Player, methods=yes metamethods=yes
-- player.player type=table methods=no metamethods=yes
-- player.human type=table methods=no metamethods=yes
-- player.actor type=table methods=no metamethods=yes
-- player.soul tyle=table methods=no metamethods=yes

-- XGenAIModule.SendMessageToEntity(player.this.id, 'haste:instruction:tree', "xmlFileName('final/haste/common.xml'), treeName('makePlayerInvisible')")
-- <SendMessageToNPC target="__player" type="instruction:request" values="includeXml(&apos;player.xml&apos;), includeTree(&apos;dropCarriedBody&apos;)" timeType="GameTime" timeoutType="OnProcessed" timeout="-1" answer="" />


System.LogAlways("@@@@@@@@@ cheat mod main.lua called @@@@@@@@")

cheat={}
cheat.versionMajor = 1
cheat.versionMinor = 29
cheat.isInsideIde = NPC_NAI_x == nil
cheat.devHome = "/home/mikeno/FAST/Projects/Cheat"
cheat.commands = {}

function cheat:loadFile(file, fromDisk)
  if not cheat.isInsideIde and not fromDisk then
    Script.ReloadScript("Scripts/" .. file)
    System.LogAlways("$5Loaded file [" .. tostring(file) .. "].")
  else
    local chunk, err = loadfile(cheat.devHome .. "/Source/Scripts/" .. file)
    if not err then
      chunk()
      print("Loaded file [".. file .."].")
    else
      error("Failed to load file ["..file.."]. Error ["..err.."].")
    end
  end
end

function cheat:loadFiles(fromDisk)
  if fromDisk then
    fromDisk = true
  else
    fromDisk = false
  end
  cheat:loadFile("cheat_util.lua", fromDisk)
  cheat:loadFile("cheat_localization.lua", fromDisk)
  cheat:loadFile("cheat_args.lua", fromDisk)
  cheat:loadFile("cheat_debug.lua", fromDisk)
  cheat:loadFile("cheat_stubs.lua", fromDisk)
  cheat:loadFile("cheat_console.lua", fromDisk)
  cheat:loadFile("cheat_core_buffs.lua", fromDisk)
  cheat:loadFile("cheat_core_factions.lua", fromDisk)
  cheat:loadFile("cheat_core_horses.lua", fromDisk)
  cheat:loadFile("cheat_core_items.lua", fromDisk)
  cheat:loadFile("cheat_core_merchants.lua", fromDisk)
  cheat:loadFile("cheat_core_perks.lua", fromDisk)
  cheat:loadFile("cheat_core_physics.lua", fromDisk)
  cheat:loadFile("cheat_core_picking.lua", fromDisk)
  cheat:loadFile("cheat_core_player.lua", fromDisk)
  cheat:loadFile("cheat_core_skills.lua", fromDisk)
  cheat:loadFile("cheat_core_quests.lua", fromDisk)
  cheat:loadFile("cheat_core_map.lua", fromDisk)
  cheat:loadFile("cheat_core_time.lua", fromDisk)
  cheat:loadFile("cheat_core_npc.lua", fromDisk)
  cheat:loadFile("cheat_core_weather.lua", fromDisk)
  cheat:loadFile("cheat_core_exec.lua", fromDisk)
end

function cheat:init()
  cheat:loadFiles(false)
  cheat:logInfo("Cheat %s.%s Loaded", cheat.versionMajor, cheat.versionMinor)
end

function cheat:initOnLevelLoad()
  ActionMapManager.EnableActionMap("cheat", 1)
  cheat:cheat_timer(false)
  cheat:cheat_timer(true)
  cheat:cheat_auto_exec()
  cheat:logInfo("Cheat %s.%s Running", cheat.versionMajor, cheat.versionMinor)
end

if cheat.isInsideIde then
  helpFile = io.open (cheat.devHome .. "/Source/Docs/help.txt", "w")
  helpFile:write("")
  helpFile:flush()
  helpFile:close()

  commandsFile = io.open (cheat.devHome .. "/Source/Docs/commands.txt", "w")
  commandsFile:write("")
  commandsFile:flush()
  commandsFile:close()
end

cheat:init()

if cheat.isInsideIde then
  table.sort(cheat.commands)
  commandsFile = io.open (cheat.devHome .. "/Source/Docs/commands.txt", "a+")
  for i,n in ipairs(cheat.commands) do
    commandsFile:write(n .. "\n")
  end
  commandsFile:flush()
  commandsFile:close()
end
