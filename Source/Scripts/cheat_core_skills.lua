-- ============================================================================
-- find_skill
-- ============================================================================
function cheat:find_skill(searchKey, returnAll)
  local tableName = "skill"
  Database.LoadTable(tableName)
  local tableInfo = Database.GetTableInfo(tableName)
  local rows = tableInfo.LineCount - 1
  local searchKeyUpper = cheat:toUpper(searchKey)
  local skill_id = nil
  local skill_name = nil
  local skills = {}
  
  for i=0,rows do
    local rowInfo = Database.GetTableLine(tableName, i)
    local found = false
    
    if not cheat:isBlank(searchKeyUpper) then
      if cheat:toUpper(rowInfo.skill_id) == searchKeyUpper then
        found = true
      end
      
      if string.find(cheat:toUpper(rowInfo.skill_name), searchKeyUpper, 1, true) then
        found = true
      end
    else
      found = true
    end
    
    if found then
      skill_id = rowInfo.skill_id
      skill_name = rowInfo.skill_name
      
      if returnAll then
        local skill = {}
        skill.skill_id = skill_id
        skill.skill_name = skill_name
        skills[perk_id] = skill
      end
      
      cheat:logInfo("Found skill [%s] with id [%s].", tostring(skill_name), tostring(skill_id))
    end
  end
  
  if returnAll then
    cheat:logDebug("Returning [%s] skills.", tostring(#skills))
    return skills
  else
    cheat:logDebug("Returning skill [%s] with id [%s].", tostring(skill_name), tostring(skill_id))
    return skill_id, skill_name
  end
end

-- ============================================================================
-- cheat_find_skills
-- ============================================================================
cheat.cheat_find_skills_args = {
  token = function(args,name,showHelp) return cheat:argsGetOptional(args, name, nil, showHelp, "All or part of a the skill's name. Leave empty to list all skills.") end
}

cheat:createCommand("cheat_find_skills", "cheat:cheat_find_skills(%line)", cheat.cheat_find_skills_args,
  "Finds all of the skills that match the given token.",
  "Show all skills", "cheat_find_skills token:",
  "Show all skills with 'pick' in their name", "cheat_find_skills token:pick")
function cheat:cheat_find_skills(line)
  local args = cheat:argsProcess(line, cheat.cheat_find_skills_args)
  local token, tokenErr = cheat:argsGet(args, 'token', nil)
  if not tokenErr then
    cheat:find_skill(token)
    return true
  end
  return false
end

-- ============================================================================
-- cheat_set_skill_level
-- ============================================================================
cheat.cheat_set_skill_level_args = {
  skill = function(args,name,showHelp) return cheat:argsGetRequired(args, name, showHelp, "The skill name, full or partial, or ID. Use cheat_find_skills to list all skills.") end,
  level = function(args,name,showHelp) return cheat:argsGetRequiredNumber(args, name, showHelp, "The desired level for the given skill (max 20).") end
}

cheat:createCommand("cheat_set_skill_level", "cheat:cheat_set_skill_level(%line)", cheat.cheat_set_skill_level_args,
  "Sets one of the player's skills to the given level.",
  "Set player's lockpicking skill to level 20", "cheat_set_skill_level skill:lockpicking level:20",
  "Set player's bow skill to level 20", "cheat_set_skill_level skill:18 level:20")
function cheat:cheat_set_skill_level(line)
  local args = cheat:argsProcess(line, cheat.cheat_set_skill_level_args)
  local skill, skillErr = cheat:argsGet(args, 'skill')
  local level, levelErr = cheat:argsGet(args, 'level')
  
  if not skillErr and not levelErr then
    local skill_id, skill_name = cheat:find_skill(skill)
    if skill_id then
      -- AdvanceToSkillLevel  uses name not id
      player.soul:AdvanceToSkillLevel(skill_name, level)
      cheat:logInfo("Set skill [%s] to level [%s].", tostring(skill_name), tostring(level))
      return true
    else
      cheat:logError("Skill [%s] not found.", tostring(skill))
    end
  end
  return false
end

-- ============================================================================
-- end
-- ============================================================================
cheat:logDebug("cheat_core_skills.lua loaded")
