extends Node2D

@export var endgame_scene: PackedScene


func _ready() -> void:
	%Player.health_component.entity_died.connect(_on_player_died)


func _on_player_died(_name) -> void:
	var lost_screen = endgame_scene.instantiate() as EndGameScreen
	lost_screen.endgame_type = lost_screen.TYPE.LOST
	add_child(lost_screen)
