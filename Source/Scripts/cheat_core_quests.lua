-- ============================================================================
-- find_quest
-- ============================================================================
function cheat:find_quest(searchKey, returnAll)
  local tableName = "quest"
  Database.LoadTable(tableName)
  local tableInfo = Database.GetTableInfo(tableName)
  local rows = tableInfo.LineCount - 1
  local searchKeyUpper = cheat:toUpper(searchKey)
  local quest_id = nil
  local quest_name = nil
  local quests = {}
  
  for i=0,rows do
    local rowInfo = Database.GetTableLine(tableName, i)
    local found = false
    
    if rowInfo then
      if not cheat:isBlank(searchKeyUpper) then
        if cheat:toUpper(rowInfo.quest_id) == searchKeyUpper then
          found = true
        end
        
        if string.find(cheat:toUpper(rowInfo.quest_name), searchKeyUpper, 1, true) then
          found = true
        end
      else
        found = true
      end
      
      if found then
        quest_id = rowInfo.quest_id
        quest_name = rowInfo.quest_name
        if returnAll then
          local quest = {}
          quest.quest_id = quest_id
          quest.quest_name = quest_name
          table.insert(quests, quest)
        end
        cheat:logInfo("Found quest [%s] with id [%s].", tostring(quest_name), string.format("%u",quest_id))
      end
    else
      cheat:logError("nil row, this is a bug")
    end
  end
  
  if returnAll then
    cheat:logDebug("Returning [%s] quests.", tostring(#quests))
    return quests
  else
    cheat:logDebug("Returning quest [%s] with id [%s].", tostring(quest_name), string.format("%u",quest_id))
    return quest_id, quest_name
  end
end

-- ============================================================================
-- find_quest
-- ============================================================================
function cheat:find_quest_objective(questId, objectiveId)
  local tableName = "quest_objective"
  Database.LoadTable(tableName)
  local tableInfo = Database.GetTableInfo(tableName)
  local rows = tableInfo.LineCount - 1
  for i=0,rows do
    local rowInfo = Database.GetTableLine(tableName, i)
    if rowInfo then
      if rowInfo.quest_id == questId and rowInfo.objective_id == objectiveId then
        --cheat:logInfo(string.format("questId=%u objectiveId=%u",questId, objectiveId))
        --cheat:logInfo("Found quest objective [%s].", tostring(rowInfo.objective_name))
        return rowInfo.objective_id, rowInfo.objective_name
      end
    else
      cheat:logError("nil row, this is a bug")
    end
  end
end

-- ============================================================================
-- cheat_quest_show_active
-- ============================================================================
function cheat:quest_show_started()
  local quests = cheat:find_quest(nil, true)
  for _,quest in ipairs(quests) do
    local questStarted = QuestSystem.IsQuestStarted(quest.quest_name)
    if questStarted then
      local questActive = QuestSystem.IsQuestActivated(quest.quest_name)
      cheat:logInfo("Quest [%s] id[%s] (active=%s)", tostring(quest.quest_name), string.format("%u",quest.quest_id), tostring(questActive))
      if questActive then
        local objectives = QuestSystem.GetActiveObjectives(quest.quest_name)
        for key,objective in pairs(objectives) do
          local objectiveId, objectiveName = cheat:find_quest_objective(quest.quest_id, objective)
          local objStarted = QuestSystem.IsObjectiveStarted(quest.quest_name, objective)
          local objCanceled = QuestSystem.IsObjectiveCanceled(quest.quest_name, objective)
          local objCompleted = QuestSystem.IsObjectiveCompleted(quest.quest_name, objective)
          local objUnchanged = QuestSystem.IsObjectiveUnchanged(quest.quest_name, objective)
          local objTrackedCompleted = QuestSystem.IsObjectiveTrackedCompleted(quest.quest_name, objective)
          cheat:logDebug("obj id[%s/%s] name[%s] strt[%s] cncld[%s] cmpld[%s] unchg[%s] trckcmd[%s]",
            tostring(objective),
            tostring(objectiveId),
            tostring(objectiveName),
            tostring(objStarted),
            tostring(objCanceled),
            tostring(objCompleted),
            tostring(objUnchanged),
            tostring(objTrackedCompleted))
        end
      end
    end
  end
end

-- ============================================================================
-- cheat_quest_complete_objective
-- ============================================================================
-- cheat_eval cheat:quest_complete_objective("q_skalitz","fatherIsUpset", true)
function cheat:quest_complete_objective(questName, objectiveName, sendMessage)
  
  --System.ExecuteCommand('wh_dlg_reload');
  
  if not QuestSystem.IsQuestStarted(questName) then
    cheat:logInfo("started quest " .. questName)
    QuestSystem.StartQuest(questName)
  end
  
  if not QuestSystem.IsQuestActivated(questName) then
    cheat:logInfo("activated quest " .. questName)
    QuestSystem.ActivateQuest(questName, 1)
  end
  
  if not QuestSystem.IsObjectiveStarted(questName, objectiveName) then
    cheat:logInfo("started objective " .. objectiveName)
    QuestSystem.StartObjective(questName, objectiveName)
  end
  
  cheat:logInfo("completed objective " .. objectiveName)
  QuestSystem.CompleteObjective(questName, objectiveName, sendMessage)
end

-- ============================================================================
-- cheat_quest_complete
-- ============================================================================
function cheat:quest_complete(questName)
  if not QuestSystem.IsQuestCompleted(questName) then
    QuestSystem.StartQuest(questName);
    if not QuestSystem.IsQuestStarted(questName) then
      QuestSystem.StartQuest(questName);
    end
    QuestSystem.CompleteQuest(questName);
  end
  cheat:logInfo("Quest [%s] completed")
end

-- cheat_eval cheat:quest_complete("q_skalitz")
-- cheat_eval cheat:quest_reset("q_skalitz")
function cheat:quest_reset(questName)
  if QuestSystem.IsQuestStarted(questName) then
    QuestSystem.ResetQuest(questName);
    QuestSystem.ActivateQuest(questName);
	else
		QuestSystem.ActivateQuest(questName);
	end
  cheat:logInfo("Quest [%s] reset")
end

-- ============================================================================
-- end
-- ============================================================================
cheat:logDebug("cheat_core_quests.lua loaded")
