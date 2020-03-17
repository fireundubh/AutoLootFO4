ScriptName AutoLoot:dubhAutoLootQuestScript Extends Quest

; -----------------------------------------------------------------------------
; EVENTS
; -----------------------------------------------------------------------------

Event OnQuestInit()
	Self.RegisterForRemoteEvent(PlayerRef, "OnPlayerLoadGame")

	If MQ101.IsCompleted() == True
		TryToAddEssentials()
	Else
		RegisterForRemoteEvent(MQ102, "OnStageSet")
	EndIf
EndEvent

Event Quest.OnStageSet(Quest akSender, Int auiStageID, Int auiItemID)
	; v111 elevator exit radios on
	If akSender == MQ102 && auiStageID == 15
		UnRegisterForRemoteEvent(MQ102, "OnStageSet")

		TryToAddEssentials()
	Endif
EndEvent

Event Actor.OnPlayerLoadGame(Actor akSender)
	TryToAddEssentials()
EndEvent

; -----------------------------------------------------------------------------
; FUNCTIONS
; -----------------------------------------------------------------------------

Function TryToAddEssentials()
	If PlayerRef.GetItemCount(AutoLoot_Holotape) == 0
		PlayerRef.AddItem(AutoLoot_Holotape, 1, False)
	EndIf

	If AutoLoot_Setting_NoDisintegrate.Value == 1
		If !PlayerRef.HasPerk(AutoLoot_Perk_NoDisintegrate)
			PlayerRef.AddPerk(AutoLoot_Perk_NoDisintegrate)
		EndIf
	EndIf
EndFunction

; -----------------------------------------------------------------------------
; PROPERTIES
; -----------------------------------------------------------------------------

Group Actors
	Actor Property PlayerRef Auto Mandatory
EndGroup

Group Forms
	Form Property AutoLoot_Holotape Auto Mandatory
EndGroup

Group Globals
	GlobalVariable Property AutoLoot_Setting_NoDisintegrate Auto Mandatory
EndGroup

Group Quests
	Quest Property MQ101 Auto Const Mandatory
	Quest Property MQ102 Auto Const Mandatory
EndGroup

Group Perks
	Perk Property AutoLoot_Perk_NoDisintegrate Auto Const Mandatory
EndGroup
