ScriptName AutoLoot:dubhAutoLootEffectBodiesScript Extends ActiveMagicEffect

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
	If !(akItem is Actor)
		Return False
	EndIf

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
	ObjectReference[] LootArray = None

	Int i = 0
	Bool bBreak = False

	While (i < akFilter.GetSize()) && !bBreak
		If !GameStateIsValid()
			bBreak = True
		EndIf

		If !bBreak
			LootArray = PlayerRef.FindAllReferencesWithKeyword(akFilter.GetAt(i), Radius.Value)

			If LootArray != None && LootArray.Length > 0
				LootArray = FilterLootArray(LootArray)
			EndIf

			If LootArray != None && LootArray.Length > 0
				Loot(LootArray)
			EndIf
		EndIf

		i += 1
	EndWhile

	If (LootArray == None) || (LootArray.Length == 0)
		Return
	EndIf

	LootArray.Clear()
EndFunction

; Iterate and Loot

Function Loot(ObjectReference[] akLootArray)
	If akLootArray.Length == 0
		Return
	EndIf

	Int i = 0
	Bool bBreak = False

	While (i < akLootArray.Length) && !bBreak
		If !GameStateIsValid()
			bBreak = True
		EndIf

		If !bBreak
			ObjectReference objLoot = akLootArray[i]

			If objLoot
				LootObject(objLoot)
			EndIf
		EndIf

		i += 1
	EndWhile

	akLootArray.Clear()
EndFunction

; Adds an object reference to the filtered loot array

Function AddObjectToObjectReferenceArray(ObjectReference akContainer, ObjectReference[] akArray)
	; exclude empty containers
	If akContainer is Actor
		If akContainer.GetItemCount(None) == 0
			Return
		EndIf
	EndIf

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
					Actor kActor = kItem as Actor

					If kActor && (kActor != PlayerRef)
						If kActor.IsDead()
							If AutoLoot_Setting_PlayerKillerOnly.Value == 1
								If kActor.GetKiller() == PlayerRef
									AddObjectToObjectReferenceArray(kItem, kResult)
									TryToDisableBody(kItem)
								EndIf
							Else
								AddObjectToObjectReferenceArray(kItem, kResult)
								TryToDisableBody(kItem)
							EndIf
						EndIf
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

	If AutoLoot_Setting_TakeAll.Value == 1
		objLoot.RemoveAllItems(DummyActor, AutoLoot_Setting_StealingIsHostile.Value)
	Else
		LootObjectByFilter(FilterAll, Perks, objLoot, DummyActor)
		LootObjectByTieredFilter(AutoLoot_Perk_Components, AutoLoot_Filter_Components, AutoLoot_Globals_Components, objLoot, DummyActor)
		LootObjectByTieredFilter(AutoLoot_Perk_Valuables, AutoLoot_Filter_Valuables, AutoLoot_Globals_Valuables, objLoot, DummyActor)
		LootObjectByTieredFilter(AutoLoot_Perk_Weapons, AutoLoot_Filter_Weapons, AutoLoot_Globals_Weapons, objLoot, DummyActor)
	EndIf

	TryToDisableBody(objLoot)
EndFunction

; Loot specific items using active filters - excludes bodies and containers filters

Bool Function LootObjectByFilter(FormList akFilters, FormList akPerks, ObjectReference akContainer, ObjectReference akOtherContainer)
	Int i = 0
	Bool bBreak = False

	While (i < akFilters.GetSize()) && !bBreak
		If !GameStateIsValid()
			bBreak = True
		EndIf

		If !bBreak && i != 2  ; skip AutoLoot_Perk_Components/AutoLoot_Filter_Components
			If PlayerRef.HasPerk(akPerks.GetAt(i) as Perk)
				akContainer.RemoveItem(akFilters.GetAt(i) as FormList, -1, True, akOtherContainer)
			EndIf
		EndIf

		i += 1
	EndWhile
EndFunction

; Loot specific items using active special filters

Function LootObjectByTieredFilter(Perk akPerk, FormList akFilter, FormList akGlobals, ObjectReference akContainer, ObjectReference akOtherContainer)
	If !PlayerRef.HasPerk(akPerk)
		Return
	EndIf

	Int i = 0
	Bool bBreak = False

	While (i < akFilter.GetSize()) && !bBreak
		If !GameStateIsValid()
			bBreak = True
		EndIf

		If !bBreak
			If (akGlobals.GetAt(i) as GlobalVariable).Value == 1
				akContainer.RemoveItem(akFilter.GetAt(i) as FormList, -1, True, akOtherContainer)
			EndIf
		EndIf

		i += 1
	EndWhile
EndFunction

; Disables the container when container is empty

Function TryToDisableBody(ObjectReference akContainer)
	If AutoLoot_Setting_RemoveBodiesOnLoot.Value == 0
		Return
	EndIf

	If akContainer.GetItemCount(None) > 0
		Return
	EndIf

	akContainer.DisableNoWait()
	akContainer.Delete()
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
	FormList Property FilterAll Auto Mandatory
	FormList Property QuestItems Auto Mandatory
	FormList Property AutoLoot_Filter_Components Auto Mandatory
	FormList Property AutoLoot_Filter_Valuables Auto Mandatory
	FormList Property AutoLoot_Filter_Weapons Auto Mandatory
	FormList Property AutoLoot_Globals_Components Auto Mandatory
	FormList Property AutoLoot_Globals_Valuables Auto Mandatory
	FormList Property AutoLoot_Globals_Weapons Auto Mandatory
	FormList Property Locations Auto Mandatory
	FormList Property Perks Auto Mandatory
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
