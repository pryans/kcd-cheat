-- ============================================================================
-- argument functions
-- ============================================================================
function cheat:argsParseOLD(line)
  -- this method is designed to parse a string of test passed to a console command
  -- some interesting things to note
  -- 1. you can't pass = sign as an arg to a console command, no idea why but it acts a terminator for the passed string
  -- 2. you can't pass multiple arguments, has to be 1 string
  
  cheat:logDebug("parsing args line [" .. line .. "]")
  local args = {}
  for k, v in string.gmatch(line, "[ ]*([^:]+):([^ ]*)") do
    args[k] = v
    cheat:logDebug("parsed key=[" .. k .. "] value=[" .. v .. "]")
  end
  return args
end


function cheat:argsParse(line)
  -- this method is designed to parse a string of test passed to a console command
  -- some interesting things to note
  -- 1. you can't pass = sign as an arg to a console command, no idea why but it acts a terminator for the passed string
  -- 2. you can't pass multiple arguments, has to be 1 string
  
  cheat:logDebug("parsing args line [" .. tostring(line) .. "]")
  local args = {}
  local key = nil
  
  if not line then
    return args
  end
  
  for word in string.gmatch(string.gsub(line, ":", ": "), "%S+") do
    if cheat:endsWith(word, ":") then
      if key then
        cheat:logDebug("parsed key=[%s] value=[%s]", key, args[key])
      end
      key = string.sub(word, 0, string.len(word) - 1)
      args[key] = nil
    elseif key then
      if args[key] == nil then
        args[key] = word
      else
        args[key] = args[key] .. " " .. word
      end
    else
      -- no open key and read a token that isn not a key
      -- user syntax error
      break
    end
  end
  return args
end

function cheat:argsProcess(line, cmdArgsSet)
  local results = {}
  if cmdArgsSet then
    local args = cheat:argsParse(line)
    if args then
      for key,val in pairs(cmdArgsSet) do
        local value, valueErr = val(args, key, false)
        
        local result = {}
        result.value = value
        result.valueErr = valueErr
        
        results[key] = result
      end
    end
  end
  return results
end

function cheat:argsGet(args, name)
  return args[name].value, args[name].valueErr
end

function cheat:argsGetRequired(args, argName, showHelp, help)
  if showHelp then
    return "($4required$5) " .. help
  end
  
  local returnValue = nil
  local returnErr = false
  local argValue = args[argName]
  if not cheat:isBlank(argValue) then
    returnValue = argValue
    cheat:logDebug("Read required argument [" .. argName .. "] with value [" .. tostring(argValue) .. "].")
  else
    cheat:logError("Missing required argument [" .. argName .. "].")
    returnErr = true
  end
  return returnValue, returnErr
end

function cheat:argsGetRequiredBoolean(args, argName, showHelp, help)
  if showHelp then
    return "($4required boolean$5) " .. help
  end
  
  local returnValue = nil
  local returnErr = false
  local argValue = args[argName]
  if not cheat:isBlank(argValue) then
    if cheat:isBoolean(argValue) then
      returnValue = cheat:toBoolean(argValue)
      cheat:logDebug("Read required argument [" .. argName .. "] with value [" .. tostring(returnValue) .. "].")
    else
      cheat:logError("Value for argument [" .. argName .. "] is not a boolean.")
      returnErr = true
    end
  else
    cheat:logError("Missing required argument [" .. argName .. "].")
    returnErr = true
  end
  return returnValue, returnErr
end

function cheat:argsGetRequiredNumber(args, argName, showHelp, help)
  if showHelp then
    return "($4required number$5) " .. help
  end
  
  local returnValue = nil
  local returnErr = false
  local argValue = args[argName]
  if not cheat:isBlank(argValue) then
    if cheat:isNumber(argValue) then
      returnValue = tonumber(argValue)
      cheat:logDebug("Read required argument [%s] with value [%s].", tostring(argName), tostring(returnValue))
    else
      cheat:logError("Value for argument [%s] is not a number.", tostring(argName))
      returnErr = true
    end
  else
    cheat:logError("Missing required argument [%s].", tostring(argName))
    returnErr = true
  end
  return returnValue, returnErr
end

