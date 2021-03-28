ScriptName AutoLoot:dubhAutoLootEffectComponentsScript Extends ActiveMagicEffect

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
  Debug.TraceUser("AutoLoot", "dubhAutoLootEffectComponentsScript> " + AText, ASeverity)
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

  MiscObject Item = AObject.GetBaseObject() as MiscObject

  Return ItemHasLootableComponent(Item)
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
          ObjectReference ItemContainer = Item.GetContainer()

          If !ItemContainer && (ItemContainer != PlayerRef)
            AddObjectToObjectReferenceArray(Item, Result)
          EndIf
        EndIf
      EndIf
    EndIf

    i += 1
  EndWhile

  Return Result
EndFunction

Bool Function ItemHasLootableComponent(MiscObject AObject)
  Int i = 0
  Bool bContinue = True

  ; Loop through global formlist
  While (i < AutoLoot_Globals_Components.GetSize()) && bContinue
    bContinue = PlayerRef.HasPerk(ActivePerk) && IsPlayerControlled()

    If bContinue
      ; If the component is preferred, and akItem has that component, return True
      If IntToBool(AutoLoot_Globals_Components.GetAt(i) as GlobalVariable)
        Component Item = AutoLoot_Filter_Components.GetAt(i) as Component

        If AObject.GetObjectComponentCount(Item) > 0
          Return True
        EndIf
      EndIf
    EndIf

    i += 1
  EndWhile

  Return False
EndFunction

Function LootObject(ObjectReference AObject)
  If (AObject == None) || (DummyActor == None)
    Return
  EndIf

  If IntToBool(AutoLoot_Setting_AllowStealing)
    If !IntToBool(AutoLoot_Setting_StealingIsHostile) && PlayerRef.WouldBeStealing(AObject)
      AObject.SetActorRefOwner(PlayerRef)
    EndIf
  EndIf

  AObject.Activate(DummyActor, False)
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
  FormList Property QuestItems Auto Mandatory
  FormList Property AutoLoot_Filter_Components Auto Mandatory
  FormList Property AutoLoot_Globals_Components Auto Mandatory
  FormList Property Locations Auto Mandatory
EndGroup

Group Globals
  GlobalVariable Property Destination Auto Mandatory
  GlobalVariable Property Delay Auto Mandatory
  GlobalVariable Property Radius Auto Mandatory
  GlobalVariable Property AutoLoot_Setting_AllowStealing Auto Mandatory
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
