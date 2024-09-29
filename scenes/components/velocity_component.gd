class_name VelocityComponent
extends Node

@export var max_speed: int = 45
@export var acceleration: float = 5

var velocity: Vector2
var direction: Vector2
var owner_node: CharacterBody2D
var player: CharacterBody2D


func _ready() -> void:
	owner_node = get_owner()
	player = get_tree().get_first_node_in_group("player")


func chase_player(actor: CharacterBody2D):
	if owner_node == null or player == null:
		push_warning("Owner or player node null!")
		return
	
	var owner_position: Vector2 = owner_node.global_position
	direction = owner_position.direction_to(player.global_position).normalized()

	_accelerate(direction)
	
	# Move the character.
	# Upon collision, velocity would change:
	# So, update velocity after move_and_slide
	actor.velocity = velocity
	actor.move_and_slide()
	velocity = actor.velocity


# Smooth out movement and include acceleration
func _accelerate(_target_dir: Vector2):
	var target_velocity: Vector2 = _target_dir * max_speed
	var smoothing: float = 1 - exp(- acceleration * get_process_delta_time())
	
	velocity = velocity.lerp(target_velocity, smoothing)


func _decelerate() -> void:
	_accelerate(Vector2.ZERO)
