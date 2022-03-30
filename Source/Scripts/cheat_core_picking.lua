-- ============================================================================
-- cheat_no_stash_lockpicking
-- ============================================================================
cheat:createCommand("cheat_no_stash_lockpicking", "cheat:cheat_no_stash_lockpicking()", nil,
  "This disables the lockpicking minigame on stashes and automatically opens the stash for looting.\n$8Restarting the game reverts this effect.",
  "Turn off lockpicking minigame on stashes", "cheat_no_stash_lockpicking")
function cheat:cheat_no_stash_lockpicking()
  for key,value in pairs(AnimDoor) do
    if key == "Lockpick" then
      AnimDoor[key] = function(self, user, slot)
        cheat:logDebug("AnimDoor:Lockpick() Override")
        if self.lockpickable and (self.bLocked == 1) and self:IsOnKeySide() == 1 and (self.nUserId == 0) then
          --Minigame.StartLockPicking(self.id);
          self:Unlock()
          self:Open()
          cheat:logDebug("Door Unlocked")
        end
      end
      cheat:logDebug("Replaced AnimDoor:Lockpick() function.")
    end
  end
  cheat:logInfo("Door Lockpicking Disabled")
  return true
end

-- ============================================================================
-- cheat_no_door_lockpicking
-- ============================================================================
cheat:createCommand("cheat_no_door_lockpicking", "cheat:cheat_no_door_lockpicking()", nil,
  "This disables the lockpicking minigame on doors and automatically opens the door.\n$8Restarting the game reverts this effect.",
  "Turn off lockpicking minigame on doors", "cheat_no_door_lockpicking")
function cheat:cheat_no_door_lockpicking()
  for key,value in pairs(Stash) do
    if key == "OnUsedHold" then
      Stash[key] = function(self, user, slot)
        cheat:logDebug("Stash:OnUsedHold() Override")
        if (self.nDirection == 0 or self.bNeedUpdate == 1) then
          return;
        end
        local nNewDirection = -self.nDirection;
        if (nNewDirection == 1) then
          if ((self.Properties.Lock.bCanLockPick == 1) and ((self.bLocked == true) or ((self.bLocked == 1) or (Framework.IsValidWUID(Shops.IsLinkedWithShop(self.id)))))) then
            -- Minigame.StartLockPicking(self.id);
            cheat:logDebug("Unlocking Stash")
            self:Unlock()
            self:Open(player)
            cheat:logDebug("Stash Unlocked")
          end
        end
      end
      cheat:logDebug("Replaced Stash:OnUsedHold() function.")
    end
  end
  cheat:logInfo("Stash Lockpicking Disabled")
  return true
end

-- ============================================================================
-- cheat_no_lockpicking
-- ============================================================================
cheat:createCommand("cheat_no_lockpicking", "cheat:cheat_no_lockpicking()", nil,
  "This calls cheat_no_stash_lockpicking and cheat_no_door_lockpicking.",
  "Turn off lockpicking minigames on doors and stashes", "cheat_no_lockpicking")
function cheat:cheat_no_lockpicking()
  cheat:cheat_no_stash_lockpicking()
  cheat:cheat_no_door_lockpicking()
  return true
end

-- ============================================================================
-- cheat_no_pickpocketing
-- ============================================================================
cheat:createCommand("cheat_no_pickpocketing", "cheat:cheat_no_pickpocketing()", nil,
  "This disables the pickpocketing minigame and automatically opens the person's inventory for looting.\n$8They can still catch you.\n$8Restarting the game reverts this effect.",
  "Turn off pickpocketing minigame", "cheat_no_pickpocketing")
function cheat:cheat_no_pickpocketing()
  for key,value in pairs(BasicAIActions) do
    if key == "OnPickpocketing" then
      BasicAIActions[key] = function(self, user, slotId)
        cheat:logDebug("BasicAIActions:OnPickpocketing() Override")
        XGenAIModule.LootBegin(self.soul:GetId());
        self.actor:RequestItemExchange(user.id);
      end
      cheat:logDebug("Replaced BasicAIActions:OnPickpocketing() function.")
    end
  end
  cheat:logInfo("Pickpocketing Disabled")
  return true
end

-- ============================================================================
-- end
-- ============================================================================
cheat:logDebug("cheat_core_picking.lua loaded")
