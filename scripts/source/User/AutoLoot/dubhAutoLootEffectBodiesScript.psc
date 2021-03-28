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

Function _Log(String AText, Int ASeverity = 0) DebugOnly
  Debug.OpenUserLog("AutoLoot")
  Debug.TraceUser("AutoLoot", "dubhAutoLootEffectBodiesScript> " + AText, ASeverity)
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
  If !(AObject is Actor)
    Return False
  EndIf

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
  ObjectReference[] Loot = new ObjectReference[0]

  Int i = 0

  While i < AFilter.GetSize()
    If PlayerRef.HasPerk(ActivePerk) && IsPlayerControlled()
      Loot = PlayerRef.FindAllReferencesWithKeyword(AFilter.GetAt(i), Radius.GetValue())

      If Loot.Length > 0
        Loot = FilterLootArray(Loot)
      EndIf

      If Loot.Length > 0
        TryLootObjects(Loot)  ; `Loot` will be cleared!
      EndIf
    Else
      ; just try to start a new timer, no need to finish loop
      Return
    EndIf

    i += 1
  EndWhile
EndFunction

Function TryLootObjects(ObjectReference[] ALoot)
  Int i = 0
  Bool bContinue = True

  While (i < ALoot.Length) && bContinue
    bContinue = PlayerRef.HasPerk(ActivePerk) && IsPlayerControlled()

    If bContinue
      ObjectReference Item = ALoot[i] as ObjectReference

      If Item
        LootObject(Item)
      EndIf
    EndIf

    i += 1
  EndWhile

  ALoot.Clear()
EndFunction

Function AddObjectToObjectReferenceArray(ObjectReference AContainer, ObjectReference[] ALoot)
  ; exclude empty containers
  If AContainer is Actor
    ; note: GetItemCount(None) counts non-playable items so we need to account for non-playable items
    If (AContainer.GetItemCount(None) - AContainer.GetItemCount(NonPlayableItems)) <= 0
      Return
    EndIf
  EndIf

  ; exclude quest items that are explicitly excluded
  If SafeHasForm(QuestItems, AContainer)
    Return
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
      ObjectReference Item = ALoot[i]

      If Item
        If ItemCanBeProcessed(Item)
          Actor NPC = Item as Actor

          If NPC && (NPC != PlayerRef)
            If NPC.IsDead()
              If IntToBool(AutoLoot_Setting_PlayerKillerOnly)
                If NPC.GetKiller() == PlayerRef
                  AddObjectToObjectReferenceArray(Item, Result)
                  TryToDisableBody(Item)
                EndIf
              Else
                AddObjectToObjectReferenceArray(Item, Result)
                TryToDisableBody(Item)
              EndIf
            EndIf
          EndIf
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

  If IntToBool(AutoLoot_Setting_TakeAll)
    AObject.RemoveAllItems(DummyActor, IntToBool(AutoLoot_Setting_AllowStealing) && bStealingIsHostile)
  Else
    LootObjectByPerk(PlayerRef, Perks, Filters, AObject, DummyActor)

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

  TryToDisableBody(AObject)
EndFunction

Function TryToDisableBody(ObjectReference AContainer)
  If !IntToBool(AutoLoot_Setting_RemoveBodiesOnLoot)
    Return
  EndIf

  If (AContainer.GetItemCount(None) - AContainer.GetItemCount(NonPlayableItems)) > 0
    Return
  EndIf

  AContainer.DisableNoWait()
  AContainer.Delete()
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
