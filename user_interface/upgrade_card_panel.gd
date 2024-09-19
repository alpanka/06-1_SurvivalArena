## Piece of card to be displayed on card upgrade screen
extends Panel

signal card_selected

@export var sample: AbilityUpgrade


func _ready() -> void:
	gui_input.connect(_on_card_clicked)


# Get card details from upgrade_selection_screen
func set_upgrade_labels(upgrade: AbilityUpgrade):
	#print("resource ", upgrade)
	#print(upgrade.name, " ", upgrade.description)
	%UpgradeNameLabel.text = upgrade.name
	%UpgradeDescriptionLabel.text = upgrade.description


func _on_card_clicked(event: InputEvent):
	if event.is_action_pressed("LMB"):
		card_selected.emit()
