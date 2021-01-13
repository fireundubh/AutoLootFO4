ScriptName AutoLoot:dubhAutoLootEffectScript Extends ActiveMagicEffect

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
      bStealingIsHostile = IntToBool(AutoLoot_Setting_StealingIsHostile)

      BuildAndProcessReferences(Filter)
    EndIf

    StartTimer(Delay.GetValue() as Int, TimerID)
  EndIf
EndEvent

; -----------------------------------------------------------------------------
; FUNCTIONS
; -----------------------------------------------------------------------------

Function Log(String asFunction = "", String asMessage = "") DebugOnly
  Debug.TraceSelf(Self, asFunction, asMessage)
EndFunction

Bool Function ItemCanBeProcessed(ObjectReference akItem)
  If IsObjectInteractable(akItem)
    Return True
  EndIf

  If !IntToBool(AutoLoot_Setting_LootSettlements)
    If SafeHasForm(Locations, akItem.GetCurrentLocation())
      Return False
    EndIf
  EndIf

  Return False
EndFunction

Function BuildAndProcessReferences(FormList akFilter)
  ObjectReference[] LootArray = PlayerRef.FindAllReferencesOfType(akFilter, Radius.GetValue())

  Int i = 0

  While i < LootArray.Length
    If PlayerRef.HasPerk(ActivePerk) && IsPlayerControlled()
      ObjectReference kObject = LootArray[i]

      If kObject && !SafeHasForm(QuestItems, kObject) && ItemCanBeProcessed(kObject)
        ObjectReference kContainer = kObject.GetContainer()

        If !kContainer && (kContainer != PlayerRef)
          TryLootObject(kObject)
        EndIf
      EndIf
    Else
      ; just try to start a new timer, no need to finish loop
      Return
    EndIf

    i += 1
  EndWhile
EndFunction

Function LootObject(ObjectReference objLoot)
  If bAllowStealing
    If !bStealingIsHostile && PlayerRef.WouldBeStealing(objLoot)
      objLoot.SetActorRefOwner(PlayerRef)
    EndIf
  EndIf

  If objLoot.GetBaseObject() is Activator
    Log("LootObject", "Trying to activate: " + objLoot)
    objLoot.Activate(DummyActor, True)
  Else
    objLoot.Activate(DummyActor, False)
  EndIf
EndFunction

Function TryLootObject(ObjectReference akObject)
  ; add only owned items when Auto Steal is enabled and mode is set to Owned Only
  If bAllowStealing
    ; special logic for only owned option
    If bLootOnlyOwned
      ; loot only owned items
      If PlayerRef.WouldBeStealing(akObject)
        LootObject(akObject)
        Return
      Else
        ; don't loot unowned items
        Return
      EndIf
    EndIf

    ; otherwise, add all items when Auto Steal is enabled and mode is set to Owned and Unowned
    LootObject(akObject)
    Return
  EndIf

  ; loot only unowned items because Allow Stealing is off
  If !PlayerRef.WouldBeStealing(akObject)
    LootObject(akObject)
  EndIf
EndFunction

; -----------------------------------------------------------------------------
; VARIABLES
; -----------------------------------------------------------------------------

Bool bAllowStealing     = False
Bool bLootOnlyOwned     = False
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
