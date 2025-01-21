extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("start")
	
func start():
	GameManager.new_game()
	
