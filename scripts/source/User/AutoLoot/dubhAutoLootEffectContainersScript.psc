ScriptName AutoLoot:dubhAutoLootEffectContainersScript Extends ActiveMagicEffect

Import AutoLoot:dubhAutoLootUtilityScript


; -----------------------------------------------------------------------------
; EVENTS
; -----------------------------------------------------------------------------

Event OnEffectStart(Actor akTarget, Actor akCaster)
  StartTimer(Delay.GetValue() as Int, TimerID)
EndEvent

Event OnTimer(Int aiTimerID)
  If PlayerRef.HasPerk(ActivePerk)
    If IsPlayerControlled()
      bAllowStealing     = IntToBool(AutoLoot_Setting_AllowStealing)
      bLootInCombat      = IntToBool(AutoLoot_Setting_LootInCombat)
      bLootOnlyOwned     = IntToBool(AutoLoot_Setting_LootOnlyOwned)
      bLootSettlements   = IntToBool(AutoLoot_Setting_LootSettlements)
      bStealingIsHostile = IntToBool(AutoLoot_Setting_StealingIsHostile)
      bTakeAll           = IntToBool(AutoLoot_Setting_TakeAll)
      bUnlockContainers  = IntToBool(AutoLoot_Setting_UnlockContainers)

      BuildAndProcessReferences(Filter)
    EndIf

    StartTimer(Delay.GetValue() as Int, TimerID)
  EndIf
EndEvent

; -----------------------------------------------------------------------------
; FUNCTIONS
; -----------------------------------------------------------------------------

Function _Log(String AText, Int ASeverity = 0) DebugOnly
  Debug.OpenUserLog("AutoLoot")
  Debug.TraceUser("AutoLoot", "dubhAutoLootEffectContainersScript> " + AText, ASeverity)
EndFunction

Function LogInfo(String AText) DebugOnly
  _Log("[INFO] " + AText, 0)
EndFunction

Function LogWarning(String AText) DebugOnly
  _Log("[WARN] " + AText, 1)
EndFunction

Function LogError(String AText) DebugOnly
  _Log("[ERRO] " + AText, 2)
EndFunction

Bool Function ItemCanBeProcessed(ObjectReference AObject)
  If !IsObjectInteractable(AObject)
    Return False
  EndIf

  ; exclude empty containers
  Int TotalItemCount = AObject.GetItemCount(None)

  If TotalItemCount <= 0
    Return False
  EndIf

  ; GetItemCount(None) counts non-playable items so we need to account for non-playable items
  Int NonPlayableItemCount = AObject.GetItemCount(NonPlayableItems)

  If (NonPlayableItemCount > 0) && ((TotalItemCount - NonPlayableItemCount) <= 0)
    Return False
  EndIf

  If !bUnlockContainers
    If AObject.IsLocked()
      Return False
    EndIf
  EndIf

  If !bLootSettlements
    If SafeHasForm(Locations, AObject.GetCurrentLocation())
      Return False
    EndIf
  EndIf

  If SafeHasForm(QuestItems, AObject)
    Return False
  EndIf

  Return True
EndFunction

Function BuildAndProcessReferences(FormList AFilter)
  ObjectReference[] Loot = PlayerRef.FindAllReferencesOfType(AFilter, Radius.GetValue())

  If Loot.Length == 0
    Return
  EndIf

  If (Loot.Length == 1) && (Loot[0] == PlayerRef)
    Return
  EndIf

  Int i = 0

  While (i < Loot.Length) && PlayerRef.HasPerk(ActivePerk) && IsPlayerControlled() && CanPlayerLootInCombat()
    ObjectReference Item = Loot[i] as ObjectReference

    If Item && ItemCanBeProcessed(Item)
      TryLootObject(Item)
    EndIf

    i += 1
  EndWhile
EndFunction

Function _LootObject(ObjectReference AObject)
  If bAllowStealing
    If !bStealingIsHostile && PlayerRef.WouldBeStealing(AObject)
      AObject.SetActorRefOwner(PlayerRef)
    EndIf
  EndIf

  If AObject.IsLocked()
    If !TryToUnlockForXP(AObject)
      Return
    EndIf
  EndIf

  If bTakeAll
    AObject.RemoveAllItems(DummyActor, bAllowStealing && bStealingIsHostile)
  Else
    LootObjectByPerk(PlayerRef,Perks, Filters, AObject, DummyActor)

    If PlayerRef.HasPerk(AutoLoot_Perk_Components)
      LootObjectByComponent(AutoLoot_Globals_Components, AutoLoot_Filter_Components, AObject, DummyActor)
    EndIf

    If PlayerRef.HasPerk(AutoLoot_Perk_Valuables)
      LootObjectByFormList(AutoLoot_Globals_Valuables, AutoLoot_Filter_Valuables, AObject, DummyActor)
    EndIf

    If PlayerRef.HasPerk(AutoLoot_Perk_Weapons)
      LootObjectByFormList(AutoLoot_Globals_Weapons, AutoLoot_Filter_Weapons, AObject, DummyActor)
    EndIf
  EndIf
