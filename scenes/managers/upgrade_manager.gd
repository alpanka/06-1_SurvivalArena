extends Node

@export var upgrade_array: Array[AbilityUpgrade]
@export var experience_manager: XPManager
@export var upgrade_selection_scene: PackedScene

var owned_upgrades: Dictionary


func _ready() -> void:
	experience_manager.leveled_up.connect(_on_leveled_up)


func _apply_upgrade(upgrade: AbilityUpgrade):
	# Check if we already have this upgrade
	var upgrade_exists = owned_upgrades.has(upgrade.id)
	
	# Update "owned_upgrades" dictionary.
	# Add keys if not already in the dict.
	if not upgrade_exists:
		owned_upgrades[upgrade.id] = {
			"resource": upgrade,
			"quantity": 1
		}
	else:
		owned_upgrades[upgrade.id]["quantity"] += 1
	
	# Remove an upgrade if max allowable quantity is reached
	if upgrade.max_quantity > 0:
		var current_quantity: int = owned_upgrades[upgrade.id]["quantity"]
		
		# Filter out quantity limit reached upgrade 
		if current_quantity == upgrade.max_quantity:
			upgrade_array = upgrade_array.filter(
				func(pool_upgrade):
					return pool_upgrade.id != upgrade.id)
	
	# Emit up to date ability dict.
	Signals.ability_upgrade_added.emit(upgrade, owned_upgrades)
	
	#print("Upgrade picked, List: ", owned_upgrades)
	#{"sword_rate": {"resource": <Resource#-9223372000062339726>, "quantity": 3}}


func _pick_upgrades() -> Array[AbilityUpgrade]:
	var chosen_upgrades: Array[AbilityUpgrade] = []
	var filtered_upgrades = upgrade_array.duplicate()
	
	for i in 2:
		# Stop if filtered upgrades array is empty
		if filtered_upgrades.size() == 0:
			break
		
		# Pick a random upgrade from the array
		var chosen_upgrade: AbilityUpgrade = filtered_upgrades.pick_random()
		chosen_upgrades.append(chosen_upgrade)
		
		# Filter out picked upgrade
		filtered_upgrades = filtered_upgrades.filter(
			func(upgrade): return upgrade.id != chosen_upgrade.id)
	
	return chosen_upgrades


func _on_leveled_up(_current_level: int) -> void:
	var upgrade_selection_screen = upgrade_selection_scene.instantiate()
	var layer_ui = get_tree().get_first_node_in_group("layer_ui")
	
	upgrade_selection_screen.set_upgrade_panels(_pick_upgrades())
	upgrade_selection_screen.upgrade_selected.connect(_on_upgrade_selected)
	layer_ui.add_child(upgrade_selection_screen)


func _on_upgrade_selected(upgrade: AbilityUpgrade):
	_apply_upgrade(upgrade)
