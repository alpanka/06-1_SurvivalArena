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

	_handle_floating_damage_text(hitbox.damage_amount)


# Adds a floating text to show damage
func _handle_floating_damage_text(damage) -> void:
	var floating_text = Names.floating_text_scene.instantiate() as FloatingText
	var layer_ui: Node = get_tree().get_first_node_in_group("layer_ui")
	
	floating_text.global_position = global_position + (Vector2.UP * 16)
	layer_ui.add_child(floating_text)
	floating_text.initialize_floating(str(damage))
	
