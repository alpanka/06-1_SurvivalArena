class_name Player
extends CharacterBody2D

@onready var health_component: HealthComponent = $Managers/HealthComponent
@onready var damage_cooldown: Timer = $Managers/DamageCooldown
@onready var health_bar: ProgressBar = $HealthBar
@onready var visuals: Node2D = $Visuals
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@onready var velocity_component: VelocityComponent = $Managers/VelocityComponent
@onready var health_regen_timer: Timer = $Managers/HealthRegenTimer


var direction: Vector2
#var speed_current: float
var speed_init: float

#var smoothing: float = 10
#var smoothing_multiplier: float
#var target_velocity: Vector2

var damaging_bodies: int = 0

func _ready() -> void:
	_initialize_player()


func _process(delta: float) -> void:
	#target_velocity = direction * speed_current
	#smoothing_multiplier = 1 - exp(- smoothing * delta)
	#
	#if direction:
		#velocity = velocity.lerp(target_velocity, smoothing_multiplier)
	#else:
		#velocity = velocity.lerp(Vector2.ZERO, 2 * smoothing_multiplier)
	#
	#move_and_slide()
	direction = _get_movement_vector()
	velocity_component._accelerate(direction)
	velocity_component.chase_player(self)
	
	# Play animation based on direction
	if direction:
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("RESET")
	
	# Flip Visuals/Sprite2D based on direction.x
	var move_sign: int = sign(direction.x)
	if move_sign != 0:
		visuals.scale.x = move_sign


func _initialize_player() -> void:
	speed_init = velocity_component.max_speed
	_update_health_bar()
	
	hurtbox_component.body_entered.connect(_on_enemy_body_entered)
	hurtbox_component.body_exited.connect(_on_enemy_body_exited)
	damage_cooldown.timeout.connect(_on_damage_cooldown)
	health_regen_timer.timeout.connect(_on_health_regen_timer_timeout)
	health_component.health_changed.connect(_on_health_changed)
	Signals.ability_upgrade_added.connect(_on_ability_upgrade_added)


func _get_movement_vector() -> Vector2:
	var movement_x: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	var movement_y: float = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	return Vector2(movement_x, movement_y).normalized()


func _check_deal_damage():
	if damaging_bodies == 0 or not damage_cooldown.is_stopped():
		return

	health_component.take_damage(1)
	damage_cooldown.start()


func _on_enemy_body_entered(body: Node2D):
	damaging_bodies += 1
	_check_deal_damage()


func _on_enemy_body_exited(body: Node2D):
	damaging_bodies -= 1


func _on_damage_cooldown():
	_check_deal_damage()


func _on_health_changed():
	_update_health_bar()
	Signals.player_damaged.emit()
	%RandomAudioPlayerComponent.play_random_audio()


func _update_health_bar() -> void:
	health_bar.value = health_component.get_health_percent()


func _on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, owned_upgrades: Dictionary) -> void:
	# Check if upgrade is a weapon
	if ability_upgrade is AbilityUpgradeWeapon:
		var weapon: Node = ability_upgrade.ability_weapon_controller.instantiate()
		%Abilities.add_child(weapon)
	elif ability_upgrade.id == Names.player_speed_resource.id:
		var speed_extra = 0.1 * speed_init * owned_upgrades[Names.player_speed_resource.id]["quantity"]
		velocity_component.max_speed = speed_init + speed_extra


func _on_health_regen_timer_timeout() -> void:
	var health_regen_quantity := MetaProgression.get_meta_upgrade_count("health_regeneration")
	if health_regen_quantity <= 0:
		return
	
	health_component.heal_entity(1 * health_regen_quantity)
