extends Node

@onready var timer: Timer = $Timer

@export var axe_scene: PackedScene

var spawn_timer: float = 2.0
var damage_amount: float = 10 # Source of damage amount

var player_node: CharacterBody2D


func _ready() -> void:
	_initialize_timer()


func _initialize_timer() -> void:
	# Get player node
	player_node = get_tree().get_first_node_in_group("player")
	# Timer setup
	timer.wait_time = spawn_timer
	timer.timeout.connect(_on_timer_timeout)


func _on_timer_timeout() -> void:
	var axe_instance: Node2D = axe_scene.instantiate()
	var layer_foreground = get_tree().get_first_node_in_group("layer_foreground")

	axe_instance.global_position = player_node.global_position
	layer_foreground.add_child(axe_instance)

	# Set damage
	axe_instance.hitbox_component.damage_amount = damage_amount
