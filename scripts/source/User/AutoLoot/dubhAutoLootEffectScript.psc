ScriptName AutoLoot:dubhAutoLootEffectScript Extends ActiveMagicEffect

; -----------------------------------------------------------------------------
; EVENTS
; -----------------------------------------------------------------------------

Event OnEffectStart(Actor akTarget, Actor akCaster)
	StartTimer(Delay.Value as Int, TimerID)
EndEvent

Event OnTimer(Int aiTimerID)
	If PlayerRef.HasPerk(ActivePerk)
		If GameStateIsValid()
			BuildAndProcessReferences(Filter)
		EndIf

		StartTimer(Delay.Value as Int, TimerID)
	EndIf
EndEvent

; -----------------------------------------------------------------------------
; FUNCTIONS
; -----------------------------------------------------------------------------

; Log

Function Log(String asFunction = "", String asMessage = "") DebugOnly
	Debug.TraceSelf(Self, asFunction, asMessage)
EndFunction

; Return true if any exit condition met

Bool Function GameStateIsValid()
	Return PlayerRef.HasPerk(ActivePerk) && !Utility.IsInMenuMode() && Game.IsMovementControlsEnabled() && !Game.IsVATSPlaybackActive()
EndFunction

; Return true if all conditions are met

Bool Function ItemCanBeProcessed(ObjectReference akItem)
	If !(akItem.Is3DLoaded() && !akItem.IsDisabled() && !akItem.IsDeleted() && !akItem.IsDestroyed() && !akItem.IsActivationBlocked())
		Return False
	EndIf

	If AutoLoot_Setting_LootSettlements.Value == 0
		If Locations.HasForm(akItem.GetCurrentLocation())
			Return False
		EndIf
	EndIf

	Return True
EndFunction

; Build and process references

Function BuildAndProcessReferences(FormList akFilter)
	ObjectReference[] LootArray = PlayerRef.FindAllReferencesOfType(akFilter, Radius.Value)

	If (LootArray == None) || (LootArray.Length == 0)
		Return
	EndIf

	LootArray = FilterLootArray(LootArray)

	If (LootArray == None) || (LootArray.Length == 0)
		Return
	EndIf

	Int i = 0
	Bool bBreak = False

	While (i < LootArray.Length) && !bBreak
		If !GameStateIsValid()
			bBreak = True
		EndIf

		If !bBreak
			ObjectReference objLoot = LootArray[i]

			If objLoot
				Log("BuildAndProcessReferences", "Trying to loot: " + objLoot)
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
	; exclude quest items that are explicitly excluded
	If IsQuestItem(akContainer)
		Return
	EndIf

	; add only owned items when Auto Steal is enabled and mode is set to Owned Only
  If AutoLoot_Setting_AllowStealing.Value == 1 && AutoLoot_Setting_LootOnlyOwned.Value == 1
  	If PlayerRef.WouldBeStealing(akContainer)
  		akArray.Add(akContainer, 1)
  		Return
  	EndIf
  EndIf

	; add all items when Auto Steal is enabled and mode is set to Owned and Unowned
	If AutoLoot_Setting_AllowStealing.Value == 1
		akArray.Add(akContainer, 1)
		Return
	EndIf

	If !PlayerRef.WouldBeStealing(akContainer)
		akArray.Add(akContainer, 1)
	EndIf
EndFunction

ObjectReference[] Function FilterLootArray(ObjectReference[] akArray)
	ObjectReference[] kResult = new ObjectReference[0]

	If akArray.Length == 0
		Return kResult
	EndIf

	Int i = 0
	Bool bBreak = False

	While (i < akArray.Length) && !bBreak
		If kResult.Length >= 128
			bBreak = True
		EndIf

		If !bBreak && !GameStateIsValid()
			bBreak = True
		EndIf

		If !bBreak
			ObjectReference kItem = akArray[i]

			If kItem
				If ItemCanBeProcessed(kItem)
					Log("FilterLootArray", "Item can be processed: " + kItem)
					ObjectReference kContainer = kItem.GetContainer()

					If !kContainer && (kContainer != PlayerRef)
						Log("FilterLootArray", "Trying to add item to array: " + kItem)
						AddObjectToObjectReferenceArray(kItem, kResult)
					EndIf
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

	If (AutoLoot_Setting_AllowStealing.Value == 1) && (AutoLoot_Setting_StealingIsHostile.Value == 0)
		If PlayerRef.WouldBeStealing(objLoot)
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

; Check if item is in quest items formlist

Bool Function IsQuestItem(ObjectReference akObjectReference)
	If QuestItems.GetSize() == 0
		Return False
	EndIf

	If QuestItems.HasForm(akObjectReference)
		Return True
	EndIf

	Return False
EndFunction

; -----------------------------------------------------------------------------
; PROPERTIES
; -----------------------------------------------------------------------------

; Actor
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
