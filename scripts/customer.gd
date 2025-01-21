extends Node2D
class_name Customer

signal request_failed

@export var terrain_set_id: int = 0
@export var terrain_id: int = 0

@export var warning_threshold: float = 30
@export var warning_color: Color = Color.WHITE
@export var danger_threshold: float = 15
@export var danger_color: Color = Color.WHITE
@export var last_seconds_threshold: float = 5
@export var appear_bubble_speed: float = 0.01

@onready var request_ui: GridContainer = $Bubble/RequestUI
@onready var bubble: TileMapLayer = $Bubble
@onready var bubble_animation_player: AnimationPlayer = $Bubble/AnimationPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var request: Array[Recipe]
var remaining_time: float = 40
var mouse_hover = false
var max_remaining_time: float


func _ready() -> void:
	max_remaining_time = remaining_time
	update_request()


func update_request():
	if request.size() == 0:
		client_leave()
	
	for child in request_ui.get_children():
		child.free()
	
	for element in request:
		var texture_rect := TextureRect.new()
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP
		texture_rect.texture = element.sprite
		request_ui.add_child(texture_rect)
	
	call_deferred("update_bubble")


func update_bubble():
	bubble.clear()
	
	var item_lines: int = ceil(float(request_ui.get_child_count()) / float(request_ui.columns))
	var bubble_width: int = 4 * request_ui.columns
	var bubble_height: int = 4 * item_lines
	var bubble_cells: Array[Vector2i] = []
	for x in bubble_width:
		for y in bubble_height:
			bubble_cells.append(Vector2i(x - int(float(bubble_width) / 2.0), y - bubble_height))
	
	bubble.set_cells_terrain_connect(bubble_cells, terrain_set_id, terrain_id)
	
	var bubble_start_x: int = int(float(bubble_width) / 2.0) - 2
	var bubble_start_y: int = -1
	bubble.set_cell(Vector2(bubble_start_x, bubble_start_y), 0, Vector2i(2,2))


func add_remaining_time(time: int) -> void:
	remaining_time = clampf(remaining_time + time, 0, max_remaining_time)
	update_bubble_color()


func _on_mouse_entered() -> void:
	mouse_hover = true


func _on_mouse_exited() -> void:
	mouse_hover = false


func _on_remaining_timer_timeout() -> void:
	remaining_time -= 1
	
	if remaining_time <= 0:
		%RemainingTimer.stop()
		request_failed.emit()
		client_leave()
	
	update_bubble_color()


func update_bubble_color():
	var shader: Material = bubble.material
	bubble_animation_player.stop()
	
	if remaining_time > warning_threshold:
		shader.set("shader_parameter/color", Color.WHITE)
	elif remaining_time <= last_seconds_threshold:
		shader.set("shader_parameter/color", danger_color)
		bubble_animation_player.play("vibrate")
	elif remaining_time <= danger_threshold:
		shader.set("shader_parameter/color", danger_color)
	elif remaining_time <= warning_threshold:
		shader.set("shader_parameter/color", warning_color)


func client_leave():
	bubble.hide()
	animation_player.play("leave")
