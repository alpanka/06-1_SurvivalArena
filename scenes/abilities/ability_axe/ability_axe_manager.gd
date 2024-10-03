extends Node

@onready var timer: Timer = $Timer

@export var axe_scene: PackedScene

var spawn_timer: float = 2.0
var base_damage_amount: float = 10 # Source of damage amount
var damage_addition_ratio: float = 1.0

var player_node: CharacterBody2D


func _ready() -> void:
	_initialize_manager()


func _initialize_manager() -> void:
	# Get player node
	player_node = get_tree().get_first_node_in_group("player")
	# Timer setup
	timer.wait_time = spawn_timer
	timer.timeout.connect(_on_timer_timeout)
	# Connect to upgrade_added signal
	Signals.ability_upgrade_added.connect(_on_upgrade_received)


func _on_timer_timeout() -> void:
	var axe_instance: Node2D = axe_scene.instantiate()
	var layer_foreground = get_tree().get_first_node_in_group("layer_foreground")

	axe_instance.global_position = player_node.global_position
	layer_foreground.add_child(axe_instance)

	# Set damage
	axe_instance.hitbox_component.damage_amount = base_damage_amount * damage_addition_ratio


# Update upgrade stats based on upgrade selected.
func _on_upgrade_received(ability: AbilityUpgrade, owned_upgrades: Dictionary):
	if ability.id == "axe_damage":
		# Check how many of this upgrades we own.
		# Update damage increase based on quantity.
		damage_addition_ratio = 1 + owned_upgrades["axe_damage"]["quantity"] * 0.05
