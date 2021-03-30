;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
ScriptName AutoLoot:Fragments:Terminals:TERM_AutoLoot_100_04000FFC Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		---- Pause ----
; ---------------------------------------------------------------------
AutoLoot_Setting_PauseLooting.SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_02
Function Fragment_Terminal_02(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		---- Resume ----
; ---------------------------------------------------------------------
AutoLoot_Setting_PauseLooting.SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property AutoLoot_Setting_PauseLooting Auto Const