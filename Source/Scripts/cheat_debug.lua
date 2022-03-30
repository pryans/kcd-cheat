-- ============================================================================
-- debug functions
-- ============================================================================
--[[
function printTable(ent, entName, indent, ismeta)
  local prefix = string.rep("  ", indent) .. entName
  if ismeta then
    prefix = prefix .. ":"
  else
    prefix = prefix .. "."
  end
  
  cheat:logDebug(type(ent)
  
  for k,v in pairs(ent) do
    if k ~= "__index" and k ~= "__this" then
      if type(v) == "function" then
        local funcval = tostring(v())
        cheat:logDebug(prefix.. k .. "=" .. funcval)
      elseif type(v) == "table" then
        printTable(v,prefix .. k, indent, false)
      else
        cheat:logDebug(prefix.. k.."="..tostring(v))
      end
    end
  end
  
  local mt = getmetatable(ent)
  if mt then
    printTable(mt,entName, indent, true)
  end
end
]]

function cheat:print_db_table(tableName, filter, debug)
  if not Database.LoadTable(tableName) then
    cheat:logError("Unable to load table [%s].", tostring(tableName))
    return
  end
  
  local tableInfo = Database.GetTableInfo(tableName)
  if not tableInfo then
    cheat:logError("Table [%s] not found.", tostring(tableName))
    return
  end
  
  if tableInfo.LineCount == 0 then
    cheat:logInfo("Table [%s] is empty.", tostring(tableName))
    return
  end
  
  local rows = tableInfo.LineCount - 1
  
  for i=0,rows do
    local tableline = Database.GetTableLine(tableName, i)
    if tableline then
      local displayLine = ""
      for key,value in pairs(tableline) do
        if debug then
          cheat:logDebug("Pair key=[%s] value=[%s]." ,tostring(key), tostring(value))
        end
        
        if not cheat:isBlank(filter) then
          if string.find(string.upper(key), string.upper(filter)) or string.find(string.upper(tostring(value)), string.upper(filter)) then
            displayLine = displayLine .. " " .. key .. "=" .. tostring(value)
          end
        else
          displayLine = displayLine .. " " .. key .. "=" .. tostring(value)
        end
      end
      
      if not cheat:isBlank(displayLine) then
        cheat:logInfo(displayLine)
      end
    else
      cheat:logError("Read nil table line (this is a bug).")
    end
  end
end

function cheat:print_methods(object, filter)
  for key,value in pairs(object) do
    if not cheat:isBlank(filter) then
      if string.find(cheat:toUpper(key), cheat:toUpper(filter), 1, true) then
        cheat:logInfo(key)
      end
    else
      cheat:logInfo(key)
    end
  end
end

function cheat:print_all_tables(object, tableName, showMethods)
  if not object then
    object = _G
  end
  
  if not cheat:isBlank(tableName) then
    tableName = toUpper(tableName)
  else
    tableName = nil
  end
  
  if showMethods ~= true and showMethods ~= false then
    showMethods = false
  end
  
  for key,value in pairs(object) do
    if not tableName or (tableName and tableName ~= toUpper(key)) then
      local getKeyType = loadstring("return type(" .. key .. ")")
      if getKeyType() == "table" then
        cheat:logWarn("TABLE: " .. key)
        if showMethods then
          local getTable = loadstring("return " .. key)
          cheat:print_methods(getTable())
        end
      end
    end
  end
end

function cheat:print_all_functions(object)
  if not object then
    object = _G
  end
  
  for key,value in pairs(object) do
    local getKeyType = loadstring("return type(" .. key .. ")")
    if getKeyType() == "function" then
      cheat:logWarn("BEGIN FUNC:" .. key)
      local func = loadstring("print_method_args(" .. key .. ")")
      func()
    end
  end
end

function cheat:tprint(tbl, indent)
  if not indent then
    indent = 0
  end
  for k, v in pairs(tbl) do
    local formatting = string.rep("  ", indent) .. tostring(k) .. ": "
    if type(v) == "table" then
      cheat:logDebug(formatting)
      cheat:tprint(v, indent+1)
    else
      cheat:logDebug(formatting .. tostring(v))
    end
  end
end

function cheat:setup_hook()
  debug.sethook(function(event, line)
    cheat:logWarn("event="..event.." line="..tostring(line))
    cheat:tprint(debug.getinfo(2, "flLnSu"))
    if event == "call" then
      local i = 1
      while true do
        local name, value = debug.getlocal(2, i)
        if name or value then
          cheat:logDebug("    local name="..name.." value="..tostring(value))
          i = i + 1
        else
          break
        end
      end
    end
  end, "crl")
  cheat:logDebug("hook set")
end

-- print_method_args( function()
function cheat:print_method_args(f)
  cheat:logDebug("begin - print_method_args")
  
  local calltracer = function(event, line)
    cheat:logWarn("event="..event.." line="..tostring(line))
    cheat:tprint(debug.getinfo(2, "flLnSu"))
    if event == "call" then
      local i = 1
      while true do
        local name, value = debug.getlocal(2, i)
        if name or value then
          cheat:logDebug("    local name="..name.." value="..tostring(value))
          i = i + 1
        else
          break
        end
      end
    end
  end
  cheat:logDebug("tracter function created")
  
    debug.sethook(calltracer, "crl")
  cheat:logDebug("debug hook set")
	
  f()
  
  debug.sethook()
  cheat:logDebug("end - print_method_args")
end

-- ============================================================================
-- end
-- ============================================================================
cheat:logDebug("cheat_debug.lua loaded")
