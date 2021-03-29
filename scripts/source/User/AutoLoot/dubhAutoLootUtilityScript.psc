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

Function LootObjectByPerk(Actor APlayer, Perk[] APerks, FormList[] AFilters, ObjectReference AContainer, ObjectReference AOtherContainer) Global
  Int i = 0

  While i < APerks.Length
    If APlayer.HasPerk(APerks[i])
      AContainer.RemoveItem(AFilters[i], -1, True, AOtherContainer)
    EndIf

    i += 1
  EndWhile
EndFunction

Function LootObjectByComponent(GlobalVariable[] AGlobals, Component[] AFilter, ObjectReference AContainer, ObjectReference AOtherContainer) Global
  Int i = 0

  While i < AFilter.Length
    If IntToBool(AGlobals[i])
      AContainer.RemoveItem(AFilter[i], -1, True, AOtherContainer)
    EndIf

    i += 1
  EndWhile
EndFunction

Function LootObjectByFormList(GlobalVariable[] AGlobals, FormList[] AFilter, ObjectReference AContainer, ObjectReference AOtherContainer) Global
  Int i = 0

  While i < AFilter.Length
    If IntToBool(AGlobals[i])
      AContainer.RemoveItem(AFilter[i], -1, True, AOtherContainer)
    EndIf

    i += 1
  EndWhile
EndFunction
