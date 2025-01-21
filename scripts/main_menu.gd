extends Node2D

const MENU_MUSIC = preload("res://assets/audio/menu_music.wav")

@onready var workers: Workers = $Workers

func _ready() -> void:
	BackgroundMusic.crossfade_to(MENU_MUSIC)
	random_worker()

func _on_twitch_chat_manager_connected() -> void:
	get_tree().change_scene_to_file("res://scenes/tutorial.tscn")


func _on_worker_timer_timeout() -> void:
	random_worker()

func random_worker():
	var action = ['!wood', '!stone', '!iron', '!gold'].pick_random()
	
	var data: Chatter = Chatter.new()
	data.message = action
	data.login = str(Time.get_ticks_usec())
	workers._on_chat_message(data, true)
