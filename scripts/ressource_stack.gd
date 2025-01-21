extends Node2D
class_name RessourceStack

const RESSOURCE_ITEM = preload("res://scenes/ressource_item.tscn")

@export var ressource_type: InventoryManager.RessourceType

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var sprite: Sprite2D = $Sprite
@onready var value_label: Label = $Value

var default_position: Vector2
var can_drag := false
var dragging := false
var drag_item: RessourceItem
var current_value: int = 0

func _ready() -> void:
	sprite.frame = ressource_type
	default_position = global_position


func _process(delta: float) -> void:
	var ressource_data = InventoryManager.get_ressource_by_id(ressource_type)
	
	if ressource_data.value != current_value:
		current_value = ressource_data.value
		animation_player.play("update_value")
		
	value_label.text = str(ressource_data.value)
	
	can_drag = ressource_data.value > 0
	
	if dragging and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		dragging = false
		handle_drop()
		
	if can_drag:
		%Sprite.self_modulate = Color.WHITE
		%Value.self_modulate = Color.WHITE
	else:
		%Sprite.self_modulate = Color.html("494949")
		%Value.self_modulate = Color.html("494949")
	
	if dragging:
		drag_item.global_position = lerp(drag_item.global_position, get_global_mouse_position(), 50 * delta)
	else:
		if drag_item:
			if drag_item.global_position.distance_to(default_position) < 10:
				drag_item.queue_free()
				drag_item = null
			else:
				drag_item.global_position = lerp(drag_item.global_position, default_position, 10 * delta)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if can_drag and event.is_action_pressed("click"):
		Globals.main_sfx.play_sfx(SFX.SFXType.DRAG)
		dragging = true
		
		drag_item = RESSOURCE_ITEM.instantiate()
		drag_item.ressource_type = ressource_type
		
		add_child(drag_item)	

func handle_drop():
	Globals.main_sfx.play_sfx(SFX.SFXType.DROP)
	var craft_slots = get_tree().get_nodes_in_group("craft_slot")
	for slot in craft_slots:
		if slot.mouse_hover and not slot.occupied():
			var success = slot.drop_ressource(drag_item)
			
			if success:
				drag_item = null
				InventoryManager.get_ressource_by_id(ressource_type).value -= 1
		
