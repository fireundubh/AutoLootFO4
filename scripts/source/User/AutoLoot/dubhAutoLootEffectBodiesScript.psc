ScriptName AutoLoot:dubhAutoLootEffectBodiesScript Extends ActiveMagicEffect

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

Function _Log(String asTextToPrint, Int aiSeverity = 0) DebugOnly
  Debug.OpenUserLog("AutoLoot")
  Debug.TraceUser("AutoLoot", "dubhAutoLootEffectBodiesScript> " + asTextToPrint, aiSeverity)
EndFunction

Function LogInfo(String asTextToPrint) DebugOnly
  _Log("[INFO] " + asTextToPrint, 0)
EndFunction

Function LogWarning(String asTextToPrint) DebugOnly
  _Log("[WARN] " + asTextToPrint, 1)
EndFunction

Function LogError(String asTextToPrint) DebugOnly
  _Log("[ERRO] " + asTextToPrint, 2)
EndFunction

Bool Function ItemCanBeProcessed(ObjectReference akItem)
  If !(akItem is Actor)
    Return False
  EndIf

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

Function BuildAndProcessReferences(FormList akFilter)
  ObjectReference[] LootArray = None

  Int i = 0
  Bool bContinue = True

  While (i < akFilter.GetSize()) && bContinue
    bContinue = PlayerRef.HasPerk(ActivePerk) && IsPlayerControlled()

    If bContinue
      LootArray = PlayerRef.FindAllReferencesWithKeyword(akFilter.GetAt(i), Radius.GetValue())

      If LootArray != None && LootArray.Length > 0
        LootArray = FilterLootArray(LootArray)
      EndIf

      If LootArray != None && LootArray.Length > 0
        Loot(LootArray)
      EndIf
    EndIf

    i += 1
  EndWhile

  If (LootArray == None) || (LootArray.Length == 0)
    Return
  EndIf

  LootArray.Clear()
EndFunction

Function Loot(ObjectReference[] akLootArray)
  If akLootArray.Length == 0
    Return
  EndIf

  Int i = 0
  Bool bContinue = True

  While (i < akLootArray.Length) && bContinue
    bContinue = PlayerRef.HasPerk(ActivePerk) && IsPlayerControlled()

    If bContinue
      ObjectReference objLoot = akLootArray[i]

      If objLoot
        LootObject(objLoot)
      EndIf
    EndIf

    i += 1
  EndWhile

  akLootArray.Clear()
EndFunction

Function AddObjectToObjectReferenceArray(ObjectReference akContainer, ObjectReference[] akArray)
  ; exclude empty containers
  If akContainer is Actor
    If akContainer.GetItemCount(None) == 0
      Return
    EndIf
  EndIf

  ; exclude quest items that are explicitly excluded
  If SafeHasForm(QuestItems, akContainer)
    Return
  EndIf

  Bool bAllowStealing = IntToBool(AutoLoot_Setting_AllowStealing)
  Bool bLootOnlyOwned = IntToBool(AutoLoot_Setting_LootOnlyOwned)

  AddObjectToArray(akArray, akContainer, PlayerRef, bAllowStealing, bLootOnlyOwned)
EndFunction

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
          Actor kActor = kItem as Actor

          If kActor && (kActor != PlayerRef)
            If kActor.IsDead()
              If IntToBool(AutoLoot_Setting_PlayerKillerOnly)
                If kActor.GetKiller() == PlayerRef
                  AddObjectToObjectReferenceArray(kItem, kResult)
                  TryToDisableBody(kItem)
                EndIf
              Else
                AddObjectToObjectReferenceArray(kItem, kResult)
                TryToDisableBody(kItem)
              EndIf
            EndIf
          EndIf
        EndIf
      EndIf
    EndIf

    i += 1
  EndWhile

  Return kResult
EndFunction

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

  If IntToBool(AutoLoot_Setting_TakeAll)
    If IntToBool(AutoLoot_Setting_AllowStealing)
      objLoot.RemoveAllItems(DummyActor, bStealingIsHostile)
    Else
      objLoot.RemoveAllItems(DummyActor, False)
    EndIf
  Else
    LootObjectByFilter(objLoot, DummyActor)

    If PlayerRef.HasPerk(AutoLoot_Perk_Components)
      LootObjectByTieredFilter(AutoLoot_Perk_Components, AutoLoot_Filter_Components, AutoLoot_Globals_Components, objLoot, DummyActor)
    EndIf

    If PlayerRef.HasPerk(AutoLoot_Perk_Valuables)
      LootObjectByTieredFilter(AutoLoot_Perk_Valuables, AutoLoot_Filter_Valuables, AutoLoot_Globals_Valuables, objLoot, DummyActor)
    EndIf

    If PlayerRef.HasPerk(AutoLoot_Perk_Weapons)
      LootObjectByTieredFilter(AutoLoot_Perk_Weapons, AutoLoot_Filter_Weapons, AutoLoot_Globals_Weapons, objLoot, DummyActor)
    EndIf
  EndIf

  TryToDisableBody(objLoot)
EndFunction

Function LootObjectByFilter(ObjectReference akContainer, ObjectReference akOtherContainer)
  Int i = 0

  While i < Perks.Length
    If PlayerRef.HasPerk(Perks[i])
      akContainer.RemoveItem(Filters[i], -1, True, akOtherContainer)
    EndIf

    i += 1
  EndWhile
EndFunction

Function LootObjectByTieredFilter(Perk akPerk, FormList akFilter, FormList akGlobals, ObjectReference akContainer, ObjectReference akOtherContainer)
  Int i = 0

  While i < akFilter.GetSize()
    If IntToBool(akGlobals.GetAt(i) as GlobalVariable)
      akContainer.RemoveItem(akFilter.GetAt(i) as FormList, -1, True, akOtherContainer)
    EndIf

    i += 1
  EndWhile
EndFunction

Function TryToDisableBody(ObjectReference akContainer)
  If !IntToBool(AutoLoot_Setting_RemoveBodiesOnLoot)
    Return
  EndIf

  If akContainer.GetItemCount(None) > 0
    Return
  EndIf

  akContainer.DisableNoWait()
  akContainer.Delete()
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
  GlobalVariable Property AutoLoot_Setting_RemoveBodiesOnLoot Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_LootSettlements Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_PlayerKillerOnly Auto Mandatory
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
