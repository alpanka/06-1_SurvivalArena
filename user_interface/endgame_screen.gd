class_name EndGameScreen
extends CanvasLayer

enum TYPE {WON, LOST}
var endgame_type: TYPE 


func _ready() -> void:
	_initialize_endgame_screen()


func _initialize_endgame_screen() -> void:
	get_tree().paused = true
	%RestartButton.pressed.connect(_on_restart_button_pressed)
	%QuitButton.pressed.connect(_on_quit_button_pressed)
	
	match endgame_type:
		TYPE.WON:
			%TitleLabel.text = "VICTORY!!!"
			%DescriptionLabel.text = "You won!"
		TYPE.LOST:
			%TitleLabel.text = "LOST!!!"
			%DescriptionLabel.text = "You've lost!"


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/levels/main_scene.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
