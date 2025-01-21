extends Node2D
class_name DwarfSprite

@export var hair_sprites: Array[Texture2D]
@export var beard_sprites: Array[Texture2D]
@export var look_left: bool = false
@export var is_walking: bool = false

@onready var body: Sprite2D = $Body
@onready var beard: Sprite2D = $Beard
@onready var hair: Sprite2D = $Hair
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	var hair_id: int = randi_range(-1, hair_sprites.size() - 1)
	var beard_id: int = randi_range(-1, beard_sprites.size() - 1)

	if hair_id >= 0:
		hair.texture = hair_sprites[hair_id]
		hair.show()
	
	if beard_id >= 0:
		beard.texture = beard_sprites[beard_id]
		beard.show()

func _process(_delta: float) -> void:
	if look_left:
		set_sprites_h_flip(true)
	else:
		set_sprites_h_flip(false)
	
	if is_walking:
		animation_player.play("walk")
	else:
		animation_player.stop()
		
		

func set_sprites_h_flip(value: bool) -> void:
	body.flip_h = value
	hair.flip_h = value
	beard.flip_h = value
