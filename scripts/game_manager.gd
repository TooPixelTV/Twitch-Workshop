extends Node

signal money_updated

const GAME_MUSIC = preload("res://assets/audio/game_music.wav")
const MENU_MUSIC = preload("res://assets/audio/menu_music.wav")

var current_time: int = 0
var current_money: int = 0
var is_game_over: bool = false

var game_over_element: GameOver
var workbench: Workbench
var workshop: Workshop
var workers: Workers

func new_game():
	is_game_over = false
	get_tree().paused = false
	current_time = 0
	update_money(0)
	workshop.reset_penalties()
	workshop.reset_customers()
	workers.reset_workers()
	workers.enable_chat()
	InventoryManager.reset()
	workbench.reset_workbench()
	BackgroundMusic.crossfade_to(GAME_MUSIC)

func game_over():
	is_game_over = true
	workers.chat_enabled = false
	BackgroundMusic.crossfade_to(MENU_MUSIC)
	get_tree().paused = true
	game_over_element.update_score()
	game_over_element.show()
	game_over_element.play_sfx()
	
func get_current_max_request_size():
	return int(10 + (float(current_time) / 16.0))

func get_current_level():
	return int(1.0 + (float(current_time) / 90.0))

func update_money(new_value):
	current_money = new_value
	money_updated.emit()
