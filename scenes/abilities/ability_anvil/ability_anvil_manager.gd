extends Node

@export var base_damage_amount: int = 15
@export var spawn_range: int = 110

@export var anvil_scene: PackedScene

var player: CharacterBody2D
var damage_addition_ratio := 1.0
var anvil_count: int = 1


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	$Timer.timeout.connect(_on_timer_timeout)
	# Connect to upgrade_added signal
	Signals.ability_upgrade_added.connect(_on_upgrade_received)


func _on_timer_timeout() -> void:
	if player == null: return
	
	# Spawn multiple anvils if possible
	# Fixed direction for all anvils
	# Seperate them based on how many that'd be spawned
	var spawn_direction := Vector2.RIGHT.rotated(randf_range(0, TAU))
	var seperation_degree := deg_to_rad(360 / anvil_count)
	var spawn_distance := randf_range(30, spawn_range)
	
	for i in anvil_count:
		
		var adjusted_spawn_direction := spawn_direction.rotated(i * seperation_degree)
		var spawn_position := player.global_position + adjusted_spawn_direction * spawn_distance
		
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


# Update upgrade stats based on upgrade selected.
func _on_upgrade_received(ability: AbilityUpgrade, owned_upgrades: Dictionary):
	if ability.id == "anvil_count":
		# Check how many of this upgrades we own.
		anvil_count = 1 + owned_upgrades["anvil_count"]["quantity"]
