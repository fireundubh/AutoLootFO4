;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
ScriptName AutoLoot:Fragments:Terminals:TERM_AutoLoot_600_Settings_0400104D Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Filter Mode (take all enabled)
; ---------------------------------------------------------------------
AutoLoot_Setting_TakeAll.SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_02
Function Fragment_Terminal_02(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Filter Mode (take any enabled)
; ---------------------------------------------------------------------
AutoLoot_Setting_TakeAll.SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_03
Function Fragment_Terminal_03(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Loot Notifications (disabled)
; ---------------------------------------------------------------------
AutoLoot_Setting_DisableNotifications.SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_04
Function Fragment_Terminal_04(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Loot Notifications (enabled)
; ---------------------------------------------------------------------
AutoLoot_Setting_DisableNotifications.SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_05
Function Fragment_Terminal_05(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Loot Settlements (disabled)
; ---------------------------------------------------------------------
AutoLoot_Setting_LootSettlements.SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_06
Function Fragment_Terminal_06(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Loot Settlements (enabled)
; ---------------------------------------------------------------------
AutoLoot_Setting_LootSettlements.SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_07
Function Fragment_Terminal_07(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Loot Only Actors Killed by Player (disabled)
; ---------------------------------------------------------------------
AutoLoot_Setting_PlayerKillerOnly.SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_08
Function Fragment_Terminal_08(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Loot Only Actors Killed by Player (enabled)
; ---------------------------------------------------------------------
AutoLoot_Setting_PlayerKillerOnly.SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_09
Function Fragment_Terminal_09(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		EXPERIMENTAL: Remove Bodies On Loot (disabled)
; ---------------------------------------------------------------------
AutoLoot_Setting_RemoveBodiesOnLoot.SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_10
Function Fragment_Terminal_10(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		EXPERIMENTAL: Remove Bodies On Loot (enabled)
; ---------------------------------------------------------------------
AutoLoot_Setting_RemoveBodiesOnLoot.SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property AutoLoot_Setting_DisableNotifications Auto Const
GlobalVariable Property AutoLoot_Setting_LootSettlements Auto Const
GlobalVariable Property AutoLoot_Setting_PlayerKillerOnly Auto Const
GlobalVariable Property AutoLoot_Setting_RemoveBodiesOnLoot Auto Const
GlobalVariable Property AutoLoot_Setting_TakeAll Auto Const