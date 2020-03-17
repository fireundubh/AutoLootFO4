;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
ScriptName AutoLoot:Fragments:Terminals:TERM_AutoLoot_301_04001150 Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Components Filter (disabled)
; ---------------------------------------------------------------------
PlayerRef.AddPerk(AutoLoot_Perk_Components)

If PlayerRef.HasPerk(AutoLoot_Perk_Valuables)
	PlayerRef.RemovePerk(AutoLoot_Perk_Valuables)
EndIf

If PlayerRef.HasPerk(AutoLoot_Perk_Junk)
	PlayerRef.RemovePerk(AutoLoot_Perk_Junk)
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_02
Function Fragment_Terminal_02(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Components Filter (enabled)
; ---------------------------------------------------------------------
PlayerRef.RemovePerk(AutoLoot_Perk_Components)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_04
Function Fragment_Terminal_04(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Junk Filter (disabled)
; ---------------------------------------------------------------------
PlayerRef.AddPerk(AutoLoot_Perk_Junk)

If PlayerRef.HasPerk(AutoLoot_Perk_Components)
	PlayerRef.RemovePerk(AutoLoot_Perk_Components)
EndIf

If PlayerRef.HasPerk(AutoLoot_Perk_Valuables)
	PlayerRef.RemovePerk(AutoLoot_Perk_Valuables)
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_05
Function Fragment_Terminal_05(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Junk Filter (enabled)
; ---------------------------------------------------------------------
PlayerRef.RemovePerk(AutoLoot_Perk_Junk)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_06
Function Fragment_Terminal_06(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Valuables Filter (disabled)
; ---------------------------------------------------------------------
PlayerRef.AddPerk(AutoLoot_Perk_Valuables)

If PlayerRef.HasPerk(AutoLoot_Perk_Components)
	PlayerRef.RemovePerk(AutoLoot_Perk_Components)
EndIf

If PlayerRef.HasPerk(AutoLoot_Perk_Junk)
	PlayerRef.RemovePerk(AutoLoot_Perk_Junk)
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_07
Function Fragment_Terminal_07(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Valuables Filter (enabled)
; ---------------------------------------------------------------------
PlayerRef.RemovePerk(AutoLoot_Perk_Valuables)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Actor Property PlayerRef Auto Const
Perk Property AutoLoot_Perk_Components Auto Const
Perk Property AutoLoot_Perk_Junk Auto Const
Perk Property AutoLoot_Perk_Valuables Auto Const
