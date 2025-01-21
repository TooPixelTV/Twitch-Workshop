extends Node2D
class_name Workers

@export var worker_walk_speed: float = 200

@onready var workers_list: Node = $WorkersList
@onready var start_point: Marker2D = $StartPoint
@onready var wood_point: Marker2D = $WoodPoint
@onready var stone_point: Marker2D = $StonePoint
@onready var iron_point: Marker2D = $IronPoint
@onready var gold_point: Marker2D = $GoldPoint

const WORKER = preload("res://scenes/worker.tscn")

var chat_enabled: bool = false

func _ready() -> void:
	GameManager.workers = self
	VerySimpleTwitch.chat_message_received.connect(_on_chat_message)
	
	enable_chat()

func _process(_delta: float) -> void:
	for worker in workers_list.get_children():
		if worker is Worker:
			if worker.action_state == worker.ActionState.NOT_STARTED:
				handle_worker_walk(worker)
			elif worker.action_state == worker.ActionState.STARTED:
				pass
			elif worker.action_state == worker.ActionState.ENDED:
				handle_worker_walk(worker, false)

func enable_chat():
	await get_tree().create_timer(1).timeout
	chat_enabled = true


func handle_worker_walk(worker: Worker, to_action: bool = true) -> void:
	var destination = null
	if to_action:
		worker.dwarf_sprite.look_left = true
		match worker.current_action:
			"wood":
				destination = wood_point.position
			"stone":
				destination = stone_point.position
			"iron":
				destination = iron_point.position
			"gold":
				destination = gold_point.position
				
	else:
		worker.dwarf_sprite.look_left = false
		destination = start_point.position
	
	if destination != null:
		if worker.position.distance_to(destination) > 2:
			worker.play_walk()
			worker.dwarf_sprite.is_walking = true
			var direction = worker.position.direction_to(destination)
			worker.velocity = direction * worker_walk_speed
			worker.move_and_slide()
		else:
			worker.stop_walk()
			worker.dwarf_sprite.is_walking = false
			
			if to_action:
				worker.start_action()
			else:
				worker_finish_action(worker)
			


func _on_chat_message(data: Chatter, force: bool = false) -> void:
	if not force and (GameManager.is_game_over or not chat_enabled):
		return
	
	if data.message.begins_with("!"):
		var message = data.message.substr(1).to_lower()
		
		if not worker_exists(data.login):
			var action: String
			
			if message.begins_with("wood"):
				action = "wood"
			elif message.begins_with("iron"):
				action = "iron"
			elif message.begins_with("gold"):
				action = "gold"
			elif message.begins_with("stone"):
				action = "stone"
			
			if action:
				var cooldown = InventoryManager.resources[action]["cooldown"]

				var worker_instance: Worker = WORKER.instantiate()
				worker_instance.twitch_login = data.login
				worker_instance.global_position = start_point.global_position
				worker_instance.display_infos = not force
				workers_list.add_child(worker_instance)
				worker_instance.set_action(action, cooldown)

func worker_exists(twitch_login: String) -> bool:
	var filtered_workers = workers_list.get_children().filter(func (e: Worker): return e.twitch_login == twitch_login)
	
	if filtered_workers.size() > 0:
		return true
	
	return false

func worker_finish_action(worker: Worker) -> void:
	if Globals.main_sfx:
		Globals.main_sfx.play_sfx(SFX.SFXType.RESOURCE_ADDED)
	InventoryManager.ressource_gathered(worker.current_action)
	worker.queue_free()

func reset_workers():
	for worker in workers_list.get_children():
		worker.queue_free()
