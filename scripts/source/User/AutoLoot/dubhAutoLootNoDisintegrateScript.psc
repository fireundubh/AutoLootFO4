ScriptName AutoLoot:dubhAutoLootNoDisintegrateScript Extends ActiveMagicEffect

; -----------------------------------------------------------------------------
; EVENTS
; -----------------------------------------------------------------------------

Event OnEffectStart(Actor akTarget, Actor akCaster)
	StartTimer(0, TimerID)
EndEvent

Event OnTimer(Int aiTimerID)
	If PlayerRef.HasPerk(ActivePerk)
		If GameStateIsValid()
			BuildAndProcessReferences(Filter)
		EndIf

		StartTimer(0, TimerID)
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

; Build and process references

Function BuildAndProcessReferences(FormList akKeywords)
	ObjectReference[] ActorArray = None

	Int i = 0
	Bool bBreak = False

	While (i < akKeywords.GetSize()) && !bBreak
		If !GameStateIsValid()
			bBreak = True
		EndIf

		If !bBreak
			ActorArray = PlayerRef.FindAllReferencesWithKeyword(akKeywords.GetAt(i), 4096.0)

			If ActorArray && ActorArray.Length > 0
				AddKeywordToActorsInArray(NoDisintegrate, ActorArray)
			EndIf
		EndIf

		i += 1
	EndWhile

	If (ActorArray == None) || (ActorArray.Length == 0)
		Return
	EndIf

	ActorArray.Clear()
EndFunction

; Add a keyword to all valid actors in the array

Function AddKeywordToActorsInArray(Keyword akKeyword, ObjectReference[] akArray)
	Int i = 0
	Bool bBreak = False

	While (i < akArray.Length) && !bBreak
		If !GameStateIsValid()
			bBreak = True
		EndIf

		If !bBreak
			ObjectReference kActor = akArray[i]

			If kActor && (kActor != PlayerRef)
				Actor kActorRef = kActor as Actor

				If !kActorRef.IsEssential() && !(kActorRef.GetBaseObject() as ActorBase).IsProtected() && !kActorRef.HasKeyword(akKeyword)
					kActorRef.AddKeyword(akKeyword)
				EndIf
			EndIf
		EndIf

		i += 1
	EndWhile
EndFunction

; -----------------------------------------------------------------------------
; PROPERTIES
; -----------------------------------------------------------------------------

Group Actors
	Actor Property PlayerRef Auto Mandatory
EndGroup

Group Forms
	FormList Property Filter Auto Mandatory
	Keyword Property NoDisintegrate Auto Mandatory
EndGroup

Group Timer
	Int Property TimerID Auto Mandatory
EndGroup

Group Perks
	Perk Property ActivePerk Auto Mandatory
EndGroup
