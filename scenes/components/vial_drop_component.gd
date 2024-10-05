extends Node

@export_range(0, 1) var drop_chance: float = 0.50

@export var vial_scene: PackedScene
@export var health_component: HealthComponent

var owner_node: Node2D


func _ready() -> void:
	_update_drop_change()
	health_component.entity_died.connect(_on_entity_died)
	owner_node = get_owner()


func _on_entity_died(_name: String) -> void:
	# Check drop chance
	var chance: float = randf()
	if chance >= drop_chance:
		return
	
	var vial_instance = vial_scene.instantiate() as Node2D
	var layer_entities = get_tree().get_first_node_in_group("layer_entities")
	vial_instance.global_position = owner_node.global_position
	layer_entities.add_child(vial_instance)


# Update vial drop chance
func _update_drop_change() -> void:
	var exp_upgrade_count: int = MetaProgression.get_meta_upgrade_count("exp_gain")
	
	if exp_upgrade_count > 0:
		drop_chance += 0.1 * exp_upgrade_count
		print(drop_chance)
