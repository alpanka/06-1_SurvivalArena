extends Node

@export var base_damage_amount: int = 15
@export var spawn_range: int = 100

@export var anvil_scene: PackedScene

var player: CharacterBody2D
var damage_addition_ratio := 1.0


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	$Timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout() -> void:
	if player == null: return
	
	var spawn_direction := Vector2.RIGHT.rotated(randf_range(0, TAU))
	var spawn_position := player.global_position + spawn_direction * randf_range(0, spawn_range)
	
	# Raycast and its parameters
	var additional_offset := spawn_direction * 10
	var raycast_param = PhysicsRayQueryParameters2D\
		.create(player.global_position, spawn_position+additional_offset, 1)
	var coll_results = get_tree().root.world_2d.direct_space_state.intersect_ray(raycast_param)
	
	if not coll_results.is_empty():
		spawn_position = coll_results["position"]
	
	# Instantiate the scene
	var layer_foreground = get_tree().get_first_node_in_group("layer_foreground")
	var anvil_instance: Node2D = anvil_scene.instantiate()
	anvil_instance.global_position = spawn_position
	layer_foreground.add_child(anvil_instance)
	
	# Set damage
	anvil_instance.hitbox_component.damage_amount = base_damage_amount * damage_addition_ratio
