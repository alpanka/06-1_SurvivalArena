## Show possible upgrade cards on level up
## Show from upgrade_manager
extends CanvasLayer

signal upgrade_selected

@export var upgrade_card_panel_scene: PackedScene


# Pause upon _ready()
func _ready() -> void:
	get_tree().paused = true


func set_upgrade_panels(upgrades: Array[AbilityUpgrade]):
	#print("array: ", upgrades)
	for upgrade in upgrades:
		var card_panel = upgrade_card_panel_scene.instantiate()
		card_panel.set_upgrade_labels(upgrade)
		card_panel.card_selected.connect(_on_card_selected.bind(upgrade))
		%CardContainer.add_child(card_panel)


# Emit selected upgrade to upgrade_manager then unpause
func _on_card_selected(upgrade: AbilityUpgrade):
	upgrade_selected.emit(upgrade)
	get_tree().paused = false
	queue_free()
