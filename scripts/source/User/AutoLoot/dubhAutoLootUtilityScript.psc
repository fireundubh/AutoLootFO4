ScriptName AutoLoot:dubhAutoLootUtilityScript


Bool Function IsPlayerControlled() Global
  Return !Utility.IsInMenuMode() && Game.IsMovementControlsEnabled() && !Game.IsVATSPlaybackActive()
EndFunction

Bool Function IsObjectInteractable(ObjectReference AObject) Global
  Return AObject.Is3DLoaded() && !AObject.IsDisabled() && !AObject.IsDeleted() && !AObject.IsDestroyed() && !AObject.IsActivationBlocked()
EndFunction

Bool Function IntToBool(GlobalVariable AGlobalVariable) Global
  Return AGlobalVariable.GetValue() as Int == 1
EndFunction

Bool Function SafeHasForm(FormList AList, Form AForm) Global
  If AForm is Actor
    AForm = (AForm as Actor).GetLeveledActorBase() as Form
  EndIf

  Return AList.GetSize() > 0 && AList.HasForm(AForm)
EndFunction

Function AddObjectToArray(ObjectReference[] ALoot, ObjectReference AObject, Actor APlayer, Bool AAllowStealing, Bool ALootOnlyOwned) Global
  ; add only owned items when Auto Steal is enabled and mode is set to Owned Only
  If AAllowStealing
    ; special logic for only owned option
    If ALootOnlyOwned
      ; loot only owned items
      If APlayer.WouldBeStealing(AObject)
        ALoot.Add(AObject, 1)
        Return
      Else
        ; don't loot unowned items
        Return
      EndIf
    EndIf

    ; otherwise, add all items when Auto Steal is enabled and mode is set to Owned and Unowned
    ALoot.Add(AObject, 1)
    Return
  EndIf

  ; loot only unowned items because Allow Stealing is off
  If !APlayer.WouldBeStealing(AObject)
    ALoot.Add(AObject, 1)
  EndIf
EndFunction

Function LootObjectByPerk(Actor APlayer, Perk[] APerks, FormList[] AFilters, ObjectReference AContainer, ObjectReference AOtherContainer) Global
  Int i = 0

  While i < APerks.Length
    If APlayer.HasPerk(APerks[i])
      AContainer.RemoveItem(AFilters[i], -1, True, AOtherContainer)
    EndIf

    i += 1
  EndWhile
EndFunction

Function LootObjectByTieredFilter(FormList AGlobals, FormList AFilter, ObjectReference AContainer, ObjectReference AOtherContainer) Global
  Int i = 0

  While i < AFilter.GetSize()
    If IntToBool(AGlobals.GetAt(i) as GlobalVariable)
      AContainer.RemoveItem(AFilter.GetAt(i) as FormList, -1, True, AOtherContainer)
    EndIf

    i += 1
  EndWhile
EndFunction
