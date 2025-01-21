extends CanvasLayer


func _process(_delta: float) -> void:
	if visible:
		get_tree().paused = true


func _on_close_btn_pressed() -> void:
	get_tree().paused = false
	hide()
