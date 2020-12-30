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
      BuildAndProcessReferences(Filter)
    EndIf

    StartTimer(Delay.GetValue() as Int, TimerID)
  EndIf
EndEvent

; -----------------------------------------------------------------------------
; FUNCTIONS
; -----------------------------------------------------------------------------

; Log

Function Log(String asFunction = "", String asMessage = "") DebugOnly
  Debug.TraceSelf(Self, asFunction, asMessage)
EndFunction

; Return true if all conditions are met

Bool Function ItemCanBeProcessed(ObjectReference akItem)
  If !IsObjectInteractable(akItem)
    Return False
  EndIf

  If !IntToBool(AutoLoot_Setting_LootSettlements)
    If SafeHasForm(Locations, akItem.GetCurrentLocation())
      Return False
    EndIf
  EndIf

  Return True
EndFunction

; Build and process references

Function BuildAndProcessReferences(FormList akFilter)
  ObjectReference[] LootArray = PlayerRef.FindAllReferencesOfType(akFilter, Radius.GetValue())

  If (LootArray == None) || (LootArray.Length == 0)
    Return
  EndIf

  LootArray = FilterLootArray(LootArray)

  If (LootArray == None) || (LootArray.Length == 0)
    Return
  EndIf

  Int i = 0
  Bool bContinue = True

  While (i < LootArray.Length) && bContinue
    bContinue = PlayerRef.HasPerk(ActivePerk) && IsPlayerControlled()

    If bContinue
      ObjectReference objLoot = LootArray[i]

      If objLoot
        LootObject(objLoot)
      EndIf
    EndIf

    i += 1
  EndWhile

  If (LootArray == None) || (LootArray.Length == 0)
    Return
  EndIf

  LootArray.Clear()
EndFunction

; Adds an object reference to the filtered loot array

Function AddObjectToObjectReferenceArray(ObjectReference akContainer, ObjectReference[] akArray)
  ; exclude empty containers
  If akContainer.GetItemCount(None) == 0
    Return
  EndIf

  ; exclude quest items that are explicitly excluded
  If QuestItems.GetSize() > 0
    If QuestItems.HasForm(akContainer)
      Return
    EndIf
  EndIf

  ; do not add items in locked containers when Auto Lockpick is disabled
  If !IntToBool(AutoLoot_Setting_UnlockContainers)
    If akContainer.IsLocked()
      Return
    EndIf
  EndIf

  Bool bAllowStealing = IntToBool(AutoLoot_Setting_AllowStealing)
  Bool bLootOnlyOwned = IntToBool(AutoLoot_Setting_LootOnlyOwned)

  AddObjectToArray(akArray, akContainer, PlayerRef, bAllowStealing, bLootOnlyOwned)
EndFunction

; Filters the loot array for valid items

ObjectReference[] Function FilterLootArray(ObjectReference[] akArray)
  ObjectReference[] kResult = new ObjectReference[0]

  If akArray.Length == 0
    Return kResult
  EndIf

  Int i = 0
  Bool bContinue = True

  While (i < akArray.Length) && bContinue
    bContinue = PlayerRef.HasPerk(ActivePerk) && IsPlayerControlled()

    If bContinue
      ObjectReference kItem = akArray[i]

      If kItem
        If ItemCanBeProcessed(kItem)
          AddObjectToObjectReferenceArray(kItem, kResult)
        EndIf
      EndIf
    EndIf

    i += 1
  EndWhile

  Return kResult
EndFunction

; Loot Object

Function LootObject(ObjectReference objLoot)
  If (objLoot == None) || (DummyActor == None)
    Return
  EndIf

  Bool bStealingIsHostile = IntToBool(AutoLoot_Setting_StealingIsHostile)

  If IntToBool(AutoLoot_Setting_AllowStealing)
    If !bStealingIsHostile && PlayerRef.WouldBeStealing(objLoot)
      objLoot.SetActorRefOwner(PlayerRef)
    EndIf
  EndIf

  If objLoot.IsLocked()
    If !TryToUnlockForXP(objLoot)
      Return
    EndIf
  EndIf

  If IntToBool(AutoLoot_Setting_TakeAll)
    objLoot.RemoveAllItems(DummyActor, bStealingIsHostile)
  Else
    LootObjectByFilter(FilterAll, Perks, objLoot, DummyActor)
    LootObjectByTieredFilter(AutoLoot_Perk_Components, AutoLoot_Filter_Components, AutoLoot_Globals_Components, objLoot, DummyActor)
    LootObjectByTieredFilter(AutoLoot_Perk_Valuables, AutoLoot_Filter_Valuables, AutoLoot_Globals_Valuables, objLoot, DummyActor)
    LootObjectByTieredFilter(AutoLoot_Perk_Weapons, AutoLoot_Filter_Weapons, AutoLoot_Globals_Weapons, objLoot, DummyActor)
  EndIf
