ScriptName AutoLoot:dubhAutoLootUtilityScript


Bool Function IsPlayerControlled() Global
  Return !Utility.IsInMenuMode() && Game.IsMovementControlsEnabled() && !Game.IsVATSPlaybackActive()
EndFunction

Bool Function IsObjectInteractable(ObjectReference AObject) Global
  Bool result = AObject.Is3DLoaded() && !AObject.IsDisabled() && !AObject.IsDeleted()

  ; Caps Stashes, Bottlecap Mine caps, Money Shot caps, and Bobby Pin Boxes are activation blocked on load
  Bool flag1 = True
  If !(AObject.GetBaseObject() is Activator || AObject.GetBaseObject() is MiscObject)
    flag1 = !AObject.IsActivationBlocked()
  EndIf

  ; some actors, like turrets, are destroyed when killed
  Bool flag2 = True
  If !(AObject.GetBaseObject() is Actor)
    flag2 = !AObject.IsDestroyed()
  EndIf

  Return result && flag1 && flag2
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

Int Function CountItems(ObjectReference AObject, FormList AExclusions) Global
  Int TotalItemCount = AObject.GetItemCount(None)

  If TotalItemCount == 0
    Return TotalItemCount
  EndIf

  Int NumExclusionsFound = AObject.GetItemCount(AExclusions)

  TotalItemCount -= NumExclusionsFound

  If TotalItemCount <= 0
    Return 0
  EndIf

  Return TotalItemCount
EndFunction
