extends Node

@export var transition_speed: float = 1.0

@onready var audio_stream_player_1: AudioStreamPlayer = $AudioStreamPlayer1
@onready var audio_stream_player_2: AudioStreamPlayer = $AudioStreamPlayer2
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func crossfade_to(audio_stream: AudioStream) -> void:
	animation_player.speed_scale = transition_speed
	if audio_stream_player_2.playing:
		audio_stream_player_1.stream = audio_stream
		audio_stream_player_1.play()
		animation_player.play("FadeToPlayer1")
		await animation_player.animation_finished
		audio_stream_player_2.stop()
	else:
		audio_stream_player_2.stream = audio_stream
		audio_stream_player_2.play()
		animation_player.play("FadeToPlayer2")
		await animation_player.animation_finished
		audio_stream_player_1.stop()


func _on_audio_stream_player_1_finished() -> void:
	audio_stream_player_1.play(0.0)


func _on_audio_stream_player_2_finished() -> void:
	audio_stream_player_2.play(0.0)
