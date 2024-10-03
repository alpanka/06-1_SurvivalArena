class_name HealthComponent
extends Node

signal health_changed()
signal entity_died(name: String)

@export var damage_cooldown: float = 0.3
@export var health_init: float = 10

var health_current: float
var damageable: bool = true

func _ready() -> void:
	health_current = health_init


func take_damage(damage_amount: float):
	#print(owner.name, " ", health_current - damage_amount, " health left!")
	health_current = max(health_current - damage_amount, 0)
	health_changed.emit()
	Callable(_check_entity_death).call_deferred()


func get_health_percent() -> float:
	if health_current == 0:
		return 0
	return health_current/health_init


func _check_entity_death():
	if health_current == 0:
		#print("Died ", owner.name)
		entity_died.emit(owner.name)
		owner.queue_free()
