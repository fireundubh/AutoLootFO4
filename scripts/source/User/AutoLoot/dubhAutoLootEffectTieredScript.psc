ScriptName AutoLoot:dubhAutoLootEffectTieredScript Extends ActiveMagicEffect

; -----------------------------------------------------------------------------
; EVENTS
; -----------------------------------------------------------------------------

Event OnEffectStart(Actor akTarget, Actor akCaster)
	StartTimer(Delay.Value as Int, TimerID)
EndEvent

Event OnTimer(Int aiTimerID)
	If PlayerRef.HasPerk(ActivePerk)
		If GameStateIsValid()
			Int i = 0
			Bool bBreak = False

			While (i < Filter_Globals.GetSize()) && !bBreak
				If !GameStateIsValid()
					bBreak = True
				EndIf

				If !bBreak
					If (Filter_Globals.GetAt(i) as GlobalVariable).Value == 1
						BuildAndProcessReferences(Filter.GetAt(i) as FormList)
					EndIf
				EndIf

				i += 1
			EndWhile
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

; Returns true if loot in location can be processed

Bool Function LocationCanBeLooted(ObjectReference akItem)
	If AutoLoot_Setting_LootSettlements.Value == 1
		Return True
	EndIf

	Return !Locations.HasForm(akItem.GetCurrentLocation())
EndFunction

; Return true if all conditions are met

Bool Function ItemCanBeProcessed(ObjectReference akItem)
	Return akItem.Is3DLoaded() && !akItem.IsDisabled() && !akItem.IsDeleted() && !akItem.IsDestroyed() && !akItem.IsActivationBlocked() && LocationCanBeLooted(akItem)
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

			If objLoot != None
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

	If !PlayerRef.WouldBeStealing(akContainer)
		akArray.Add(akContainer, 1)
	EndIf
EndFunction

ObjectReference[] Function FilterLootArray(ObjectReference[] akArray)
	ObjectReference[] kResult = new ObjectReference[0]

	If akArray.Length > 0
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
	EndIf

	Return kResult
EndFunction

; Loot Object

Function LootObject(ObjectReference objLoot)
	If (objLoot != None) && (DummyActor != None)
		If (AutoLoot_Setting_AllowStealing.Value == 1) && (AutoLoot_Setting_StealingIsHostile.Value == 0)
			If PlayerRef.WouldBeStealing(objLoot)
				objLoot.SetActorRefOwner(PlayerRef)
			EndIf
		EndIf

		objLoot.Activate(DummyActor, False)
	EndIf
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
