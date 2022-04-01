cheat={}
cheat.versionMajor = 1
cheat.versionMinor = 39
cheat.devHome = ""
cheat.isCommandLineBuild = false
cheat.commands = {}

if not cheat.isCommandLineBuild then
  System.LogAlways("@@@@@@@@@ cheat mod main.lua called @@@@@@@@")
end

function cheat:loadFile(file, fromDisk)
  if not cheat.isCommandLineBuild and not fromDisk then
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
end

function cheat:init()
  cheat:loadFiles(false)
  cheat:logInfo("Cheat %s.%s Loaded", cheat.versionMajor, cheat.versionMinor)
end

function cheat:initOnLevelLoad()
  ActionMapManager.EnableActionMap("cheat", 1)
  cheat:cheat_timer(false)
  cheat:cheat_timer(true)
  cheat:logInfo("Loading [Scripts/autocheat.lua] from [Mods/Cheat/Data/data.pak].")
  Script.ReloadScript("Scripts/autocheat.lua")
  cheat:logInfo("Cheat %s.%s Running", cheat.versionMajor, cheat.versionMinor)
end

if cheat.isCommandLineBuild then
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

if cheat.isCommandLineBuild then
  table.sort(cheat.commands)
  commandsFile = io.open (cheat.devHome .. "/Source/Docs/commands.txt", "a+")
  for i,n in ipairs(cheat.commands) do
    commandsFile:write(n .. "\n")
  end
  commandsFile:flush()
  commandsFile:close()
end
