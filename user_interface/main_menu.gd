extends CanvasLayer


func _ready() -> void:
	%PlayButton.pressed.connect(_on_play_button_pressed)
	%UpgradesButton.pressed.connect(_on_upgrades_button_pressed)
	%SettingsButton.pressed.connect(_on_settings_button_pressed)
	%QuitButton.pressed.connect(_on_quit_button_pressed)


func _on_play_button_pressed() -> void:
	SceneTransition.transition_to_scene(Names.main_game_scene)


func _on_upgrades_button_pressed() -> void:
	SceneTransition.transition_to_scene(Names.meta_selection_menu_scene)


# Launch settings menu
func _on_settings_button_pressed() -> void:
	SceneTransition.scene_transition()
	await SceneTransition.transitioned_halfway
	var settings_instance = Names.settings_menu_scene.instantiate()
	get_tree().get_root().add_child(settings_instance)
	settings_instance.back_button_pressed.connect(_on_settings_menu_exit.bind(settings_instance))


# Exit
func _on_quit_button_pressed() -> void:
	get_tree().quit()


# Back button on settings menu
func _on_settings_menu_exit(settings_menu: Node) -> void:
	settings_menu.queue_free()
