extends CharacterBody2D

@export var random_audio_player_component: RandomAudioPlayerComponent
@export var health_component: HealthComponent
@export var velocity_component: VelocityComponent
@onready var visuals: Node2D = $Visuals

var speed_init: float = 50
var speed_current: float
var direction: Vector2

var player_node: CharacterBody2D


func _ready() -> void:
	_initialize_enemy()


func _process(_delta: float) -> void:
	#direction = _get_direction_to_player()
	#velocity = direction * speed_current
	velocity_component.chase_player(self)

	# Flip the sprite
	var move_sign: int = sign(velocity.x)
	if move_sign != 0:
		visuals.scale.x = move_sign

	# Face the player.
	if is_instance_valid(player_node):
		self.look_at(player_node.global_position)


func _initialize_enemy():
	player_node = get_tree().get_first_node_in_group("player")
	health_component.health_changed.connect(_on_health_changed)
	speed_current = speed_init


# Play audio once got hit
func _on_health_changed() -> void:
	random_audio_player_component.play_random_audio()

#func _get_direction_to_player() -> Vector2:
	#var direction_to_player: Vector2
	#
	#if player_node != null:
		#direction_to_player = (player_node.global_position - self.global_position).normalized()
	#else:
		#direction_to_player = Vector2.ZERO
#
	#return direction_to_player
