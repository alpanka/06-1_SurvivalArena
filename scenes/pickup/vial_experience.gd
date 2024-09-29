## Experience vial
extends Node2D

@onready var collision_shape: CollisionShape2D = $PickupArea/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

var player_node: CharacterBody2D


func _ready() -> void:
	$PickupArea.area_entered.connect(_on_pickup_area_entered)
	player_node = get_tree().get_first_node_in_group("player")


func _on_pickup_area_entered(area: Area2D) -> void:
	# Disabl collision once it is collected
	Callable(_disable_collision).call_deferred()
	
	# Vial collection tween
	var tween: Tween = get_tree().create_tween()
	tween.set_parallel(true)
	# Method to lerp rotation and position
	tween.tween_method(_tween_collect.bind(self.global_position), 0.0, 1.0, 0.6)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_BACK)
	# Set scale to ZERO
	tween.tween_property(sprite, "scale", Vector2.ZERO, 0.1).set_delay(0.5)
	
	tween.chain().tween_callback(_vial_collected) # Chain both parallel tweens


# Disable collision once it is collected
func _disable_collision() -> void:
	collision_shape.disabled = true


# Tween method to move the vial towards player for collection
func _tween_collect(percent: float, start_pos: Vector2) -> void:
	var target_pos: Vector2 = player_node.global_position
	
	# Lerp to player's position
	self.global_position = start_pos.lerp(target_pos, percent)
	
	# Rotate towards player
	var start_direction: Vector2 = start_pos.direction_to(target_pos)
	var target_rotation: float = start_direction.angle() + deg_to_rad(90) # Flip 90 to face RIGHT
	var smoothing: float = 1 - exp(-2 * get_process_delta_time())
	
	rotation = lerp_angle(rotation, target_rotation, smoothing)


# Final method upon collection
func _vial_collected() -> void:
	Signals.exp_vial_collected.emit(1.0)
	queue_free()
