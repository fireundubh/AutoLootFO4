;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
ScriptName AutoLoot:Fragments:Terminals:TERM_AutoLoot_401_Rules_0400104A Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		All (send to player)
; ---------------------------------------------------------------------
Int i = 0
While i < AutoLoot_Globals_PlayerOnly.Length
	AutoLoot_Globals_PlayerOnly[i].SetValue(0)
	i += 1
EndWhile
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_02
Function Fragment_Terminal_02(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		All (send to workshop)
; ---------------------------------------------------------------------
Int i = 0
While i < AutoLoot_Globals_PlayerOnly.Length
	AutoLoot_Globals_PlayerOnly[i].SetValue(1)
	i += 1
EndWhile
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_03
Function Fragment_Terminal_03(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Ammo (send to player)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[1].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_04
Function Fragment_Terminal_04(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Ammo (send to workshop)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[1].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_05
Function Fragment_Terminal_05(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Armor (send to player)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[2].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_06
Function Fragment_Terminal_06(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Armor (send to workshop)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[2].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_07
Function Fragment_Terminal_07(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Bodies (send to player)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[3].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_08
Function Fragment_Terminal_08(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Bodies (send to workshop)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[3].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_09
Function Fragment_Terminal_09(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Components (send to player)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[4].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_10
Function Fragment_Terminal_10(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Components (send to workshop)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[4].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_11
Function Fragment_Terminal_11(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Containers (send to player)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[5].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_12
Function Fragment_Terminal_12(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Containers (send to workshop)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[5].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_13
Function Fragment_Terminal_13(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Currency (send to player)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[6].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_14
Function Fragment_Terminal_14(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Currency (send to workshop)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[6].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_15
Function Fragment_Terminal_15(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Drink (send to player)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[7].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_16
Function Fragment_Terminal_16(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Drink (send to workshop)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[7].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_17
Function Fragment_Terminal_17(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Flora (send to player)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[8].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_18
Function Fragment_Terminal_18(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Flora (send to workshop)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[8].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_19
Function Fragment_Terminal_19(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Food (send to player)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[9].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_20
Function Fragment_Terminal_20(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Food (send to workshop)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[9].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_21
Function Fragment_Terminal_21(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Holotapes (send to player)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[10].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_22
Function Fragment_Terminal_22(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Holotapes (send to workshop)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[10].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_23
Function Fragment_Terminal_23(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Junk (send to player)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[11].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_24
Function Fragment_Terminal_24(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Junk (send to workshop)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[11].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_25
Function Fragment_Terminal_25(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Keys (send to player)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[12].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_26
Function Fragment_Terminal_26(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Keys (send to workshop)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[12].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_27
Function Fragment_Terminal_27(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Magazines (send to player)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[13].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_28
Function Fragment_Terminal_28(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Magazines (send to workshop)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[13].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_29
Function Fragment_Terminal_29(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Meds (send to player)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[14].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_30
Function Fragment_Terminal_30(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Meds (send to workshop)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[14].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_31
Function Fragment_Terminal_31(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Valuables (send to player)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[15].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_32
Function Fragment_Terminal_32(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Valuables (send to workshop)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[15].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_33
Function Fragment_Terminal_33(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Weapons (send to player)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[16].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_34
Function Fragment_Terminal_34(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Weapons (send to workshop)
; ---------------------------------------------------------------------
AutoLoot_Globals_PlayerOnly[16].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable[] Property AutoLoot_Globals_PlayerOnly Auto Const
