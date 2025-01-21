extends Node2D
class_name Crafting

signal craft_updated

func _ready() -> void:
	for slot in get_children():
		if slot is CraftSlot:
			slot.slot_updated.connect(_craft_updated)

func _craft_updated():
	craft_updated.emit()

func get_current_recipe() -> Array[int]:
	var slots = get_children().filter(func (a): return a is CraftSlot)
	
	var result: Array[int] = []
	for slot in slots:
		result.append(slot.get_resource_type())
	
	return result

func empty_crafting():
	for slot in get_children():
		if slot is CraftSlot:
			slot.empty()
	
