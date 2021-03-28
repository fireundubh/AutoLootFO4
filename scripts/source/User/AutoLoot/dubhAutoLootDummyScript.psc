ScriptName AutoLoot:dubhAutoLootDummyScript Extends Actor

; -----------------------------------------------------------------------------
; EVENTS
; -----------------------------------------------------------------------------

Event OnInit()
	AddInventoryEventFilter(None)
EndEvent

Event OnItemAdded(Form akBaseItem, Int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	ObjectReference kDestination = PlayerRef

	If PlayerOnly.GetValue() as Int == 0
		WorkshopScript kWorkshop = AutoLoot_Settlements.GetAt(Destination.GetValue() as Int) as WorkshopScript
		kDestination = kWorkshop
	EndIf

	Self.RemoveItem(akBaseItem, aiItemCount, Notifications.GetValue() as Bool, kDestination)
EndEvent

; -----------------------------------------------------------------------------
; PROPERTIES
; -----------------------------------------------------------------------------

Group Actors
	Actor Property PlayerRef Auto Mandatory
EndGroup

Group Forms
	FormList Property AutoLoot_Settlements Auto Mandatory
EndGroup

Group Globals
	GlobalVariable Property Destination Auto Mandatory
	GlobalVariable Property PlayerOnly Auto Mandatory
	GlobalVariable Property Notifications Auto Mandatory
EndGroup
