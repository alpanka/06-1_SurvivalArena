## Instantiate attacking scene in intervals
## Using timer for frequency
## Atticking on closest enemy
class_name AbilitySwordManager
extends Node

@export var ability_sword_scene: PackedScene

var spawn_timer: float = 1.5
var attack_range: float = 150
var damage_amount: float = 5 # Source of damage amount

var enemies: Array
var player_node: CharacterBody2D


func _ready() -> void:
	_manager_initialize()


func _manager_initialize():
	# Get player node
	player_node = get_tree().get_first_node_in_group("player")
	# Timer setup
	$Timer.timeout.connect(_on_timer_timeout)
	$Timer.wait_time = spawn_timer
	# Connect to upgrade_added signal
	Signals.ability_upgrade_added.connect(_on_upgrade_received)

func _on_timer_timeout() -> void:
	# Break if player is null
	if player_node == null:
		push_warning("player_node is null")
		return

	# Get all enemies
	enemies = get_tree().get_nodes_in_group("enemy")

	# Filter enemies based on their distance to player
	enemies = enemies.filter(func(enemy: Node2D):
		var distance: float = enemy.global_position.distance_squared_to(player_node.global_position)
		var range_limit: float = pow(attack_range, 2)
		
		return distance < range_limit
	)
	
	# Break if no enemies found
	if enemies.size() == 0:
		return
	
	# Sort enemies based on their distance to player
	enemies.sort_custom(func(a: Node2D, b: Node2D):
		var dist_a: float = a.global_position.distance_squared_to(player_node.global_position)
		var dist_b: float = b.global_position.distance_squared_to(player_node.global_position)
		
		return dist_a < dist_b
	)

	# Instantiate sword
	var sword_instance = ability_sword_scene.instantiate() as AbilitySword
	var instance_pos: Vector2
	var instance_dir: Vector2
	
	# Set its position
	instance_pos = enemies[0].global_position
	instance_pos += Vector2.RIGHT.rotated(randf_range(0, TAU)) * 10
	sword_instance.global_position = instance_pos
	
	# Set its rotation
	#instance_dir = enemies[0].global_position.direction_to(sword_instance.global_position)
	instance_dir = enemies[0].global_position - sword_instance.global_position
	sword_instance.rotation = instance_dir.angle()
	
	var layer_foreground = get_tree().get_first_node_in_group("layer_foreground")
	layer_foreground.add_child(sword_instance)
	
	# Set its damage
	sword_instance.hitbox_component.damage_amount = damage_amount


func _on_upgrade_received(ability: AbilityUpgrade, owned_upgrades: Dictionary):
	if ability.id != "sword_rate":
		return

	var upgrd_ratio: float = 1 - owned_upgrades["sword_rate"]["quantity"] * 0.1
	
	$Timer.wait_time = spawn_timer * upgrd_ratio
	$Timer.start()
	#print($Timer.wait_time)
