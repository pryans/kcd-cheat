-- ============================================================================
-- table functions
-- ============================================================================
function cheat:packTable(...)
  return { n = select("#", ...), ... }
end

-- ============================================================================
-- string functions
-- ============================================================================
function cheat:isBlank(value)
  return value == nil or value == ''
end

function cheat:toUpper(value)
  if not cheat:isBlank(value) then
    -- string.upper fails if passed nil
    return string.upper(value)
  else
    return value
  end
end

function cheat:toLower(value)
  if not cheat:isBlank(value) then
    -- string.lower fails if passed nil
    return string.lower(value)
  else
    return value
  end
end

function cheat:endsWith(String,End)
  return End=='' or string.sub(String,-string.len(End))==End
end

-- ============================================================================
-- math functions
-- ============================================================================
function cheat:min(x,y)
    if x < y then
      return x
    else
      return y
    end
end

-- ============================================================================
-- type functions
-- ============================================================================
function cheat:isBoolean(value)
  if type(value) ~= "boolean" then
    local testValue = cheat:toUpper(tostring(value))
    if testValue == "TRUE" or testValue == "FALSE" then
      return true
    else
      return false
    end
  else
    return true
  end
end

function cheat:toBoolean(value)
  if type(value) ~= "boolean" then
    local testValue = cheat:toUpper(tostring(value))
    if testValue == "TRUE" then
      return true
    elseif testValue == "FALSE" then
      return false
    else
      return nil
    end
  else
    return value
  end
end

function cheat:isNumber(value)
  local testValue = tonumber(value)
  if testValue then
    return true
  else
    return false
  end
end

-- ============================================================================
-- logging functions
-- ============================================================================
cheat.g_cheat_log_level_debug=3
cheat.g_cheat_log_level_info=2
cheat.g_cheat_log_level_warn=1
cheat.g_cheat_log_level_error=0
cheat.g_cheat_log_level_off=-1
cheat.g_cheat_last_log_level=nil
cheat.g_cheat_log_level=cheat.g_cheat_log_level_info

function cheat:logSetLevel(level)
  cheat.g_cheat_log_level=level
end

function cheat:logOff()
  if cheat.g_cheat_log_level ~= cheat.g_cheat_log_level_off then
    cheat.g_cheat_last_log_level = cheat.g_cheat_log_level
    cheat.g_cheat_log_level = cheat.g_cheat_log_level_off
  end
end

function cheat:logOn()
  if cheat.g_cheat_log_level == cheat.g_cheat_log_level_off then
    cheat.g_cheat_log_level = cheat.g_cheat_last_log_level
  end
end

function cheat:log(value)
  if cheat.isCommandLineBuild == false then
    System.LogAlways(value)
  else
    print(value)
  end
end

function cheat:logIsDebugEnabled()
  return cheat.g_cheat_log_level >= cheat.g_cheat_log_level_debug
end

function cheat:logDebug(message, ...)
  if cheat:logIsDebugEnabled() then
    cheat:log(string.format("$3[DEBUG] ".. message, ...))
  end
end

function cheat:logIsInfoEnabled()
  return cheat.g_cheat_log_level >= cheat.g_cheat_log_level_info
end

function cheat:logInfo(message, ...)
  if cheat:logIsInfoEnabled() then
    cheat:log(string.format("$5[INFO] ".. message, ...))
  end
end

function cheat:logIsWarnEnabled()
  return cheat.g_cheat_log_level >= cheat.g_cheat_log_level_warn
end

function cheat:logWarn(message, ...)
  if cheat:logIsWarnEnabled() then
    cheat:log(string.format("$6[WARN] ".. message, ...))
  end
end

function cheat:logIsErrorEnabled()
  return cheat.g_cheat_log_level >= cheat.g_cheat_log_level_error
end

function cheat:logError(message, ...)
  if cheat:logIsErrorEnabled() then
    cheat:log(string.format("$4[ERROR] ".. message, ...))
  end
end

-- ============================================================================
-- testing functions
-- ============================================================================
cheat.g_cheat_test_fail = 0
cheat.g_cheat_test_pass = 0
cheat.g_cheat_test_name = nil

function cheat:testEnabled()
  return cheat:logIsDebugEnabled() or cheat.isCommandLineBuild
end

function cheat:beginTest(name)
  cheat:log(string.format("$4[TEST] Starting test set [%s].", tostring(name)))
  cheat:logOff()
  cheat.g_cheat_test_fail = 0
  cheat.g_cheat_test_pass = 0
  cheat.g_cheat_test_name = name
end

function cheat:endTest()
  cheat:logOn()
  if cheat.g_cheat_test_fail > 0 then
    cheat:log(string.format("$4[TEST] Test set [%s] failed with fail=[%s] pass[%s].", tostring(cheat.g_cheat_test_name), tostring(cheat.g_cheat_test_fail), tostring(cheat.g_cheat_test_pass)))
  else
    cheat:log(string.format("$4[TEST] Test set [%s] passed with fail=[%s] pass[%s].",tostring(cheat.g_cheat_test_name), tostring(cheat.g_cheat_test_fail), tostring(cheat.g_cheat_test_pass)))
  end
end

function cheat:testAssert(name, value)
  if not value then
    cheat:log(string.format("$4[FAIL] %s", tostring(name)))
    cheat.g_cheat_test_fail = cheat.g_cheat_test_fail + 1
  else
    cheat:log(string.format("$3[PASS] %s", tostring(name)))
    cheat.g_cheat_test_pass = cheat.g_cheat_test_pass + 1
  end
end

-- ============================================================================
-- end
-- ============================================================================
cheat:logDebug("cheat_util.lua loaded")
