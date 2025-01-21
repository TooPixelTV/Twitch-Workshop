extends Node2D
class_name Workshop

@export var workbench: Workbench

@onready var customer_slots: Node = $CustomerSlots
@onready var penalties: Penalties = $Penalties

const CUSTOMER = preload("res://scenes/customer.tscn")

func _ready() -> void:
	GameManager.workshop = self

func _on_spawn_timer_timeout() -> void:
	var possible_slots: Array[Node] = customer_slots.get_children().filter(func (e:Node): return e.get_child_count() == 0)

	if possible_slots.size() > 0:
		var selected_slot: Node = possible_slots.pick_random()
		
		var request: Array[Recipe] = generate_new_request()
		
		
		var customer_instance = CUSTOMER.instantiate()
		customer_instance.request = request
		Globals.main_sfx.play_sfx(SFX.SFXType.NEW_CUSTOMER)
		selected_slot.add_child(customer_instance)
		customer_instance.request_failed.connect(_on_request_failed)

func generate_new_request():
	var request: Array[Recipe] = []
	
	var max_request_size: int = GameManager.get_current_max_request_size()
	var available_recipes: Array[Recipe] = workbench.recipes.filter(filter_recipe_by_level)
	
	var request_size = randi_range(int(float(max_request_size) / 2.0), max_request_size)
	
	var request_value: int = 0
	while true:
		var element: Recipe = available_recipes.pick_random()
		request.push_back(element)
		request_value += element.price
		
		if request_value >= max_request_size:
			break
	
	return request

func _on_request_failed():
	Globals.main_sfx.play_sfx(SFX.SFXType.REQUEST_FAIL)
	penalties.add_penalty()


func filter_recipe_by_level(recipe: Recipe) -> bool:
	var level = GameManager.get_current_level()
	return recipe.level <= level
	
func reset_customers():
	var possible_slots: Array[Node] = customer_slots.get_children()
	
	for slot in possible_slots:
		for element in slot.get_children():
			element.queue_free()
	%SpawnTimer.stop()
	%SpawnTimer.start()
	
func reset_penalties():
	penalties.current_penalties = 0
	penalties.update_penalties_ui()
