extends Node2D

@export var health_component: HealthComponent
@export var sprite: Sprite2D


func _ready() -> void:
	health_component.entity_died.connect(_on_entity_died)
	$GPUParticles2D.texture = sprite.texture


func _on_entity_died(_entity_name: String) -> void:
	if owner == null or owner is not Node2D:
		return
	
	# Get dying enemy's position
	var spawn_position: Vector2 = owner.global_position
	
	# Remove from tree then re-add then set position
	var layer_entities: Node = get_tree().get_first_node_in_group("layer_entities")
	get_parent().remove_child(self)
	self.global_position = spawn_position
	layer_entities.add_child(self)
	$AnimationPlayer.play("default")
	$RandomAudioPlayerComponent.play_random_audio()
