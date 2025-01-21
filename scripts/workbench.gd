extends Node2D
class_name Workbench

@export var recipes: Array[Recipe]

@onready var crafting: Crafting = $Crafting
@onready var crafting_result_sprite: Sprite2D = $CraftingResult/CraftResultElement/CraftingResultSprite
@onready var craft_result_element: Area2D = $CraftingResult/CraftResultElement
@onready var craft_result_animation: AnimationPlayer = $CraftingResult/CraftResultElement/CraftResultAnimation

var current_result: Recipe
var dragging_result = false
var dragging_result_default_pos: Vector2
var can_move = true

func _ready() -> void:
	GameManager.workbench = self
	current_result = null
	dragging_result_default_pos = craft_result_element.global_position

func _process(delta: float) -> void:
	if dragging_result and not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		dragging_result = false
		on_result_drop()
		
	if can_move:
		if dragging_result:
			craft_result_element.global_position = lerp(craft_result_element.global_position, get_global_mouse_position(), 50 * delta)
		else:
			craft_result_element.global_position = lerp(craft_result_element.global_position, dragging_result_default_pos, 10 * delta)

func on_result_drop():
	var customers = get_tree().get_nodes_in_group("customer")
	
	for customer in customers:
		if customer.mouse_hover:
			customer = customer as Customer
			if customer.request.has(current_result):
				if customer.request.size() > 1:
					Globals.main_sfx.play_sfx(SFX.SFXType.DROP_OBJECT_SUCCESS)
				else:
					Globals.main_sfx.play_sfx(SFX.SFXType.REQUEST_COMPLETE)
					
				set_can_move(false)
				crafting.empty_crafting()
				GameManager.update_money(GameManager.current_money + current_result.price)
				customer.request.erase(current_result)
				customer.update_request()
				customer.add_remaining_time(10)
				craft_result_animation.play("drop_success")
				await craft_result_animation.animation_finished
				reset_workbench()
			return
	
	Globals.main_sfx.play_sfx(SFX.SFXType.DROP)

func _on_crafting_craft_updated() -> void:
	var recipe = crafting.get_current_recipe()
	
	var valid_recipe = find_valid_recipe(recipe)
	if valid_recipe != null:
		current_result = valid_recipe
		crafting_result_sprite.texture = valid_recipe.sprite
	else:
		current_result = null
		crafting_result_sprite.texture = null

func find_valid_recipe(recipe):
	for element in recipes:
		if element.recipe == recipe or element.recipe_alt == recipe:
			return element
	
	return null

func _on_craft_result_element_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("click") and crafting_result_sprite.texture != null:
		Globals.main_sfx.play_sfx(SFX.SFXType.DRAG)
		dragging_result = true


func reset_workbench():
	current_result = null
	crafting_result_sprite.texture = null
	set_can_move(true)
	crafting_result_sprite.modulate = Color.WHITE
	
func set_can_move(value: bool):
	can_move = value
