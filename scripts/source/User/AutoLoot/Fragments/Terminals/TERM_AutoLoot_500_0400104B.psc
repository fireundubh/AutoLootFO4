;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
ScriptName AutoLoot:Fragments:Terminals:TERM_AutoLoot_500_0400104B Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Auto Lockpick (disabled)
; ---------------------------------------------------------------------
AutoLoot_Setting_UnlockContainers.SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_02
Function Fragment_Terminal_02(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Auto Lockpick (enabled)
; ---------------------------------------------------------------------
AutoLoot_Setting_UnlockContainers.SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_03
Function Fragment_Terminal_03(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Auto Steal (disabled)
; ---------------------------------------------------------------------
AutoLoot_Setting_AllowStealing.SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_04
Function Fragment_Terminal_04(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Auto Steal (enabled)
; ---------------------------------------------------------------------
AutoLoot_Setting_AllowStealing.SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_05
Function Fragment_Terminal_05(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Auto Steal Mode (only owned)
; ---------------------------------------------------------------------
AutoLoot_Setting_LootOnlyOwned.SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_06
Function Fragment_Terminal_06(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Auto Steal Mode (owned and unowned)
; ---------------------------------------------------------------------
AutoLoot_Setting_LootOnlyOwned.SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_07
Function Fragment_Terminal_07(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Auto Steal Reaction (hostile)
; ---------------------------------------------------------------------
AutoLoot_Setting_StealingIsHostile.SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_08
Function Fragment_Terminal_08(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Auto Steal Reaction (none)
; ---------------------------------------------------------------------
AutoLoot_Setting_StealingIsHostile.SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property AutoLoot_Setting_AllowStealing Auto Const
GlobalVariable Property AutoLoot_Setting_LootOnlyOwned Auto Const
GlobalVariable Property AutoLoot_Setting_StealingIsHostile Auto Const
GlobalVariable Property AutoLoot_Setting_UnlockContainers Auto Const