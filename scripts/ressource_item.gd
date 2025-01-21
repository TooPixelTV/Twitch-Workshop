extends Node2D
class_name RessourceItem

@export var ressource_type: InventoryManager.RessourceType

@onready var sprite: Sprite2D = $Sprite

var is_instance = false
var dragging = false
var craft_slot: CraftSlot

signal parent_changed

func _ready() -> void:
	sprite.frame = ressource_type

func _process(delta: float) -> void:
	if not is_instance:
		return
		
	if dragging and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		dragging = false
		handle_item_drop()
	
	if dragging:
		global_position = lerp(global_position, get_global_mouse_position(), 50 * delta)
	else:
		position = lerp(position, Vector2.ZERO, 10 * delta)


func _on_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		Globals.main_sfx.play_sfx(SFX.SFXType.DRAG)
		dragging = true

func handle_item_drop():
	Globals.main_sfx.play_sfx(SFX.SFXType.DROP)
	var craft_slots = get_tree().get_nodes_in_group("craft_slot")
	
	for slot in craft_slots:
		if slot.mouse_hover:
			if not slot.occupied():
				craft_slot = slot
				reparent(slot)
				parent_changed.emit()
				
			return
	
	reparent(get_tree().root)
	parent_changed.emit()
	InventoryManager.get_ressource_by_id(ressource_type).value += 1
	queue_free()
