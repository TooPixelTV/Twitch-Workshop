extends CanvasLayer
class_name GameOver

func _ready() -> void:
	GameManager.game_over_element = self

func play_sfx() -> void:
	%GameOverSFX.play()

func update_score():
	%ScoreValue.text = str(GameManager.current_money)
	
func _on_restart_btn_pressed() -> void:
	GameManager.new_game()
	hide()
