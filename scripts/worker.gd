extends CharacterBody2D
class_name Worker

enum ActionState {
	NOT_STARTED,
	STARTED,
	ENDED
}

enum GatheringType {
	WOOD,
	METAL,
}

const WALK_1 = preload("res://assets/audio/walk_1.wav")
const WALK_2 = preload("res://assets/audio/walk_2.wav")
const WALK_3 = preload("res://assets/audio/walk_3.wav")
const WALK_4 = preload("res://assets/audio/walk_4.wav")
const WALK_5 = preload("res://assets/audio/walk_5.wav")

const WOOD_1 = preload("res://assets/audio/wood_1.wav")
const WOOD_2 = preload("res://assets/audio/wood_2.wav")
const WOOD_3 = preload("res://assets/audio/wood_3.wav")

const METAL_1 = preload("res://assets/audio/metal_1.wav")
const METAL_2 = preload("res://assets/audio/metal_2.wav")
const METAL_3 = preload("res://assets/audio/metal_3.wav")

@onready var action_sfx: AudioStreamPlayer = $ActionSFX
@onready var walk_sfx: AudioStreamPlayer = $WalkSFX

@onready var action_timer: Timer = $ActionTimer
@onready var worker_name: Label = $WorkerName
@onready var action_progress: ProgressBar = $ActionProgress
@onready var dwarf_sprite: DwarfSprite = $DwarfSprite

var twitch_login: String
var action_state: ActionState = ActionState.NOT_STARTED
var current_action: String
var current_cooldown: float

var walking: bool = false
var gathering: bool = false
var gathering_type: GatheringType = GatheringType.WOOD 
var display_infos: bool = true

func _ready() -> void:
	worker_name.text = twitch_login
	
	if not display_infos:
		worker_name.hide()

func _process(_delta: float) -> void:
	action_progress.value = current_cooldown

func set_action(action: String, cooldown: float) -> void:
	current_action = action
	current_cooldown = cooldown
	action_progress.max_value = cooldown
	action_progress.value = cooldown

func start_action() -> void:
	if action_state != ActionState.NOT_STARTED:
		return
	
	if current_action == "wood":
		play_gathering(GatheringType.WOOD)
	else:
		play_gathering(GatheringType.METAL)
	
	if display_infos:
		action_progress.show()
	
	action_state = ActionState.STARTED
	get_tree().create_timer(current_cooldown).timeout.connect(_on_action_finished)
	action_timer.start()

func _on_action_finished():
	action_progress.hide()
	action_state = ActionState.ENDED
	stop_gathering()
	

func _on_action_timer_timeout() -> void:
	current_cooldown = current_cooldown - action_timer.wait_time
	if current_cooldown <= 0:
		current_cooldown = 0
		action_timer.stop()

func play_walk():
	if walking:
		return
	
	walking = true
	
func stop_walk():
	walking = false
	
func play_gathering(type: GatheringType):
	if gathering:
		return
	
	gathering_type = type
	gathering = true
	
func stop_gathering():
	gathering = false

func _on_repeat_sfx_timeout() -> void:
	if walking:
		action_sfx.stream = [WALK_1, WALK_2, WALK_3, WALK_4, WALK_5].pick_random()
		action_sfx.play()
	elif gathering:
		if gathering_type == GatheringType.WOOD:
			action_sfx.stream = [WOOD_1, WOOD_2, WOOD_3].pick_random()
			action_sfx.play()
		elif gathering_type == GatheringType.METAL:
			action_sfx.stream = [METAL_1, METAL_2, METAL_3].pick_random()
			action_sfx.play()