function cheat:argsGetOptional(args, argName, defaultValue, showHelp, help)
  if showHelp then
    return "($3optional$5) " .. help
  end
  
  local returnValue = nil
  local returnErr = false
  local argValue = args[argName]
  if not cheat:isBlank(argValue) then
    returnValue = argValue
    cheat:logDebug("Read optional argument [%s] with value [%s].", tostring(argName), tostring(argValue))
  else
    cheat:logDebug("Using default value [%s] for optional argument [%s].", tostring(defaultValue), tostring(argName))
    returnValue = defaultValue
  end
  return returnValue, returnErr
end

function cheat:argsGetOptionalBoolean(args, argName, defaultValue, showHelp, help)
  if showHelp then
    return "($3optional boolean$5) " .. help
  end
  
  local returnValue = nil
  local returnErr = false
  local argValue = args[argName]
  if not cheat:isBlank(argValue) then
    if cheat:isBoolean(argValue) then
      returnValue = cheat:toBoolean(argValue)
      cheat:logDebug("Read optional argument [" .. argName .. "] with value [" .. tostring(returnValue) .. "].")
    else
      cheat:logError("Value [" .. tostring(argValue) .. "] for argument [" .. argName .. "] is not a boolean.")
      returnErr = true
    end
  else
    cheat:logDebug("Using default value [" .. tostring(defaultValue) .. "] for optional argument [" .. argName .. "].")
    returnValue = defaultValue
  end
  return returnValue, returnErr
end

function cheat:argsGetOptionalNumber(args, argName, defaultValue, showHelp, help)
  if showHelp then
    return "($3optional number$5) " .. help
  end
  
  local returnValue = nil
  local returnErr = false
  local argValue = args[argName]
  if not cheat:isBlank(argValue) then
    if cheat:isNumber(argValue) then
      returnValue = tonumber(argValue)
      cheat:logDebug("Read optional argument [" .. argName .. "] with value [" .. tostring(returnValue) .. "].")
    else
      cheat:logError("Value [" .. tostring(argValue) .. "] for argument [" .. argName .. "] is not a number.")
      returnErr = true
    end
  else
    cheat:logDebug("Using default value [" .. tostring(defaultValue) .. "] for optional argument [" .. argName .. "].")
    returnValue = defaultValue
  end
  return returnValue, returnErr
end

