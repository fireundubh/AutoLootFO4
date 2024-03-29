ScriptName AutoLoot:dubhAutoLootEffectValuablesScript Extends ActiveMagicEffect

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

      If IntToBool(Filter_Globals[0])
        BuildAndProcessReferences(Filter[0])
      EndIf

      If IntToBool(Filter_Globals[1])
        BuildAndProcessReferences(Filter[1])
      EndIf

      If IntToBool(Filter_Globals[2])
        BuildAndProcessReferences(Filter[2])
      EndIf

      ; Scrap
      If IntToBool(Filter_Globals[3])
        BuildAndProcessReferences(Filter[3])
      EndIf

      ; Components
      If IntToBool(Filter_Globals[4])
        BuildAndProcessReferencesForComponents(Filter[4])
      EndIf
    EndIf

    StartTimer(Delay.GetValue() as Int, TimerID)
  EndIf
EndEvent

; -----------------------------------------------------------------------------
; FUNCTIONS
; -----------------------------------------------------------------------------

Function _Log(String AText, Int ASeverity = 0) DebugOnly
  Debug.OpenUserLog("AutoLoot")
  Debug.TraceUser("AutoLoot", "dubhAutoLootEffectTieredScript> " + AText, ASeverity)
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
  If (AObject.GetContainer() != None)
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
  ObjectReference[] Loot = None

  Loot = PlayerRef.FindAllReferencesOfType(AFilter, Radius.GetValue())

  Int i = 0

  While (i < Loot.Length) && PlayerRef.HasPerk(ActivePerk) && IsPlayerControlled() && CanPlayerLootInCombat()
    ObjectReference Item = Loot[i] as ObjectReference

    If Item && ItemCanBeProcessed(Item)
      TryLootObject(Item)
    EndIf

    i += 1
  EndWhile
EndFunction

Function BuildAndProcessReferencesForComponents(FormList AFilter)
  ObjectReference[] Loot = None

  Loot = PlayerRef.FindAllReferencesOfType(Junk, Radius.GetValue())

  Int i = 0

  While (i < Loot.Length) && PlayerRef.HasPerk(ActivePerk) && IsPlayerControlled() && CanPlayerLootInCombat()
    ObjectReference Item = Loot[i] as ObjectReference

    If Item && ItemCanBeProcessed(Item) && HasObjectComponents(Item, AFilter)
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

  AObject.Activate(DummyActor, False)
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

Bool Function CanPlayerLootInCombat()
  If PlayerRef.IsInCombat()
    Return bLootInCombat
  EndIf

  Return True
EndFunction

Bool Function HasObjectComponents(ObjectReference AObject, FormList AComponents)
  Int i = 0

  While i < AComponents.GetSize()
    Component Item = AComponents.GetAt(i) as Component

    If (AObject.GetBaseObject() as MiscObject).GetObjectComponentCount(Item) > 0
      Return True
    EndIf

    i += 1
  EndWhile

  Return False
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
  FormList[] Property Filter Auto Mandatory
  FormList Property Locations Auto Mandatory
  FormList Property QuestItems Auto Mandatory
  FormList Property Junk Auto Mandatory
EndGroup

Group Globals
  GlobalVariable[] Property Filter_Globals Auto Mandatory
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
