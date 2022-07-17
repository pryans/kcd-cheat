
cheat.weather = {}
cheat.weather[1] = "cloudless_sunny"
cheat.weather[2] = "semicloudy_clear"
cheat.weather[3] = "cloudy_no_rain"
cheat.weather[4] = "cloudy_frequent_showers"
cheat.weather[5] = "foggy_drizzly"
cheat.weather[6] = "foggy_storm"
cheat.weather[7] = "dream"

function cheat:getWeatherList()
  local list=""
  for i,w in ipairs(cheat.weather) do
      list = list .. "\n$8" .. tostring(i) .. " = " .. w
  end
  return list
end

-- ============================================================================
-- cheat_set_weather
-- ============================================================================
-- EnvironmentModule.BlendTimeOfDay("foggy_storm", 30, true)
cheat.cheat_set_weather_args = {
  id = function(args,name,showHelp) return cheat:argsGetRequiredNumber(args, name, showHelp, "The weather type ID.") end,
  delay = function(args,name,showHelp) return cheat:argsGetOptionalNumber(args, name, 0, showHelp, "The number of hours to delay the transition. Default 0.") end,
}

cheat:createCommand("cheat_set_weather", "cheat:cheat_set_weather(%line)", cheat.cheat_set_weather_args,
  "Sets the weather to the given weather ID." .. cheat:getWeatherList(),
  "Set weather to foggy storm", "cheat_set_weather id:6")
function cheat:cheat_set_weather(line)
  local args = cheat:argsProcess(line, cheat.cheat_set_weather_args)
  local id, idErr = cheat:argsGet(args, 'id')
  local delay, delayErr = cheat:argsGet(args, 'id')
  if not idErr and not delayErr then
    if cheat.weather[id] then
      local transitionTime = delay * 3600 / Calendar.GetWorldTimeRatio()
      local unknown = delay == 0
      EnvironmentModule.BlendTimeOfDay(cheat.weather[id], transitionTime, unknown)
      EnvironmentModule.ForceImmediateWeatherUpdate()
      cheat:logInfo("Set weather to [%s].", cheat.weather[id])
    else
      cheat:logError("Weather ID [%s] does not exist.", tostring(id))
    end
  end
end

-- ============================================================================
-- end
-- ============================================================================
cheat:logDebug("cheat_core_weather.lua loaded")