function cheat:runTests()
  cheat:beginTest("cheat_args.lua")
  local testval, testerr = nil
  
  local argstest = {}
  argstest["a_string"] = "the string"
  argstest["a_number"] = 73
  argstest["a_string_number"] = "73"
  argstest["a_false_boolean"] = false
  argstest["a_string_false_boolean"] = false
  argstest["a_true_boolean"] = true
  argstest["a_string_true_boolean"] = true
  argstest["empty_token"] = ""
  argstest["nil_token"] = nil
  
  -- required
  testval, testerr = cheat:argsGetRequired(argstest, "a_string")
  cheat:testAssert("didn't get required string", testval == "the string" and not testerr)
  
  testval, testerr = cheat:argsGetRequiredNumber(argstest, "a_number")
  cheat:testAssert("didn't get required number", testval == 73 and not testerr)
  
  testval, testerr = cheat:argsGetRequiredBoolean(argstest, "a_false_boolean")
  cheat:testAssert("didn't get required false boolean", testval == false and not testerr)
  
  testval, testerr = cheat:argsGetRequiredBoolean(argstest, "a_true_boolean")
  cheat:testAssert("didn't get required true boolean", testval == true and not testerr)
  
  testval, testerr = cheat:argsGetRequired(argstest, "does not exist")
  cheat:testAssert("incorrectly got required string", testval == nil and testerr == true)
  
  testval, testerr = cheat:argsGetRequiredNumber(argstest, "a_false_boolean")
  cheat:testAssert("incorrectly got required boolean", testval == nil and testerr == true)
  
  testval, testerr = cheat:argsGetRequiredBoolean(argstest, "a_number")
  cheat:testAssert("incorrectly got required number", testval == nil and testerr == true)
  
  -- optional
  testval, testerr = cheat:argsGetOptional(argstest, "a_string", "the 2nd string")
  cheat:testAssert("didn't get optional string", testval == "the string" and not testerr)
  
  testval, testerr = cheat:argsGetOptionalNumber(argstest, "a_number", 37)
  cheat:testAssert("didn't get optional number", testval == 73 and not testerr)
  
  testval, testerr = cheat:argsGetOptionalNumber(argstest, "a_string_number", 37)
  cheat:testAssert("didn't get optional string number", testval == 73 and not testerr)
  
  testval, testerr = cheat:argsGetOptionalBoolean(argstest, "a_false_boolean", true)
  cheat:testAssert("didn't get optional false boolean", testval == false and not testerr)
  
  testval, testerr = cheat:argsGetOptionalBoolean(argstest, "a_string_false_boolean", true)
  cheat:testAssert("didn't get optional string false boolean", testval == false and not testerr)
  
  testval, testerr = cheat:argsGetOptionalBoolean(argstest, "a_true_boolean", false)
  cheat:testAssert("didn't get optional true boolean", testval == true and not testerr)
  
  testval, testerr = cheat:argsGetOptionalBoolean(argstest, "a_string_true_boolean", false)
  cheat:testAssert("didn't get optional string true boolean", testval == true and not testerr)
  
  testval, testerr = cheat:argsGetOptional(argstest, "does not exist", "the 2nd string")
  cheat:testAssert("didn't get optional default string", testval == "the 2nd string" and testerr == false)
  
  testval, testerr = cheat:argsGetOptionalNumber(argstest, "does not exist", 97)
  cheat:testAssert("didn't get optional default number", testval == 97 and testerr == false)
  
  testval, testerr = cheat:argsGetOptionalBoolean(argstest, "does not exist", true)
  cheat:testAssert("didn't get optional default boolean", testval == true and testerr == false)
  
  testval, testerr = cheat:argsGetOptionalNumber(argstest, "a_false_boolean", 79)
  cheat:testAssert("incorrectly got optional boolean", testval == nil and testerr == true)
  
  testval, testerr = cheat:argsGetOptionalBoolean(argstest, "a_number", false)
  cheat:testAssert("incorrectly got optional number", testval == nil and testerr == true)
  
  testval, testerr = cheat:argsGetOptional(argstest, "empty_token", nil)
  cheat:testAssert("didn't get optional empty token", testval == nil and testerr == false)
  
  testval, testerr = cheat:argsGetOptional(argstest, "nil_token", nil)
  cheat:testAssert("didn't get optional nil token", testval == nil and testerr == false)
  
  
  local argsSet = {
    token=function(args,name,showHelp) return cheat:argsGetOptional(args, name, nil, showHelp, "token help") end
  }
  
  local args = cheat:argsProcess("token:test123", argsSet)
  local testToken, testTokenErr = cheat:argsGet(args, "token")
  cheat:testAssert("didn't get correct test token value got: " .. tostring(testToken), testToken == "test123" and testTokenErr == false)
  
  
  testval = cheat:argsParse("x:1")
  cheat:testAssert("didn't parse x:1", testval["x"] == "1")
  
  testval = cheat:argsParse("x:1 y:2")
  cheat:testAssert("didn't parse x:1 y:2", testval["x"] == "1" and testval["y"] == "2")
  
  testval = cheat:argsParse("x:foo y:bar")
  cheat:testAssert("didn't parse x:foo y:bar", testval["x"] == "foo" and testval["y"] == "bar")
  
  testval = cheat:argsParse("x:foo bar y:hellow world")
  cheat:testAssert("didn't parse x:foo bar y:hellow world", testval["x"] == "foo bar" and testval["y"] == "hellow world")
  
  testval = cheat:argsParse(" x: foo bar   y: hellow world  ")
  cheat:testAssert("didn't parse x: foo bar y: hellow world", testval["x"] == "foo bar" and testval["y"] == "hellow world")
  
  
  local test_args = {
    file=function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "The file to execute.") end
  }
  local testargs = cheat:argsProcess("", test_args)
  local testfilename, testfilenameErr = cheat:argsGet(testargs, 'file', nil)
  cheat:testAssert("didn't return missing file argument error", testfilename == nil and testfilenameErr == true)
  
  
  local test_args = {
    file=function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "The file to execute.") end
  }
  local testargs = cheat:argsProcess("asdf", test_args)
  local testfilename, testfilenameErr = cheat:argsGet(testargs, 'file', nil)
  cheat:testAssert("didn't return missing file argument error on no colon input", testfilename == nil and testfilenameErr == true)
  
  
  local test_args = {
    file=function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "The file to execute.") end
  }
  local testargs = cheat:argsProcess(nil, test_args)
  local testfilename, testfilenameErr = cheat:argsGet(testargs, 'file', nil)
  cheat:testAssert("didn't return missing file argument error on nil input", testfilename == nil and testfilenameErr == true)
  
  cheat:endTest()
end

if cheat:testEnabled() then
  cheat:runTests()
end

-- ============================================================================
-- end
-- ============================================================================
cheat:logDebug("cheat_args.lua loaded")
