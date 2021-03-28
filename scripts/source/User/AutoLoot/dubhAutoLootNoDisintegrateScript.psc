ScriptName AutoLoot:dubhAutoLootNoDisintegrateScript Extends ActiveMagicEffect

Import AutoLoot:dubhAutoLootUtilityScript

; -----------------------------------------------------------------------------
; EVENTS
; -----------------------------------------------------------------------------

Event OnEffectStart(Actor akTarget, Actor akCaster)
	StartTimer(0, TimerID)
EndEvent

Event OnTimer(Int aiTimerID)
	If PlayerRef.HasPerk(ActivePerk)
	  If IsPlayerControlled()
		  BuildAndProcessReferences(Filter)
	  EndIf

	  StartTimer(0, TimerID)
	EndIf
EndEvent

; -----------------------------------------------------------------------------
; FUNCTIONS
; -----------------------------------------------------------------------------

Function BuildAndProcessReferences(FormList AKeywords)
	ObjectReference[] Actors = None

	Int i = 0
	Bool bContinue = True

	While (i < AKeywords.GetSize()) && bContinue
	  bContinue = PlayerRef.HasPerk(ActivePerk) && IsPlayerControlled()

		If bContinue
			Actors = PlayerRef.FindAllReferencesWithKeyword(AKeywords.GetAt(i), 4096.0)

			If Actors && Actors.Length > 0
				AddKeywordToActorsInArray(NoDisintegrate, Actors)
			EndIf
		EndIf

		i += 1
	EndWhile
EndFunction

Function AddKeywordToActorsInArray(Keyword AKeyword, ObjectReference[] AActors)
	Int i = 0
	Bool bContinue = True

	While (i < AActors.Length) && bContinue
		bContinue = PlayerRef.HasPerk(ActivePerk) && IsPlayerControlled()

		If bContinue
			ObjectReference NPC = AActors[i] as ObjectReference

			If NPC && (NPC != PlayerRef)
				Actor ActorRef = NPC as Actor

				If !ActorRef.IsEssential() && !(ActorRef.GetBaseObject() as ActorBase).IsProtected() && !ActorRef.HasKeyword(AKeyword)
					ActorRef.AddKeyword(AKeyword)
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
