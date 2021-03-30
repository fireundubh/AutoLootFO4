;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
ScriptName AutoLoot:Fragments:Terminals:TERM_AutoLoot_310_04001109 Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Acid (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[0].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_02
Function Fragment_Terminal_02(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Acid (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[0].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_03
Function Fragment_Terminal_03(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Adhesive (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[1].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_04
Function Fragment_Terminal_04(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Adhesive (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[1].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_05
Function Fragment_Terminal_05(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Aluminum (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[2].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_06
Function Fragment_Terminal_06(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Aluminum (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[2].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_07
Function Fragment_Terminal_07(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Antiseptic (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[3].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_08
Function Fragment_Terminal_08(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Antiseptic (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[3].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_09
Function Fragment_Terminal_09(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Asbestos (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[4].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_10
Function Fragment_Terminal_10(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Asbestos (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[4].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_11
Function Fragment_Terminal_11(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Ballistic Fiber (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[5].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_12
Function Fragment_Terminal_12(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Ballistic Fiber (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[5].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_13
Function Fragment_Terminal_13(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Bone (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[6].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_14
Function Fragment_Terminal_14(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Bone (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[6].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_15
Function Fragment_Terminal_15(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Ceramic (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[7].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_16
Function Fragment_Terminal_16(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Ceramic (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[7].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_17
Function Fragment_Terminal_17(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Circuitry (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[8].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_18
Function Fragment_Terminal_18(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Circuitry (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[8].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_19
Function Fragment_Terminal_19(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Cloth (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[9].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_20
Function Fragment_Terminal_20(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Cloth (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[9].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_21
Function Fragment_Terminal_21(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Concrete (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[10].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_22
Function Fragment_Terminal_22(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Concrete (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[10].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_23
Function Fragment_Terminal_23(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Copper (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[11].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_24
Function Fragment_Terminal_24(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Copper (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[11].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_25
Function Fragment_Terminal_25(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Cork (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[12].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_26
Function Fragment_Terminal_26(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Cork (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[12].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_27
Function Fragment_Terminal_27(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Crystal (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[13].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_28
Function Fragment_Terminal_28(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Crystal (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[13].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_29
Function Fragment_Terminal_29(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Fertilizer (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[14].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_30
Function Fragment_Terminal_30(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Fertilizer (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[14].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_31
Function Fragment_Terminal_31(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Fiber Optics (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[15].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_32
Function Fragment_Terminal_32(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Fiber Optics (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[15].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_33
Function Fragment_Terminal_33(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Fiberglass (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[16].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_34
Function Fragment_Terminal_34(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Fiberglass (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[16].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_35
Function Fragment_Terminal_35(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Gears (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[17].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_36
Function Fragment_Terminal_36(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Gears (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[17].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_37
Function Fragment_Terminal_37(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Glass (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[18].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_38
Function Fragment_Terminal_38(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Glass (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[18].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_39
Function Fragment_Terminal_39(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Gold (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[19].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_40
Function Fragment_Terminal_40(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Gold (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[19].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_41
Function Fragment_Terminal_41(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Lead (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[20].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_42
Function Fragment_Terminal_42(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Lead (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[20].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_43
Function Fragment_Terminal_43(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Leather (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[21].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_44
Function Fragment_Terminal_44(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Leather (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[21].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_45
Function Fragment_Terminal_45(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Nuclear Material (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[22].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_46
Function Fragment_Terminal_46(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Nuclear Material (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[22].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_47
Function Fragment_Terminal_47(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Oil (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[23].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_48
Function Fragment_Terminal_48(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Oil (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[23].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_49
Function Fragment_Terminal_49(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Plastic (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[24].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_50
Function Fragment_Terminal_50(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Plastic (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[24].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_51
Function Fragment_Terminal_51(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Rubber (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[25].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_52
Function Fragment_Terminal_52(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Rubber (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[25].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_53
Function Fragment_Terminal_53(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Screws (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[26].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_54
Function Fragment_Terminal_54(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Screws (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[26].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_55
Function Fragment_Terminal_55(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Silver (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[27].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_56
Function Fragment_Terminal_56(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Silver (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[27].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_57
Function Fragment_Terminal_57(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Springs (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[28].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_58
Function Fragment_Terminal_58(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Springs (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[28].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_59
Function Fragment_Terminal_59(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Steel (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[29].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_60
Function Fragment_Terminal_60(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Steel (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[29].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_61
Function Fragment_Terminal_61(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Wood (disabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[30].SetValue(1)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_62
Function Fragment_Terminal_62(ObjectReference akTerminalRef)
;BEGIN CODE
; ---------------------------------------------------------------------
; [ITXT]		Wood (enabled)
; ---------------------------------------------------------------------
AutoLoot_Globals_Components[30].SetValue(0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable[] Property AutoLoot_Globals_Components Auto Const
