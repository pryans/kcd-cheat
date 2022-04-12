-- cheat_eval return type(XGenAIModule.GetEntityByWUID( player.inventory:GetInventoryTable()[5] ))
-- ItemManager.GetItemUIName
-- ItemManager.GetItem(player.inventory:GetInventoryTable()[5])
-- cheat_eval return tostring(player.inventory:GetInventoryTable()[5])

-- cheat_eval cheat:print_methods( ItemManager.GetItem(player.inventory:GetInventoryTable()[5]) )
-- cheat_eval return ItemManager.GetItemUIName( ItemManager.GetItem(player.inventory:GetInventoryTable()[5]).class )
-- cheat_eval return ItemManager.GetItem(player.inventory:GetInventoryTable()[5]).health=1
-- health (float)
-- amount (int)
-- id (user data)
-- class (wuid)
-- entity (o ?)

-- cheat_eval return ItemManager.GetItemOwner(player.inventory:GetInventoryTable()[0])
-- returns userdata
-- cheat_eval return ItemManager.GetItemOwner(ItemManager.GetItem(player.inventory:GetInventoryTable()[0]))
-- cheat_eval return XGenAIModule.GetEntityByWUID(ItemManager.GetItemOwner(player.inventory:GetInventoryTable()[5]))


--player.actor:UnequipInventoryItem(weapon)
--player.actor:EquipInventoryItem(weapon)
--player.human:GetItemInHand(0)

function cheat:recreateitems(mode, miscValue)
  for i,userdata in pairs(player.inventory:GetInventoryTable()) do
    local item = ItemManager.GetItem(userdata)
    local itemAmount = item.amount
    local itemHealth = item.health
    local itemCategoryId = cheat:get_item_category_id(tostring(item.class))
    local itemUIName = ItemManager.GetItemUIName(item.class)
    local itemName = ItemManager.GetItemName(item.class)
    local itemOwner =  tostring(ItemManager.GetItemOwner(item.id))
    local playerDataM = "userdata: 0500000000000A53"
    local playerDataF = "userdata: 05000000000000F5"
    local shouldDelete = false
    local shouldRecreate = false
    local newItemHealth = 1
    
    if mode == "repairall" then
      local itemHealth = item.health
      local categoryidArray = {0, 1, 2, 3, 4, 5, 9, 13, 14, 16, 27}
      for i=1,table.getn(categoryidArray) do
        if categoryidArray[i] == itemCategoryId and itemHealth ~= 1 then
          shouldDelete = true
          shouldRecreate = true
        end
      end
    end
    
    if mode == "damageall" then
      local categoryidArray = {0, 1, 2, 3, 4, 5, 13, 14, 16, 27}
      for i=1,table.getn(categoryidArray) do
        if categoryidArray[i] == itemCategoryId then
          cheat:logDebug("dmgall [%s] [%s] [%s]", itemUIName, tostring(item.class), tostring(itemHealth))
          shouldDelete = true
          shouldRecreate = true
          newItemHealth = miscValue
        end
      end
    end
    
    if mode == "removestolen" then
      local categoryidArray = {0, 1, 2, 3, 4, 5, 8, 9, 13, 14, 15, 16, 27}
      for i=1,table.getn(categoryidArray) do
        if categoryidArray[i] == itemCategoryId and itemOwner ~= playerDataM and itemOwner ~= playerDataF then
          --cheat:logDebug("owner [%s]", itemOwner)
          shouldDelete = true
          shouldRecreate = false
        end
      end
    end
    
    if mode == "ownstolen" then
      local categoryidArray = {0, 1, 2, 3, 4, 5, 8, 9, 13, 14, 15, 16, 27}
      for i=1,table.getn(categoryidArray) do
        if categoryidArray[i] == itemCategoryId and itemOwner ~= playerData and itemOwner ~= playerDataF then
          --cheat:logDebug("owner [%s]", itemOwner)
          shouldDelete = true
          shouldRecreate = true
        end
      end
    end
    
    if shouldDelete then
      cheat:logDebug("recreateitem delete [%s] [%s]", itemUIName, tostring(item.class))
      for i=1,itemAmount do
        player.inventory:RemoveItem(item.id, 1)
      end
    end
    
    if shouldRecreate then
      cheat:logDebug("recreateitem create [%s] [%s] [%s]", itemUIName, tostring(item.class), tostring(newItemHealth))
      for i=1,itemAmount do
        local newitem = ItemManager.CreateItem(item.class, newItemHealth, 1)
        player.inventory:AddItem(newitem)
      end
    end
  end
end

