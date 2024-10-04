class_name SoundButton
extends Button

func _ready() -> void:
	self.pressed.connect(_on_button_pressed)


func _on_button_pressed() -> void:
	$RandomAudioPlayerComponentBasic.play_random_audio()
