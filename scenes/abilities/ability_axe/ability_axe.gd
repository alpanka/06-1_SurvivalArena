extends Node2D

@onready var hitbox_component: HitboxComponent = $HitboxComponent

var player: CharacterBody2D
var base_rotation: Vector2
var swirl_radi: int = 100


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	base_rotation = Vector2.RIGHT.rotated(randf_range(0, TAU))
	
	var tween = create_tween()
	tween.tween_method(_axe_swirl_tween, 0.0, 2.0, 3.0)
	#tween.parallel().set_loops(10).tween_property(self, "rotation", TAU, 3)
	tween.tween_callback(queue_free)


func _axe_swirl_tween(_rotations: float) -> void:
	var percent = _rotations/2
	var current_radi = percent * swirl_radi
	var current_direction = base_rotation.rotated(_rotations * TAU)
	
	global_position = player.global_position + (current_radi * current_direction)