EndFunction

Function TryLootObject(ObjectReference AObject)
  ; add only owned items when Auto Steal is enabled and mode is set to Owned Only
  If bAllowStealing
    ; special logic for only owned option
    If bLootOnlyOwned
      ; loot only owned items
      If PlayerRef.WouldBeStealing(AObject)
        _LootObject(AObject)
        Return
      Else
        ; don't loot unowned items
        Return
      EndIf
    EndIf

    ; otherwise, add all items when Auto Steal is enabled and mode is set to Owned and Unowned
    _LootObject(AObject)
    Return
  EndIf

  ; loot only unowned items because Allow Stealing is off
  If !PlayerRef.WouldBeStealing(AObject)
    _LootObject(AObject)
  EndIf
EndFunction

Bool Function PlayerCanPickLock()
  Return PlayerRef.HasPerk(Locksmith[0]) || PlayerRef.HasPerk(Locksmith[1]) || PlayerRef.HasPerk(Locksmith[2]) || PlayerRef.HasPerk(Locksmith[3])
EndFunction

Bool Function TryToUnlockForXP(ObjectReference AContainer)
  Int iXPReward = 0
  Int iLockDifficulty = AContainer.GetLockLevel()

  If iLockDifficulty < 50
    iXPReward = Game.GetGameSettingFloat("fLockpickXPRewardEasy") as Int ; 5 Base XP
  ElseIf iLockDifficulty >= 50 && iLockDifficulty < 75
    iXPReward = Game.GetGameSettingFloat("fLockpickXPRewardAverage") as Int ; 10 Base XP
  ElseIf iLockDifficulty >= 75 && iLockDifficulty < 100
    iXPReward = Game.GetGameSettingFloat("fLockpickXPRewardHard") as Int ; 15 Base XP
  ElseIf iLockDifficulty >= 100
    iXPReward = Game.GetGameSettingFloat("fLockpickXPRewardVeryHard") as Int ; 20 Base XP
  EndIf

  If iLockDifficulty < 50 || PlayerCanPickLock()
    AContainer.Unlock(False)
    Game.RewardPlayerXP(iXPReward, False)

    Return True
  EndIf

  Return False
EndFunction

Bool Function CanPlayerLootInCombat()
  If PlayerRef.IsInCombat()
    Return bLootInCombat
  EndIf

  Return True
EndFunction

; -----------------------------------------------------------------------------
; VARIABLES
; -----------------------------------------------------------------------------

Bool bAllowStealing     = False
Bool bLootInCombat      = False
Bool bLootOnlyOwned     = False
Bool bLootSettlements   = False
Bool bStealingIsHostile = False
Bool bTakeAll           = False
Bool bUnlockContainers  = False

; -----------------------------------------------------------------------------
; PROPERTIES
; -----------------------------------------------------------------------------

Group Actors
  Actor Property PlayerRef Auto Mandatory
  Actor Property DummyActor Auto Mandatory
EndGroup

Group Forms
  FormList Property Filter Auto Mandatory
  FormList Property Locations Auto Mandatory
  FormList Property NonPlayableItems Auto Mandatory
  FormList Property QuestItems Auto Mandatory
  Component[] Property AutoLoot_Filter_Components Auto Mandatory
  FormList[] Property AutoLoot_Filter_Valuables Auto Mandatory
  FormList[] Property AutoLoot_Filter_Weapons Auto Mandatory
  GlobalVariable[] Property AutoLoot_Globals_Components Auto Mandatory
  GlobalVariable[] Property AutoLoot_Globals_Valuables Auto Mandatory
  GlobalVariable[] Property AutoLoot_Globals_Weapons Auto Mandatory
EndGroup

Group Globals
  GlobalVariable Property Destination Auto Mandatory
  GlobalVariable Property Delay Auto Mandatory
  GlobalVariable Property Radius Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_AllowStealing Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_LootInCombat Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_LootOnlyOwned Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_LootSettlements Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_StealingIsHostile Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_TakeAll Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_UnlockContainers Auto Mandatory
EndGroup

Group Timer
  Int Property TimerID Auto Mandatory
EndGroup

Group Perks
  Perk Property ActivePerk Auto Mandatory
  Perk Property AutoLoot_Perk_Components Auto Mandatory
  Perk Property AutoLoot_Perk_Valuables Auto Mandatory
  Perk Property AutoLoot_Perk_Weapons Auto Mandatory
EndGroup

Group Func_LootObjectByFilter
  FormList[] Property Filters Auto Mandatory  ; untiered filter formlists only
  Perk[] Property Perks Auto Mandatory        ; untiered filter perks only
EndGroup

Group Func_PlayerCanPickLock
  Perk[] Property Locksmith Auto Mandatory
EndGroup
