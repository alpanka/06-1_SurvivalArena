extends Node2D

@export var endgame_scene: PackedScene


func _ready() -> void:
	%Player.health_component.entity_died.connect(_on_player_died)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		add_child(Names.pause_menu_scene.instantiate())
		# Need to state that input has been handled
		get_tree().root.set_input_as_handled() 


func _on_player_died(_name) -> void:
	var lost_screen = endgame_scene.instantiate() as EndGameScreen
	lost_screen.endgame_type = lost_screen.TYPE.LOST
	add_child(lost_screen)
