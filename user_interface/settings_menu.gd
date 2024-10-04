extends CanvasLayer

signal back_button_pressed

var window_mode := DisplayServer.window_get_mode()


func _ready() -> void:
	_update_volume_sliders()
	
	%WindowButton.text = _get_window_mode_name()
	
	%WindowButton.pressed.connect(_on_window_button_pressed)
	%BackButton.pressed.connect(_on_back_button_pressed)
	
	%SFXSlider.value_changed.connect(_on_audio_slider_changed.bind("SFX"))
	%MusicSlider.value_changed.connect(_on_audio_slider_changed.bind("MUSIC"))


func _update_volume_sliders():
	%SFXSlider.value = _get_bus_volume("SFX")
	%MusicSlider.value = _get_bus_volume("MUSIC")


# Get bus' current volume in float
func _get_bus_volume(bus_name: String) -> float:
	var bus_index := AudioServer.get_bus_index(bus_name)
	var bus_volume_db := AudioServer.get_bus_volume_db(bus_index)
	
	return db_to_linear(bus_volume_db)


# Set volume
func _set_bus_volume(bus_name: String, volume_lin: float) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)
	var bus_volume_db := linear_to_db(volume_lin)
	
	AudioServer.set_bus_volume_db(bus_index, bus_volume_db)


# Get window mode enum value to string
func _get_window_mode_name() -> String:
	window_mode = DisplayServer.window_get_mode()
	match window_mode:
		0:
			return "Window"
		2:
			return "Maximized"
		3:
			return "Fullscreen"
		_:
			return ""


# Check window mode then set to other type
func _on_window_button_pressed() -> void:
	window_mode = DisplayServer.window_get_mode()

	if window_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		%WindowButton.text = _get_window_mode_name()
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		%WindowButton.text = _get_window_mode_name()


func _on_back_button_pressed() -> void:
	SceneTransition.scene_transition()
	await SceneTransition.transitioned_halfway
	back_button_pressed.emit()


func _on_audio_slider_changed(value: float, bus_name: String) -> void:
	_set_bus_volume(bus_name, value)
