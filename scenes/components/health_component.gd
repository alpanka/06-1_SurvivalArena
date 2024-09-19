class_name HealthComponent
extends Node

@export var health_init: float = 10
var health_current: float

signal health_changed()
signal entity_died(name: String)


func _ready() -> void:
	health_current = health_init


func take_damage(damage_amount: float):
	#print("Damage! ", health_current, " ", damage_amount)
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
