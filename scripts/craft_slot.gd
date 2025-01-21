extends Area2D
class_name CraftSlot

@export var pos_x: int = 0
@export var pos_y: int = 0

var mouse_hover = false

signal slot_updated

func _on_mouse_entered() -> void:
	mouse_hover = true


func _on_mouse_exited() -> void:
	mouse_hover = false


func drop_ressource(ressource_item: RessourceItem) -> bool:
	if ressource_item and not occupied():
		ressource_item.reparent(self)
		ressource_item.position = Vector2.ZERO
		ressource_item.craft_slot = self
		ressource_item.is_instance = true
		slot_updated.emit()
		ressource_item.parent_changed.connect(func (): slot_updated.emit())
		return true
	
	return false

func occupied() -> bool:
	var ressources = get_children().filter(func (e): return e.is_in_group("ressource_item"))
	
	return ressources.size() > 0

func get_resource_type() -> int:
	if occupied():
		var ressources = get_children().filter(func (e): return e.is_in_group("ressource_item"))
		return (ressources[0] as RessourceItem).ressource_type
	else:
		return -1

func empty():
	if occupied():
		var ressources = get_children().filter(func (e): return e.is_in_group("ressource_item"))
		ressources[0].queue_free()
