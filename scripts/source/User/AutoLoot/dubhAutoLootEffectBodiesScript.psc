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
      bAllowStealing      = IntToBool(AutoLoot_Setting_AllowStealing)
      bLootOnlyOwned      = IntToBool(AutoLoot_Setting_LootOnlyOwned)
      bLootSettlements    = IntToBool(AutoLoot_Setting_LootSettlements)
      bPlayerKillerOnly   = IntToBool(AutoLoot_Setting_PlayerKillerOnly)
      bRemoveBodiesOnLoot = IntToBool(AutoLoot_Setting_RemoveBodiesOnLoot)
      bStealingIsHostile  = IntToBool(AutoLoot_Setting_StealingIsHostile)
      bTakeAll            = IntToBool(AutoLoot_Setting_TakeAll)

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

  Actor NPC = AObject as Actor

  If NPC == PlayerRef
    Return False
  EndIf

  If !NPC.IsDead()
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

  If !IsObjectInteractable(AObject)
    Return False
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
  Int i = 0

  While (i < AFilter.GetSize()) && PlayerRef.HasPerk(ActivePerk) && IsPlayerControlled()
    ObjectReference[] Loot = PlayerRef.FindAllReferencesWithKeyword(AFilter.GetAt(i), Radius.GetValue())

    If (Loot.Length > 0) && !(Loot.Length == 1 && Loot[0] == PlayerRef)
      TryLootObjects(Loot)  ; `Loot` will be cleared!
    EndIf

    i += 1
  EndWhile
EndFunction

Function TryLootObjects(ObjectReference[] ALoot)
  Int i = 0

  While (i < ALoot.Length) && PlayerRef.HasPerk(ActivePerk) && IsPlayerControlled()
    ObjectReference Item = ALoot[i] as ObjectReference

    If Item && ItemCanBeProcessed(Item)
      Actor NPC = Item as Actor

      If bPlayerKillerOnly
        If NPC.GetKiller() == PlayerRef
          TryLootObject(Item)
        EndIf
      Else
        TryLootObject(Item)
      EndIf
    EndIf

    i += 1
  EndWhile

  ALoot.Clear()
EndFunction

Function LootObject(ObjectReference AObject)
  If bAllowStealing
    If !bStealingIsHostile && PlayerRef.WouldBeStealing(AObject)
      AObject.SetActorRefOwner(PlayerRef)
    EndIf
  EndIf

  If bTakeAll
    AObject.RemoveAllItems(DummyActor, bAllowStealing && bStealingIsHostile)
  Else
    LootObjectByPerk(PlayerRef, Perks, Filters, AObject, DummyActor)

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

  If bRemoveBodiesOnLoot
    TryToDisableBody(AObject)
  EndIf
EndFunction

Function TryLootObject(ObjectReference AObject)
  ; add only owned items when Auto Steal is enabled and mode is set to Owned Only
  If bAllowStealing
    ; special logic for only owned option
    If bLootOnlyOwned
      ; loot only owned items
      If PlayerRef.WouldBeStealing(AObject)
        LootObject(AObject)
        Return
      Else
        ; don't loot unowned items
        Return
      EndIf
    EndIf

    ; otherwise, add all items when Auto Steal is enabled and mode is set to Owned and Unowned
    LootObject(AObject)
    Return
  EndIf

  ; loot only unowned items because Allow Stealing is off
  If !PlayerRef.WouldBeStealing(AObject)
    LootObject(AObject)
  EndIf
EndFunction

Function TryToDisableBody(ObjectReference AObject)
  Int TotalItemCount = AObject.GetItemCount(None)

  If TotalItemCount > 0
    ; GetItemCount(None) counts non-playable items so we need to account for non-playable items
    Int NonPlayableItemCount = AObject.GetItemCount(NonPlayableItems)

    If (NonPlayableItemCount > 0) && ((TotalItemCount - NonPlayableItemCount) > 0)
      Return
    EndIf
  EndIf

  AObject.DisableNoWait()
  AObject.Delete()
EndFunction

; -----------------------------------------------------------------------------
; VARIABLES
; -----------------------------------------------------------------------------

Bool bAllowStealing      = False
Bool bLootOnlyOwned      = False
Bool bLootSettlements    = False
Bool bPlayerKillerOnly   = False
Bool bRemoveBodiesOnLoot = False
Bool bStealingIsHostile  = False
Bool bTakeAll            = False

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
  GlobalVariable Property AutoLoot_Setting_LootOnlyOwned Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_LootSettlements Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_PlayerKillerOnly Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_RemoveBodiesOnLoot Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_StealingIsHostile Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_TakeAll Auto Mandatory
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
