extends CanvasLayer

@export var meta_upgrades: Array[MetaUpgradeResource] = []


func _ready() -> void:
	_initialize_meta_cards()


func _initialize_meta_cards() -> void:
	for upgrade in meta_upgrades:
		var meta_instance = Names.upgrade_meta_card_scene.instantiate()
		%MetaGridContainer.add_child(meta_instance)
		meta_instance.set_upgrade_labels(upgrade)
