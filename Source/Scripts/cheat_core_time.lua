
--[[
[INFO] SetWorldTimeRatio
[INFO] GetWorldHourOfDay
[INFO] SetWorldTimePaused
[INFO] GetWorldDay
[INFO] GetWorldTime
[INFO] GetWorldDayOfWeek
[INFO] GetWorldTimeRatio
[INFO] IsWorldTimePaused
[INFO] SetWorldTime

[INFO] IsNightTimeOfDay
[INFO] SetFakeTimeOfDay
[INFO] UnfakeTimeOfDay
[INFO] IsFakedTimeOfDay

[INFO] GetGameTime
]]--

-- ============================================================================
-- cheat_set_time
-- ============================================================================
cheat:createCommand("cheat_get_time", "cheat:cheat_get_time()", nil,
  "Logs information about game time.",
  "Get game time", "cheat_get_time")
function cheat:cheat_get_time()
  local gameTimeInSeconds=Calendar.GetWorldTime()
  local days = math.floor(gameTimeInSeconds / 86400)
  local hours = (gameTimeInSeconds / 3600) % 24
  local minutes = (gameTimeInSeconds / 60) % 60
  local seconds = gameTimeInSeconds % 60
	local time = string.format("days=%.3d time=%.2d:%.2d:%.2d speed=%d paused=%s",
    days, hours, minutes, seconds, Calendar.GetWorldTimeRatio(), tostring(Calendar.IsWorldTimePaused()))
  cheat:logInfo("Current game time: %s", time)
end

-- ============================================================================
-- cheat_set_time
-- ============================================================================
cheat.cheat_set_time_args = {
  hours=function(args,name,showHelp) return cheat:argsGetRequiredNumber(args, name, showHelp, "The number of hours.") end,
}
cheat:createCommand("cheat_set_time", "cheat:cheat_set_time(%line)", cheat.cheat_set_time_args,
  "Moved time forward the given number of hours.",
  "Move 5 hours forward", "cheat_set_time hours:5")
function cheat:cheat_set_time(line)
  local args = cheat:argsProcess(line, cheat.cheat_set_time_args)
  local hours, hoursErr = cheat:argsGet(args, 'hours')
  if not hoursErr then
    cheat:cheat_get_time()
    Calendar.SetWorldTime(Calendar.GetWorldTime() + (hours * 3600))
    XGenAIModule.SendMessageToEntity( player.this.id, "timekeeper:recalculate", "" );
    cheat:logInfo("Time moved forward [%s] hours.", tostring(hours))
    cheat:cheat_get_time()
    return true
  end
  return false
end

-- ============================================================================
-- cheat_set_time_speed
-- ============================================================================
cheat.cheat_set_time_speed_args = {
  ratio=function(args,name,showHelp) return cheat:argsGetRequiredNumber(args, name, showHelp, "The ratio between real time and game time. Default 15.") end,
}
cheat:createCommand("cheat_set_time_speed", "cheat:cheat_set_time_speed(%line)", cheat.cheat_set_time_speed_args,
  "Set the game time speed as a ratio between real time and game time.\n$8A high ratio, like 1000, is faster. Default is 15. 0 will pause time.",
  "Speed up game time", "cheat_set_time_speed ratio:1000")
function cheat:cheat_set_time_speed(line)
  local args = cheat:argsProcess(line, cheat.cheat_set_time_speed_args)
  local ratio, ratioErr = cheat:argsGet(args, 'ratio')
  if not ratioErr then
    Calendar.SetWorldTimeRatio(ratio)
    if ratio ~= 0 then
      if Calendar.IsWorldTimePaused() then
        Calendar.SetWorldTimePaused(false)
      end
      if Calendar.IsFakedTimeOfDay() then
        Calendar.UnfakeTimeOfDay()
      end
    else
      if not Calendar.IsWorldTimePaused() then
        Calendar.SetWorldTimePaused(true)
      end
      if not Calendar.IsFakedTimeOfDay() then
        Calendar.SetFakeTimeOfDay(Calendar.GetWorldHourOfDay())
      end
    end
    cheat:logInfo("Set game speed to [%s].", tostring(ratio))
    cheat:cheat_get_time()
    return true
  end
  return false
end

-- ============================================================================
-- cheat_set_time_paused
-- ============================================================================
--cheat.cheat_set_time_paused_args = {
--  enable=function(args,name,showHelp) return cheat:argsGetRequiredBoolean(args, name, showHelp, "true=paused, false=unpaused") end,
--}
--cheat:createCommand("cheat_set_time_paused", "cheat:cheat_set_time_paused(%line)", cheat.cheat_set_time_paused_args,
--  "Pauses or unpaused the game's calendar(date/time) system.",
--  "Stop time", "cheat_set_time_paused enable:true",
--  "Start time", "cheat_set_time_paused enable:false")
--function cheat:cheat_set_time_paused(line)
--  local args = cheat:argsProcess(line, cheat.cheat_set_time_paused_args)
--  local enable, enableErr = cheat:argsGet(args, 'enable')
--  if not enableErr then
--    if enable then
--      if not Calendar.IsFakedTimeOfDay() then
--        Calendar.SetFakeTimeOfDay(Calendar.GetWorldHourOfDay())
--      end
--    else
--      if Calendar.IsFakedTimeOfDay() then
--        Calendar.UnfakeTimeOfDay()
--      end
--    end
--    Calendar.SetWorldTimePaused(enable)
--    cheat:logInfo("Set game time paused to [%s].", tostring(enable))
--    cheat:cheat_get_time()
--    return true
--  end
--  return false
--end

-- ============================================================================
-- end
-- ============================================================================
cheat:logDebug("cheat_core_time.lua loaded")