-- ============================================================================
-- find_item
-- ============================================================================
function cheat:find_item(searchKey, returnAll)
  local tableName = "player_item"
  Database.LoadTable(tableName)
  local tableInfo = Database.GetTableInfo(tableName)
  local rows = tableInfo.LineCount - 1
  local searchKeyUpper = cheat:toUpper(searchKey)
  local item_id = nil
  local item_name = nil
  local items = {}
  
  for i=0,rows do
    local rowInfo = Database.GetTableLine(tableName, i)
    local found = false
    
    if not cheat:isBlank(searchKeyUpper) then
      if cheat:toUpper(rowInfo.item_id) == searchKeyUpper then
        found = true
      end
      
      if string.find(cheat:toUpper(rowInfo.ui_name), searchKeyUpper, 1, true) then
        found = true
      end
    else
      found = true
    end
    
    if found then
      item_id = rowInfo.item_id
      item_name = rowInfo.ui_name
      if returnAll then
        local item={}
        item.item_id = item_id
        item.item_name = item_name
        items[item_id] = item
      end
      cheat:logInfo("Found item [%s] with id [%s].", tostring(item_name), tostring(item_id))
    end
  end
  
  if returnAll then
    cheat:logDebug("Returning [%s] items.", tostring(#items))
    return items
  else
    cheat:logDebug("Returning item [%s] with id [%s].", tostring(item_name), tostring(item_id))
    return item_id, item_name
  end
end

-- ============================================================================
-- find_item
-- ============================================================================
function cheat:get_item_category_id(searchKey)
  local tableName = "item"
  Database.LoadTable(tableName)
  local tableInfo = Database.GetTableInfo(tableName)
  local rows = tableInfo.LineCount - 1
  local searchKeyUpper = cheat:toUpper(searchKey)
  
  for i=0,rows do
    local rowInfo = Database.GetTableLine(tableName, i)
    if cheat:toUpper(rowInfo.item_id) == searchKeyUpper then
      return rowInfo.item_category_id
    end
  end
end

-- ============================================================================
-- cheat_find_items
-- ============================================================================
cheat.cheat_find_items_args = {
  token = function(args,name,showHelp) return cheat:argsGetOptional(args, name, nil, showHelp, "All or part of a the item's name. Leave empty to list all items.") end
}

cheat:createCommand("cheat_find_items", "cheat:cheat_find_items(%line)", cheat.cheat_find_items_args,
  "Finds all of the items that match the given token.",
  "Show all items", "cheat_find_items token:",
  "Show all items with 'arrow' in their name", "cheat_find_items token:arrow")
function cheat:cheat_find_items(line)
  local args = cheat:argsProcess(line, cheat.cheat_find_items_args)
  local token, tokenErr = cheat:argsGet(args, 'token', nil)
  if not tokenErr then
    cheat:find_item(token)
    return true
  end
  return false
end

-- ============================================================================
-- cheat_add_item
-- ============================================================================
cheat.cheat_add_item_args = {
  id = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "The item ID or all or part of a the item's name. Uses last match from cheat_find_items.") end,
  amount = function(args,name,showHelp) return cheat:argsGetOptionalNumber(args, name, 1, showHelp, "The number of items to add. Default 1.") end,
  health = function(args,name,showHelp) return cheat:argsGetOptionalNumber(args, name, 100, showHelp, "The condition of the item added. Default 100.") end
}

cheat:createCommand("cheat_add_item", "cheat:cheat_add_item(%line)", cheat.cheat_add_item_args,
  "Adds an item to the player's inventory.",
  "Adds the last item with 'bow' in its name", "cheat_add_item id:bow",
  "Adds the item ui_nm_arrow_hunter by ID", "cheat_add_item id:802507e9-d620-47b5-ae66-08fcc314e26a",
  "Adds 10 items ui_nm_arrow_hunter by fullname with 50 condition", "cheat_add_item id:ui_nm_arrow_hunter amount:10 health:50")
function cheat:cheat_add_item(line)
  local args = cheat:argsProcess(line, cheat.cheat_add_item_args)
  local id, idErr = cheat:argsGet(args, 'id')
  local amount, amountErr = cheat:argsGet(args, 'amount', 1)
  local health, healthErr = cheat:argsGet(args, 'health', 100)
  
  if idErr or amountErr or healthErr then
    return
  end
  
  if amount < 0 then
    amount = 1
    cheat:logWarn("Setting amount to 1.")
  end
  
  if health < 0 then
    health = 1
    cheat:logWarn("Setting health to 1.")
  end
  
  local item_id, item_name = cheat:find_item(id)
  if not cheat:isBlank(item_id) then
    for i=1,amount do
      item = ItemManager.CreateItem(item_id, health, 1)
      player.inventory:AddItem(item);
    end
    cheat:logInfo("Added [%s] item [%s] to player's inventory (health [%s]).", tostring(amount), tostring(item_name), tostring(health))
    Game.ShowItemsTransfer(item_id, amount)
    return true
  else
    cheat:logError("Item [%s] not found.", tostring(id))
  end
  return false
end

-- ============================================================================
-- cheat_add_all_items
-- ============================================================================
cheat:createCommand("cheat_add_all_items", "cheat:cheat_add_all_items()", nil,
  "Adds all items the player's inventory. This is probably a bad idea...",
  "Add all items", "cheat_add_all_items")
function cheat:cheat_add_all_items()
  local items = cheat:find_item(id, true)
  for item_id,item_name in pairs(items) do
    item = ItemManager.CreateItem(item_id, 100, 1)
    player.inventory:AddItem(item);
    cheat:logInfo("Added item [%s] to player's inventory.", tostring(item_name))
  end
  cheat:logInfo("All items added.")
  return true
end

-- ============================================================================
-- cheat_remove_item
-- ============================================================================
cheat.cheat_remove_item_args = {
  id = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "The item ID or all or part of a the item's name. Uses last match from cheat_find_items.") end,
  amount = function(args,name,showHelp) return cheat:argsGetOptionalNumber(args, name, 1, showHelp, "The number of items to remove. Default 1.") end,
}

