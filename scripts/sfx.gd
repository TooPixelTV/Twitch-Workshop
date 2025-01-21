extends AudioStreamPlayer
class_name SFX

enum SFXType {
	DRAG,
	DROP,
	DROP_OBJECT_SUCCESS,
	REQUEST_COMPLETE,
	NEW_CUSTOMER,
	REQUEST_FAIL,
	RESOURCE_ADDED,
}

@onready var new_customer_sfx: AudioStreamPlayer = $NewCustomerSFX
@onready var penalty_sfx: AudioStreamPlayer = $PenaltySFX
@onready var resource_sfx: AudioStreamPlayer = $ResourceSFX

const DRAG = preload("res://assets/audio/drag.wav")
const DROP = preload("res://assets/audio/drop.wav")
const DROP_OBJECT_SUCCESS = preload("res://assets/audio/drop_object_success.wav")
const REQUEST_COMPLETE = preload("res://assets/audio/request_complete.wav")
const NEW_CUSTOMER = preload("res://assets/audio/new_customer.wav")
const RESOURCE_ADDED = preload("res://assets/audio/resource_added.wav")

const REQUEST_FAIL_1 = preload("res://assets/audio/request_fail_1.wav")
const REQUEST_FAIL_2 = preload("res://assets/audio/request_fail_2.wav")
const REQUEST_FAIL_3 = preload("res://assets/audio/request_fail_3.wav")

func _ready() -> void:
	Globals.main_sfx = self
	new_customer_sfx.stream = NEW_CUSTOMER
	resource_sfx.stream = RESOURCE_ADDED

func play_sfx(type: SFXType) :
	stream = null
	match type:
		SFXType.DRAG:
			stream = DRAG
		SFXType.DROP:
			stream = DROP
		SFXType.DROP_OBJECT_SUCCESS:
			stream = DROP_OBJECT_SUCCESS
		SFXType.REQUEST_COMPLETE:
			stream = REQUEST_COMPLETE
		SFXType.NEW_CUSTOMER:
			new_customer_sfx.play()
		SFXType.REQUEST_FAIL:
			penalty_sfx.stream = [REQUEST_FAIL_1, REQUEST_FAIL_2, REQUEST_FAIL_3].pick_random()
			penalty_sfx.play()
		SFXType.RESOURCE_ADDED:
			resource_sfx.play()


	if stream != null:
		play()
