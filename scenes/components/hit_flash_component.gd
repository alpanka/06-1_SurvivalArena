class_name HitFlashComponent
extends Node

@export var health_component: HealthComponent
@export var sprite: Sprite2D
@export var hit_flash_material: ShaderMaterial


var hit_flash_tween: Tween


func _ready() -> void:
	_initialize_component()


func _initialize_component() -> void:
	health_component.health_changed.connect(_on_damage_received)
	sprite.material = hit_flash_material


func _on_damage_received() -> void:
	# Check if it already exists
	if hit_flash_tween != null and hit_flash_tween.is_valid():
		hit_flash_tween.kill()
	
	(sprite.material as ShaderMaterial).set_shader_parameter("alpha_percent", 1.0)
	
	hit_flash_tween = create_tween()
	hit_flash_tween.tween_property(sprite.material, "shader_parameter/alpha_percent", 0.0, 0.3)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_CUBIC)
	
