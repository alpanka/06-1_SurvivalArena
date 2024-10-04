extends CanvasLayer


var is_closing: bool = false


func _ready() -> void:
	_initialize_pause_menu()


func _initialize_pause_menu() -> void:
	get_tree().paused = true
	
	%PanelContainer.pivot_offset = %PanelContainer.size / 2
	
	%ResumeButton.pressed.connect(_on_resume_button_pressed)
	%SettingsButton.pressed.connect(_on_settings_button_pressed)
	%QuitButton.pressed.connect(_on_quit_button_pressed)
	
	%AnimationPlayer.play("fade_in")
	
	var tween := create_tween()
	tween.tween_property(%PanelContainer, "scale", Vector2.ZERO, 0.0)
	tween.tween_property(%PanelContainer, "scale", Vector2.ONE, 0.45)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_BACK)


# Press ESC again to close
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_on_resume_button_pressed()
		# Need to state that input has been handled
		get_tree().root.set_input_as_handled()


# Close the settings menu
func _on_resume_button_pressed() -> void:
	if is_closing:
		return
	
	is_closing = true
	
	%AnimationPlayer.play_backwards("fade_in")
	
	var tween := create_tween()
	tween.tween_property(%PanelContainer, "scale", Vector2.ZERO, 0.3)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_BACK)
	
	await tween.finished
	
	get_tree().paused = false
	queue_free()


func _on_settings_button_pressed() -> void:
	var settings_menu_instance = Names.settings_menu_scene.instantiate()
	add_child(settings_menu_instance)
	
	settings_menu_instance.back_button_pressed.connect\
	(_on_settings_back_button_pressed.bind(settings_menu_instance))


func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(Names.main_menu_scene)


func _on_settings_back_button_pressed(settings_menu: Node) -> void:
	settings_menu.queue_free()
