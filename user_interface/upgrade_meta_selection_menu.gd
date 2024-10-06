extends CanvasLayer

@export var meta_upgrades: Array[MetaUpgradeResource] = []
@export var debug: bool = false

func _ready() -> void:
	_initialize_meta_cards()


func _initialize_meta_cards() -> void:
	%BackButton.pressed.connect(_on_back_button_pressed)
	
	# Clear dummy cards
	if not debug:
		for child in %MetaGridContainer.get_children():
			child.queue_free()
	
	for upgrade in meta_upgrades:
		var meta_instance = Names.meta_card_scene.instantiate()
		%MetaGridContainer.add_child(meta_instance)
		meta_instance.set_upgrade_labels(upgrade)


func _on_back_button_pressed() -> void:
	SceneTransition.transition_to_scene(Names.main_menu_scene)
