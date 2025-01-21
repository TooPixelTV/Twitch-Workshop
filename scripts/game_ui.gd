extends CanvasLayer

@onready var timer: Label = $Timer

var tween: Tween
var current_money: int

func _ready() -> void:
	GameManager.money_updated.connect(money_value_update)

func _on_time_timer_timeout() -> void:
	GameManager.current_time += 1
	timer.text = str(GameManager.current_time)


func _on_recipe_btn_pressed() -> void:
	%Recipes.show()


func money_value_update() -> void:
	if tween && tween.is_running():
		tween.stop()
	
	tween = create_tween()
	tween.tween_method(update_money_label, current_money, GameManager.current_money, 0.7)

func update_money_label(value: int):
	current_money = value
	%MoneyLabel.text = str(value)
