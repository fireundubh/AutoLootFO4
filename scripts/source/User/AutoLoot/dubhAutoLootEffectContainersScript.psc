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

  If !IntToBool(AutoLoot_Setting_LootSettlements)
    If SafeHasForm(Locations, AObject.GetCurrentLocation())
      Return False
    EndIf
  EndIf

  Return True
EndFunction

Function BuildAndProcessReferences(FormList AFilter)
  ObjectReference[] Loot = PlayerRef.FindAllReferencesOfType(AFilter, Radius.GetValue())

  If Loot.Length == 0
    Return
  EndIf

  Loot = FilterLootArray(Loot)

  If Loot.Length == 0
    Return
  EndIf

  Int i = 0

  While i < Loot.Length
    If PlayerRef.HasPerk(ActivePerk) && IsPlayerControlled()
      ObjectReference Item = Loot[i] as ObjectReference

      If Item
        LootObject(Item)
      EndIf
    Else
      ; just try to start a new timer, no need to finish loop
      Return
    EndIf

    i += 1
  EndWhile
EndFunction

Function AddObjectToObjectReferenceArray(ObjectReference AContainer, ObjectReference[] ALoot)
  ; exclude empty containers
  ; note: GetItemCount(None) counts non-playable items so we need to account for non-playable items
  If (AContainer.GetItemCount(None) - AContainer.GetItemCount(NonPlayableItems)) <= 0
    Return
  EndIf

  ; exclude quest items that are explicitly excluded
  If QuestItems.GetSize() > 0
    If QuestItems.HasForm(AContainer)
      Return
    EndIf
  EndIf

  ; do not add items in locked containers when Auto Lockpick is disabled
  If !IntToBool(AutoLoot_Setting_UnlockContainers)
    If AContainer.IsLocked()
      Return
    EndIf
  EndIf

  Bool bAllowStealing = IntToBool(AutoLoot_Setting_AllowStealing)
  Bool bLootOnlyOwned = IntToBool(AutoLoot_Setting_LootOnlyOwned)

  AddObjectToArray(ALoot, AContainer, PlayerRef, bAllowStealing, bLootOnlyOwned)
EndFunction

ObjectReference[] Function FilterLootArray(ObjectReference[] ALoot)
  ObjectReference[] Result = new ObjectReference[0]

  If ALoot.Length == 0
    Return Result
  EndIf

  Int i = 0
  Bool bContinue = True

  While (i < ALoot.Length) && bContinue
    bContinue = PlayerRef.HasPerk(ActivePerk) && IsPlayerControlled()

    If bContinue
      ObjectReference Item = ALoot[i] as ObjectReference

      If Item
        If ItemCanBeProcessed(Item)
          AddObjectToObjectReferenceArray(Item, Result)
        EndIf
      EndIf
    EndIf

    i += 1
  EndWhile

  Return Result
EndFunction

Function LootObject(ObjectReference AObject)
  If (AObject == None) || (DummyActor == None)
    Return
  EndIf

  Bool bStealingIsHostile = IntToBool(AutoLoot_Setting_StealingIsHostile)

  If IntToBool(AutoLoot_Setting_AllowStealing)
    If !bStealingIsHostile && PlayerRef.WouldBeStealing(AObject)
      AObject.SetActorRefOwner(PlayerRef)
    EndIf
  EndIf

  If AObject.IsLocked()
    If !TryToUnlockForXP(AObject)
      Return
    EndIf
  EndIf

  If IntToBool(AutoLoot_Setting_TakeAll)
    AObject.RemoveAllItems(DummyActor, IntToBool(AutoLoot_Setting_AllowStealing) && bStealingIsHostile)
  Else
    LootObjectByPerk(PlayerRef,Perks, Filters, AObject, DummyActor)

    If PlayerRef.HasPerk(AutoLoot_Perk_Components)
      LootObjectByTieredFilter(AutoLoot_Globals_Components, AutoLoot_Filter_Components, AObject, DummyActor)
    EndIf

    If PlayerRef.HasPerk(AutoLoot_Perk_Valuables)
      LootObjectByTieredFilter(AutoLoot_Globals_Valuables, AutoLoot_Filter_Valuables, AObject, DummyActor)
    EndIf

    If PlayerRef.HasPerk(AutoLoot_Perk_Weapons)
      LootObjectByTieredFilter(AutoLoot_Globals_Weapons, AutoLoot_Filter_Weapons, AObject, DummyActor)
    EndIf
  EndIf
EndFunction

Bool Function PlayerCanPickLock()
  Return PlayerRef.HasPerk(Locksmith01) || PlayerRef.HasPerk(Locksmith02) || PlayerRef.HasPerk(Locksmith03) || PlayerRef.HasPerk(Locksmith04)
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
  FormList Property AutoLoot_Filter_Components Auto Mandatory
  FormList Property AutoLoot_Filter_Valuables Auto Mandatory
  FormList Property AutoLoot_Filter_Weapons Auto Mandatory
  FormList Property AutoLoot_Globals_Components Auto Mandatory
  FormList Property AutoLoot_Globals_Valuables Auto Mandatory
  FormList Property AutoLoot_Globals_Weapons Auto Mandatory
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

Group Func_LootObjectByFilter
  FormList[] Property Filters Auto Mandatory  ; untiered filter formlists only
  Perk[] Property Perks Auto Mandatory        ; untiered filter perks only
EndGroup

Group Func_PlayerCanPickLock
  Perk Property Locksmith01 Auto Mandatory
  Perk Property Locksmith02 Auto Mandatory
  Perk Property Locksmith03 Auto Mandatory
  Perk Property Locksmith04 Auto Mandatory
EndGroup
