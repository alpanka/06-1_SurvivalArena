class_name Player
extends CharacterBody2D

@onready var health_component: HealthComponent = $Managers/HealthComponent
@onready var damage_cooldown: Timer = $Managers/DamageCooldown
@onready var health_bar: ProgressBar = $HealthBar


var direction: Vector2
var speed_current: float
var speed_init: float = 100

var smoothing: float = 10
var smoothing_multiplier: float
var target_velocity: Vector2

var damaging_bodies: int = 0

func _ready() -> void:
	_initialize_player()


func _process(delta: float) -> void:
	direction = _get_movement_vector()
	target_velocity = direction * speed_current
	smoothing_multiplier = 1 - exp(-delta * smoothing)
	
	if direction:
		velocity = velocity.lerp(target_velocity, smoothing_multiplier)
	else:
		velocity = velocity.lerp(Vector2.ZERO, 2 * smoothing_multiplier)
	
	move_and_slide()


func _initialize_player() -> void:
	speed_current = speed_init
	_update_health_bar()
	
	$DamageArea.body_entered.connect(_on_enemy_body_entered)
	$DamageArea.body_exited.connect(_on_enemy_body_exited)
	damage_cooldown.timeout.connect(_on_damage_cooldown)
	health_component.health_changed.connect(_on_health_changed)
	Signals.ability_upgrade_added.connect(_on_ability_upgrade_added)


func _get_movement_vector() -> Vector2:
	var movement_x: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var movement_y: float = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	return Vector2(movement_x, movement_y).normalized()


func _check_deal_damage():
	if damaging_bodies == 0 or not damage_cooldown.is_stopped():
		print("passed")
		return

	health_component.take_damage(1)
	damage_cooldown.start()
	print("health: ", health_component.health_current)


func _on_enemy_body_entered(body: Node2D):
	damaging_bodies += 1
	_check_deal_damage()


func _on_enemy_body_exited(body: Node2D):
	damaging_bodies -= 1


func _on_damage_cooldown():
	_check_deal_damage()


func _on_health_changed():
	_update_health_bar()


func _update_health_bar() -> void:
	health_bar.value = health_component.get_health_percent()


func _on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, owned_upgrades: Dictionary) -> void:
	if ability_upgrade is not AbilityUpgradeWeapon:
		return
	
	var weapon: Node = ability_upgrade.ability_weapon_controller.instantiate()
	%Abilities.add_child(weapon)
