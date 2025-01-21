extends HBoxContainer
class_name Penalties

@export var max_penalties: int = 3
@export var penalty_slot_texture: Texture2D
@export var penalty_filled_texture: Texture2D

var current_penalties: int = 0

func _ready() -> void:
	for i in max_penalties:
		var texture_rect = TextureRect.new()
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP
		texture_rect.texture = penalty_slot_texture
		add_child(texture_rect)

func add_penalty():
	current_penalties += 1
	
	if current_penalties >= max_penalties:
		GameManager.game_over()
	
	update_penalties_ui()

func update_penalties_ui():
	var elements = get_children()
	
	for i in elements.size():
		if i < current_penalties:
			if elements[i].texture != penalty_filled_texture:
				elements[i].texture = penalty_filled_texture
		else:
			if elements[i].texture != penalty_slot_texture:
				elements[i].texture = penalty_slot_texture
