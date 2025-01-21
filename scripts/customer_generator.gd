extends Node2D

@export var body_sprites: Array[Texture2D] = []
@export var beard_sprites: Array[Texture2D] = []
@export var hair_sprites: Array[Texture2D] = []

@onready var body: Sprite2D = $Body
@onready var beard: Sprite2D = $Beard
@onready var hair: Sprite2D = $Hair

func _ready() -> void:
	body.texture = body_sprites.pick_random()
	
	var beard_id: int = randi_range(-1, beard_sprites.size() - 1)
	if beard_id >= 0:
		beard.texture = beard_sprites[beard_id]
		beard.show()
	
	var hair_id: int = randi_range(-1, hair_sprites.size() - 1)
	if hair_id >= 0:
		hair.texture = hair_sprites[hair_id]
		hair.show()
