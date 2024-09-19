extends CharacterBody2D

@export var health_component: HealthComponent

var speed_init: float = 50
var speed_current: float
var direction: Vector2

var player_node: CharacterBody2D


func _ready() -> void:
	_initialize_enemy()


func _process(_delta: float) -> void:
	direction = _get_direction_to_player()
	
	velocity = direction * speed_current
	move_and_slide()


func _get_direction_to_player() -> Vector2:
	var direction_to_player: Vector2
	
	if player_node != null:
		direction_to_player = (player_node.global_position - self.global_position).normalized()
	else:
		direction_to_player = Vector2.ZERO

	return direction_to_player


func _initialize_enemy():
	player_node = get_tree().get_first_node_in_group("player")
	speed_current = speed_init
