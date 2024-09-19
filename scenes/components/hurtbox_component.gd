class_name HurtboxComponent
extends Area2D

@export var health_component: HealthComponent


func _ready() -> void:
	area_entered.connect(_on_hurtbox_area_entered)


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area is not HitboxComponent:
		return
	
	if health_component == null:
		push_warning("health_component is null!")
		return
	
	var hitbox: HitboxComponent = area
	health_component.take_damage(hitbox.damage_amount)
