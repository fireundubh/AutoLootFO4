;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
ScriptName AutoLoot:Fragments:Terminals:TERM_AutoLoot_601_Debug_0400104C Extends Terminal Hidden Const

;BEGIN FRAGMENT Fragment_Terminal_01
Function Fragment_Terminal_01(ObjectReference akTerminalRef)
;BEGIN CODE
  ; ---------------------------------------------------------------------
  ; [ITXT]		Flush dummies
  ; ---------------------------------------------------------------------
  Int i = 0

  While i < AutoLoot_Dummies.GetSize()
    Actor kDummy = AutoLoot_Dummies.GetAt(i) as Actor

    If kDummy
      If AutoLoot_Setting_AllowStealing.GetValue() as Int == 1
        kDummy.RemoveAllItems(PlayerRef, (AutoLoot_Setting_StealingIsHostile.GetValue() as Int) as Bool)
      Else
        kDummy.RemoveAllItems(PlayerRef, False)
      EndIf
    EndIf

    i += 1
  EndWhile
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_Terminal_02
Function Fragment_Terminal_02(ObjectReference akTerminalRef)
;BEGIN CODE
  ; ---------------------------------------------------------------------
  ; [ITXT]		Uninstall
  ; ---------------------------------------------------------------------
  Int i = 0

  While i < Perks.Length
    If PlayerRef.HasPerk(Perks[i])
      PlayerRef.RemovePerk(Perks[i])
    EndIf

    i += 1
  EndWhile

  If HolotapeQuest.IsRunning() || HolotapeQuest.IsStarting() || HolotapeQuest.IsStopping()
    HolotapeQuest.Stop()
  EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Actor Property PlayerRef Auto Const
FormList Property AutoLoot_Dummies Auto Const
GlobalVariable Property AutoLoot_Setting_AllowStealing Auto Const
GlobalVariable Property AutoLoot_Setting_StealingIsHostile Auto Const
Perk[] Property Perks Auto Const
Quest Property HolotapeQuest Auto Const