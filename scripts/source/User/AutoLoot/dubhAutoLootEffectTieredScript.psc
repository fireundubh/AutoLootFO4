ScriptName AutoLoot:dubhAutoLootEffectTieredScript Extends ActiveMagicEffect

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
      bLootOnlyOwned     = IntToBool(AutoLoot_Setting_LootOnlyOwned)
      bLootSettlements   = IntToBool(AutoLoot_Setting_LootSettlements)
      bStealingIsHostile = IntToBool(AutoLoot_Setting_StealingIsHostile)

      Int i = 0

      While (i < Filter_Globals.GetSize()) && PlayerRef.HasPerk(ActivePerk) && IsPlayerControlled()

        If IntToBool(Filter_Globals.GetAt(i) as GlobalVariable)
          BuildAndProcessReferences(Filter.GetAt(i) as FormList)
        EndIf

        i += 1
      EndWhile
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
  ObjectReference[] Loot = PlayerRef.FindAllReferencesOfType(AFilter, Radius.GetValue())

  If Loot.Length == 0
    Return
  EndIf

  Int i = 0

  While (i < Loot.Length) && PlayerRef.HasPerk(ActivePerk) && IsPlayerControlled()
    ObjectReference Item = Loot[i] as ObjectReference

    If Item && ItemCanBeProcessed(Item) && (Item.GetContainer() == None)
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

  Bool bDefaultProcessingOnly = AObject.GetBaseObject() is Activator
  AObject.Activate(DummyActor, bDefaultProcessingOnly)
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

; -----------------------------------------------------------------------------
; VARIABLES
; -----------------------------------------------------------------------------

Bool bAllowStealing     = False
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
  FormList Property Filter_Globals Auto Mandatory
  FormList Property QuestItems Auto Mandatory
  FormList Property Locations Auto Mandatory
EndGroup

Group Globals
  GlobalVariable Property Destination Auto Mandatory
  GlobalVariable Property Delay Auto Mandatory
  GlobalVariable Property Radius Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_AllowStealing Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_StealingIsHostile Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_LootOnlyOwned Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_LootSettlements Auto Mandatory
EndGroup

Group Timer
  Int Property TimerID Auto Mandatory
EndGroup

Group Perks
  Perk Property ActivePerk Auto Mandatory
EndGroup