EndFunction

; Loot specific items using active filters - excludes bodies and containers filters

Function LootObjectByFilter(FormList akFilters, FormList akPerks, ObjectReference akContainer, ObjectReference akOtherContainer)
  Int i = 0
  Bool bContinue = True

  While (i < akFilters.GetSize()) && bContinue
    bContinue = PlayerRef.HasPerk(ActivePerk) && IsPlayerControlled()

    If bContinue && i != 2  ; skip AutoLoot_Perk_Components/AutoLoot_Filter_Components
      If PlayerRef.HasPerk(akPerks.GetAt(i) as Perk)
        akContainer.RemoveItem(akFilters.GetAt(i) as FormList, -1, True, akOtherContainer)
      EndIf
    EndIf

    i += 1
  EndWhile
EndFunction

; Loot specific items using active tiered filters

Function LootObjectByTieredFilter(Perk akPerk, FormList akFilter, FormList akGlobals, ObjectReference akContainer, ObjectReference akOtherContainer)
  If !PlayerRef.HasPerk(akPerk)
    Return
  EndIf

  Int i = 0
  Bool bContinue = True

  While (i < akFilter.GetSize()) && bContinue
    bContinue = PlayerRef.HasPerk(ActivePerk) && IsPlayerControlled()

    If bContinue
      If IntToBool(akGlobals.GetAt(i) as GlobalVariable)
        akContainer.RemoveItem(akFilter.GetAt(i) as FormList, -1, True, akOtherContainer)
      EndIf
    EndIf

    i += 1
  EndWhile
EndFunction

; Check if player has a lockpicking perk - uses formlist to support other mods

Bool Function PlayerCanPickLock()
  Int i = 0
  Bool bContinue = True

  While (i < AutoLoot_Perks_Lockpicking.GetSize()) && bContinue
    bContinue = PlayerRef.HasPerk(ActivePerk) && IsPlayerControlled()

    If bContinue
      If PlayerRef.HasPerk(AutoLoot_Perks_Lockpicking.GetAt(i) as Perk)
        Return True
      EndIf
    EndIf

    i += 1
  EndWhile

  Return False
EndFunction

; Unlock and reward XP based on lock level

Bool Function TryToUnlockForXP(ObjectReference objContainer)
  Int iXPReward = 0
  Int iLockDifficulty = objContainer.GetLockLevel()

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
    objContainer.Unlock(False)
    Game.RewardPlayerXP(iXPReward, False)

    Return True
  EndIf

  Return False
EndFunction

; -----------------------------------------------------------------------------
; PROPERTIES
; -----------------------------------------------------------------------------

Group Actors
  Actor Property PlayerRef Auto Mandatory
  Actor Property DummyActor Auto Mandatory
EndGroup

Group Forms
  FormList Property Filter Auto Mandatory
  FormList Property FilterAll Auto Mandatory
  FormList Property QuestItems Auto Mandatory
  FormList Property AutoLoot_Filter_Components Auto Mandatory
  FormList Property AutoLoot_Filter_Valuables Auto Mandatory
  FormList Property AutoLoot_Filter_Weapons Auto Mandatory
  FormList Property AutoLoot_Globals_Components Auto Mandatory
  FormList Property AutoLoot_Globals_Valuables Auto Mandatory
  FormList Property AutoLoot_Globals_Weapons Auto Mandatory
  FormList Property Locations Auto Mandatory
  FormList Property Perks Auto Mandatory
  FormList Property AutoLoot_Perks_Lockpicking Auto Mandatory
EndGroup

Group Globals
  GlobalVariable Property Destination Auto Mandatory
  GlobalVariable Property Delay Auto Mandatory
  GlobalVariable Property Radius Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_TakeAll Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_AllowStealing Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_StealingIsHostile Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_LootOnlyOwned Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_UnlockContainers Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_LootSettlements Auto Mandatory
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
