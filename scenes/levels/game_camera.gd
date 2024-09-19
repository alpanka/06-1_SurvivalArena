extends Camera2D


var player_node: CharacterBody2D
var target_position: Vector2


func _ready() -> void:
	_initialize_ownership()
	self.zoom = Vector2(3, 3)


func _process(delta: float) -> void:
	_update_camera_position(delta)


func _update_camera_position(delta):
	if player_node == null:
		return
	
	target_position = player_node.global_position
	
	global_position = global_position.lerp(target_position, 1.0 - exp(-delta * 20)).round()


func _initialize_ownership():
	player_node = get_tree().get_first_node_in_group("player")
	
	if player_node == null:
		push_warning("player_node is null")
		return
