extends Node

const SPAWN_RADIUS: int = 350
var player_node: CharacterBody2D

@export var arena_timer_manager: ArenaTimerManager
@export var enemy_spider: PackedScene
@export var spawn_timeout: float = 1.0

@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	_initialize_enemy_manager()


func _initialize_enemy_manager() -> void:
	spawn_timer.wait_time = spawn_timeout
	spawn_timer.autostart = true
	spawn_timer.one_shot = true
	spawn_timer.start()
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	
	player_node = get_tree().get_first_node_in_group("player")
	arena_timer_manager.difficulty_increased.connect(_on_difficulty_increased)


## Create a ray cast and check if there is collision on the planned spawn location
func _get_spawn_position() -> Vector2:
	if player_node == null:
		push_warning("player_node is null!")
		return Vector2.ZERO

	
	# Random direction between 0 to 360
	var spawn_direction: Vector2 = Vector2.RIGHT.rotated(randf_range(0 ,TAU))
	var spawn_position: Vector2 = Vector2.ZERO
	
	for i in 4:
		# Length of the spawn position
		spawn_position = player_node.global_position + (spawn_direction * SPAWN_RADIUS)
		
		# Raycast and its parameters
		var raycast_param = PhysicsRayQueryParameters2D.create(player_node.global_position, spawn_position, 1)
		var coll_results = get_tree().root.world_2d.direct_space_state.intersect_ray(raycast_param)
		
		if coll_results.is_empty():
			# If no collision detected, return spawn_position
			break
		else:
			# If collision detected, rotate by 90 degrees
			spawn_direction = spawn_direction.rotated(PI/2)
		
	return spawn_position


func _on_spawn_timer_timeout() -> void:
	spawn_timer.start()
	
	var enemy_instance: Node2D = enemy_spider.instantiate()
	var layer_entities = get_tree().get_first_node_in_group("layer_entities")
	enemy_instance.global_position = _get_spawn_position()
	layer_entities.add_child(enemy_instance)


func _on_difficulty_increased(_difficulty) -> void:
	var time_off: float = (0.1/12) * _difficulty # Expecting 0.1 decrease every min
	spawn_timer.wait_time = max(0.3, spawn_timeout - time_off)
