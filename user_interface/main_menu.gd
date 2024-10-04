extends CanvasLayer


func _ready() -> void:
	%PlayButton.pressed.connect(_on_play_button_pressed)
	%SettingsButton.pressed.connect(_on_settings_button_pressed)
	%QuitButton.pressed.connect(_on_quit_button_pressed)


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(Names.main_game_scene)


# Launch settings menu
func _on_settings_button_pressed() -> void:
	var settings_instance := Names.settings_mene_scene.instantiate()
	get_tree().get_root().add_child(settings_instance)
	settings_instance.back_button_pressed.connect(_on_settings_menu_exit.bind(settings_instance))


# Exit
func _on_quit_button_pressed() -> void:
	get_tree().quit()


# Back button on settings menu
func _on_settings_menu_exit(settings_menu: Node) -> void:
	settings_menu.queue_free()
