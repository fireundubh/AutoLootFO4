ScriptName AutoLoot:dubhAutoLootUtilityScript


Bool Function IsPlayerControlled() Global
  Return !Utility.IsInMenuMode() && Game.IsMovementControlsEnabled() && !Game.IsVATSPlaybackActive()
EndFunction


Bool Function IsObjectInteractable(ObjectReference akRef) Global
  Return akRef.Is3DLoaded() && !akRef.IsDisabled() && !akRef.IsDeleted() && !akRef.IsDestroyed() && !akRef.IsActivationBlocked()
EndFunction


Bool Function IntToBool(GlobalVariable akGlobalVariable) Global
  Return akGlobalVariable.GetValue() as Int == 1
EndFunction


Bool Function SafeHasForm(FormList akFormList, Form akForm) Global
  If akForm is Actor
    akForm = (akForm as Actor).GetLeveledActorBase() as Form
  EndIf

  Return akFormList.GetSize() > 0 && akFormList.HasForm(akForm)
EndFunction


Function AddObjectToArray(ObjectReference[] akArray, ObjectReference akContainer, Actor akPlayerRef, Bool abAllowStealing, Bool abLootOnlyOwned) Global
  ; add only owned items when Auto Steal is enabled and mode is set to Owned Only
  If abAllowStealing
    ; special logic for only owned option
    If abLootOnlyOwned
      ; loot only owned items
      If akPlayerRef.WouldBeStealing(akContainer)
        akArray.Add(akContainer, 1)
        Return
      Else
        ; don't loot unowned items
        Return
      EndIf
    EndIf

    ; otherwise, add all items when Auto Steal is enabled and mode is set to Owned and Unowned
    akArray.Add(akContainer, 1)
    Return
  EndIf

  ; loot only unowned items because Allow Stealing is off
  If !akPlayerRef.WouldBeStealing(akContainer)
    akArray.Add(akContainer, 1)
  EndIf
EndFunction
