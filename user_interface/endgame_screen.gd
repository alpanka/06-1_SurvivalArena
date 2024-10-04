class_name EndGameScreen
extends CanvasLayer

enum TYPE {WON, LOST}
var endgame_type: TYPE 


func _ready() -> void:
	_initialize_animation()
	_initialize_endgame_screen()


func _initialize_animation() -> void:
	%Panel.pivot_offset = %Panel.size / 2
	
	var tween = create_tween()
	tween.tween_property(%Panel, "scale", Vector2.ZERO, 0.0)
	tween.tween_property(%Panel, "scale", Vector2.ONE, 0.3)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_BACK)


func _initialize_endgame_screen() -> void:
	get_tree().paused = true
	%RestartButton.pressed.connect(_on_restart_button_pressed)
	%QuitButton.pressed.connect(_on_quit_button_pressed)
	
	match endgame_type:
		TYPE.WON:
			$RandomAudioPlayerComponentBasic.play_random_audio(0)
			%TitleLabel.text = "VICTORY!!!"
			%DescriptionLabel.text = "You won!"
		TYPE.LOST:
			$RandomAudioPlayerComponentBasic.play_random_audio(1)
			%TitleLabel.text = "LOST!!!"
			%DescriptionLabel.text = "You've lost!"


func _on_restart_button_pressed() -> void:
	SceneTransition.scene_transition()
	await SceneTransition.transitioned_halfway
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/levels/main_scene.tscn")


func _on_quit_button_pressed() -> void:
	SceneTransition.scene_transition()
	await SceneTransition.transitioned_halfway
	get_tree().quit()