cheat:createCommand("cheat_remove_item", "cheat:cheat_remove_item(%line)", cheat.cheat_remove_item_args,
  "Removes an item to the player's inventory.",
  "Removes the last item with 'bow' in its name", "cheat_remove_item id:bow",
  "Removes the item ui_nm_arrow_hunter by ID", "cheat_remove_item id:802507e9-d620-47b5-ae66-08fcc314e26a",
  "Removes 10 items ui_nm_arrow_hunter by fullname", "cheat_remove_item id:ui_nm_arrow_hunter amount:10")
function cheat:cheat_remove_item(line)
  local args = cheat:argsProcess(line, cheat.cheat_remove_item_args)
  local id, idErr = cheat:argsGet(args, 'id')
  local amount, amountErr = cheat:argsGet(args, 'amount', 1)
  if not idErr and not amountErr then
    local item_id, item_name = cheat:find_item(id)
    if not cheat:isBlank(item_id) then
      for i=1,amount do
        player.inventory:RemoveItem(player.inventory:FindItem(item_id), 1)
      end
      cheat:logInfo("Removed [%s] of item [%s] from player's inventory.", tostring(amount), tostring(item_name))
      return true
    else
      cheat:logError("Item [%s] not found.", tostring(id))
    end
  end
  return false
end

-- ============================================================================
-- cheat_remove_all_items
-- ============================================================================
cheat:createCommand("cheat_remove_all_items", "cheat:cheat_remove_all_items()", nil,
  "Removes all items in the player's inventory.\nTHIS DELETES YOUR INVENTORY! Move items you want to a stash first.",
  "Delete your inventory", "cheat_remove_all_items")
function cheat:cheat_remove_all_items()
  player.inventory:RemoveAllItems()
  cheat:logInfo("All inventory items deleted.")
  return true
end

-- ============================================================================
-- cheat_remove_all_stolen_items
-- ============================================================================
cheat:createCommand("cheat_remove_all_stolen_items", "cheat:cheat_remove_all_stolen_items()", nil,
  "Removes all stolen items from your inventory.",
  "Remove stolen items", "cheat_remove_all_stolen_items")
function cheat:cheat_remove_all_stolen_items()
  cheat:recreateitems("removestolen")
  cheat:logInfo("All stolen items removed.")
  return true
end

-- ============================================================================
-- cheat_own_all_stolen_items
-- ============================================================================
cheat:createCommand("cheat_own_all_stolen_items", "cheat:cheat_own_all_stolen_items()", nil,
  "Makes you the owner of all stolen items in your inventory.\n$8This removes the stolen flag from the item.",
  "Take ownership of stolen items", "cheat_own_all_stolen_items")
function cheat:cheat_own_all_stolen_items()
  cheat:recreateitems("ownstolen")
  cheat:logInfo("All stolen items are now owned by the player.")
  return true
end

-- ============================================================================
-- cheat_repair_all_items
-- ============================================================================
cheat:createCommand("cheat_repair_all_items", "cheat:cheat_repair_all_items()", nil,
  "Repairs all damaged items in your inventory. This can uneqip items so don't do this in combat.",
  "Repair all items", "cheat_repair_all_items")
function cheat:cheat_repair_all_items()
  cheat:recreateitems("repairall")
  cheat:logInfo("All items repaired.")
  return true
end

-- ============================================================================
-- cheat_damage_all_items
-- ============================================================================
cheat.cheat_damage_all_items_args = {
  health = function(args,name,showHelp) return cheat:argsGetRequiredNumber(args, name, showHelp, "The item health/condition to apply between 0 and 1.") end
}

cheat:createCommand("cheat_damage_all_items", "cheat:cheat_damage_all_items(%line)", cheat.cheat_damage_all_items_args,
  "Damages all weapons and armor in your inventory. This can uneqip items so don't do this in combat.",
  "Damage all weapons and armor to 50%", "cheat_damage_all_items health:0.5")
function cheat:cheat_damage_all_items(line)
  local args = cheat:argsProcess(line, cheat.cheat_damage_all_items_args)
  local health, healthErr = cheat:argsGet(args, 'health')
  if not healthErr then
    cheat:recreateitems("damageall", health)
    cheat:logInfo("All items damaged.")
    return true
  end
  return false
end

-- ============================================================================
-- end
-- ============================================================================
cheat:logDebug("cheat_core_items.lua loaded")
