ScriptName AutoLoot:dubhAutoLootEffectComponentsScript Extends ActiveMagicEffect

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

	MiscObject akMisc = akItem.GetBaseObject() as MiscObject

	Return ItemHasLootableComponent(akMisc)
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
	If QuestItems.GetSize() > 0
		If QuestItems.HasForm(akContainer)
			Return
		EndIf
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

	; finally, add only unowned items if the above conditions are not met
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
					ObjectReference kContainer = kItem.GetContainer()

					If !kContainer && (kContainer != PlayerRef)
						AddObjectToObjectReferenceArray(kItem, kResult)
					EndIf
				EndIf
			EndIf
		EndIf

		i += 1
	EndWhile

	Return kResult
EndFunction

; Returns item if item has a lootable component, or None if not

Bool Function ItemHasLootableComponent(MiscObject akItem)
	Int i = 0
	Bool bBreak = False

	; Loop through global formlist
	While (i < AutoLoot_Globals_Components.GetSize()) && !bBreak
		If !GameStateIsValid()
			bBreak = True
		EndIf

		If !bBreak
			GlobalVariable componentState = AutoLoot_Globals_Components.GetAt(i) as GlobalVariable

			; If the component is preferred, and akItem has that component, return True
			If componentState.Value == 1
				Component cmpo = AutoLoot_Filter_Components.GetAt(i) as Component

				If akItem.GetObjectComponentCount(cmpo) > 0
					Return True
				EndIf
			EndIf
		EndIf

		i += 1
	EndWhile

	Return False
EndFunction

; Loot Object

Function LootObject(ObjectReference objLoot)
	If objLoot == None || DummyActor == None
		Return
	EndIf

	If PlayerRef.WouldBeStealing(objLoot)
		If (AutoLoot_Setting_AllowStealing.Value == 1) && (AutoLoot_Setting_StealingIsHostile.Value == 0)
			objLoot.SetActorRefOwner(PlayerRef)
		EndIf
	EndIf

	objLoot.Activate(DummyActor, False)
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
