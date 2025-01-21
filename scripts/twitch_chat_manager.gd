extends CanvasLayer
class_name TwitchChatManager

signal connected
signal chat_message_received(data: Chatter)

@onready var twitch_channel_input: LineEdit = $ConnectUI/VBoxContainer/TwitchChannelInput
@onready var connect_ui: Control = $ConnectUI

var twitch_channel: String

func _ready() -> void:
	VerySimpleTwitch.chat_message_received.connect(_on_twitch_message)

func _on_connect_btn_pressed() -> void:
	twitch_channel = twitch_channel_input.text
	var result = connect_to_twitch()
	
	if result:
		connect_ui.hide()
		connected.emit()


func _on_twitch_message(data: Chatter) -> void:
	chat_message_received.emit(data)


func connect_to_twitch() -> bool:
	if twitch_channel and twitch_channel.strip_edges().length() > 0:
		VerySimpleTwitch.login_chat_anon(twitch_channel)
		return true
	
	return false


func _on_twitch_channel_input_text_submitted() -> void:
	_on_connect_btn_pressed()
