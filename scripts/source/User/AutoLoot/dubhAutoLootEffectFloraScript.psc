ScriptName AutoLoot:dubhAutoLootEffectFloraScript Extends ActiveMagicEffect

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
  Debug.TraceUser("AutoLoot", "dubhAutoLootEffectScript> " + AText, ASeverity)
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
  If (AObject.GetBaseObject() as Flora) == None
    Return False
  EndIf

  If (AObject.GetContainer() != None)
    LogInfo(AObject + " cannot be processed because object is in a container")
    Return False
  EndIf

  If !IsObjectInteractable(AObject)
    LogInfo(AObject + " cannot be processed because object is not interactable")
    Return False
  EndIf

  If SafeHasForm(QuestItems, AObject)
    LogInfo(AObject + " cannot be processed because object is explicitly excluded")
    Return False
  EndIf

  If !bLootSettlements
    If SafeHasForm(Locations, AObject.GetCurrentLocation())
      LogInfo(AObject + " cannot be processed because object is in an excluded location")
      Return False
    EndIf
  Else
    WorkshopObjectScript floraObj = AObject as WorkshopObjectScript

    If floraObj
      If !floraObj.IsActorAssigned()
        LogInfo(AObject + " cannot be processed because workshop object is not assigned")
        Return False
      EndIf

      Float harvestTime = floraObj.GetValue(WorkshopParent.WorkshopFloraHarvestTime)

      If Utility.GetCurrentGameTime() <= harvestTime + 1.0
        LogInfo(AObject + " cannot be processed because workshop object is (probably) not ready to be harvested")
        Return False
      EndIf
    EndIf
  EndIf

  Return True
EndFunction

Function BuildAndProcessReferences(FormList AFilter)
  ObjectReference[] Loot = PlayerRef.FindAllReferencesOfType(AFilter, Radius.GetValue())

  Int i = 0

  While (i < Loot.Length) && PlayerRef.HasPerk(ActivePerk) && IsPlayerControlled() && CanPlayerLootInCombat()
    ObjectReference Item = Loot[i] as ObjectReference

    If Item && ItemCanBeProcessed(Item)
      LogInfo("Trying to loot: " + Item)
      TryLootObject(Item)
    EndIf

    i += 1
  EndWhile
EndFunction

Function _LootObject(ObjectReference AObject)
  If bAllowStealing
    If !bStealingIsHostile && PlayerWouldBeStealing(AObject)
      AObject.SetActorRefOwner(PlayerRef)
    EndIf
  EndIf

  If AObject.Activate(DummyActor, False)
    LogInfo(DummyActor + " looted: " + AObject)
    Return
  EndIf

  If AObject.Activate(PlayerRef, False)
    LogInfo(PlayerRef + " looted: " + AObject)
    Return
  EndIf

  LogInfo("Failed to loot: " + AObject)
EndFunction

Function TryLootObject(ObjectReference AObject)
  ; add only owned items when Auto Steal is enabled and mode is set to Owned Only
  If bAllowStealing
    ; special logic for only owned option
    If bLootOnlyOwned
      ; loot only owned items
      If PlayerWouldBeStealing(AObject)
        LogInfo("can loot only owned items")
        _LootObject(AObject)
        Return
      Else
        ; don't loot unowned items
        LogInfo("cannot loot unowned items")
        Return
      EndIf
    EndIf

    ; otherwise, add all items when Auto Steal is enabled and mode is set to Owned and Unowned
    _LootObject(AObject)
    Return
  EndIf

  ; loot only unowned items because Allow Stealing is off
  If !PlayerWouldBeStealing(AObject)
    _LootObject(AObject)
    Return
  EndIf

  LogInfo(AObject + "cannot be looted because player would be stealing")
EndFunction

Bool Function CanPlayerLootInCombat()
  If PlayerRef.IsInCombat()
    Return bLootInCombat
  EndIf

  Return True
EndFunction

Bool Function PlayerWouldBeStealing(ObjectReference AObject)
  Faction owner = AObject.GetFactionOwner()
  Return !(owner == None || owner == PlayerFaction || owner == WorkshopNPCFaction)
EndFunction

; -----------------------------------------------------------------------------
; VARIABLES
; -----------------------------------------------------------------------------

Bool bAllowStealing     = False
Bool bLootInCombat      = False
Bool bLootOnlyOwned     = False
Bool bLootSettlements   = False
Bool bStealingIsHostile = False

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
EndGroup

Group Timer
  Int Property TimerID Auto Mandatory
EndGroup

Group Perks
  Perk Property ActivePerk Auto Mandatory
EndGroup

Group Ownership
  Faction Property PlayerFaction Auto Mandatory
  Faction Property WorkshopNPCFaction Auto Mandatory
  WorkshopParentScript Property WorkshopParent Auto Mandatory
EndGroup
