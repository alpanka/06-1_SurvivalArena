extends Node

@export var experience_manager: XPManager
@export var upgrade_selection_scene: PackedScene

var owned_upgrades: Dictionary
var upgrade_array: WeightedTable = WeightedTable.new()


func _ready() -> void:
	_initialize_upgrade_manager()


func _initialize_upgrade_manager() -> void:
	# Connect to level-up signal
	experience_manager.leveled_up.connect(_on_leveled_up)

	# Add initial upgrades with no dependencies
	upgrade_array.add_item(Names.sword_rate_resource, 10)
	upgrade_array.add_item(Names.sword_damage_rate_resource, 10)
	upgrade_array.add_item(Names.axe_weapon_resource, 10)
	upgrade_array.add_item(Names.anvil_weapon_resource, 10)
	upgrade_array.add_item(Names.player_speed_resource, 5)


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
			upgrade_array.remove_item(upgrade)
			#upgrade_array = upgrade_array.filter(
				#func(pool_upgrade):
					#return pool_upgrade.id != upgrade.id)
	
	# Update array if possible
	_update_upgrade_array(upgrade)
	
	# Emit up to date ability dict.
	Signals.ability_upgrade_added.emit(upgrade, owned_upgrades)
	
	#print("Upgrade picked, List: ", owned_upgrades)
	#{"sword_rate": {"resource": <Resource#-9223372000062339726>, "quantity": 3}}


# Update upgrade array with items that might be added later on,
# With item that does have dependencies
func _update_upgrade_array(_chosen_upgrade: AbilityUpgrade) -> void:
	# Axe damage upgrade requires having an axe
	if _chosen_upgrade.id == Names.axe_weapon_resource.id:
		upgrade_array.add_item(Names.axe_damage_rate_resource, 20)
	
	# Anvil count requires having anvil weapon
	if _chosen_upgrade.id == Names.anvil_weapon_resource.id:
		upgrade_array.add_item(Names.anvil_count_resource, 15)


# First version
# Pick unique upgrades to be selected
#func _pick_upgrades() -> Array[AbilityUpgrade]:
	#var chosen_upgrades: Array[AbilityUpgrade] = []
	#var filtered_upgrades = upgrade_array.duplicate()
	#
	#for i in 2:
		## Stop if filtered upgrades array is empty
		#if filtered_upgrades.size() == 0:
			#break
		#
		## Pick a random upgrade from the array
		#var chosen_upgrade: AbilityUpgrade = filtered_upgrades.pick_random()
		#chosen_upgrades.append(chosen_upgrade)
		#
		## Filter out picked upgrade
		#filtered_upgrades = filtered_upgrades.filter(
			#func(upgrade): return upgrade.id != chosen_upgrade.id)
	#
	#return chosen_upgrades


# Pick unique upgrades to be selected
func _pick_upgrades() -> Array[AbilityUpgrade]:
	var chosen_upgrades: Array[AbilityUpgrade] = []
	for i in 2:
		if upgrade_array.items.size() == chosen_upgrades.size():
			break
		var chosen_upgrade = upgrade_array.pick_item(chosen_upgrades)
		chosen_upgrades.append(chosen_upgrade)
		
	return chosen_upgrades


func _on_leveled_up(_current_level: int) -> void:
	var upgrade_selection_screen = upgrade_selection_scene.instantiate()
	var layer_ui = get_tree().get_first_node_in_group("layer_ui")
	
	upgrade_selection_screen.set_upgrade_panels(_pick_upgrades())
	upgrade_selection_screen.upgrade_selected.connect(_on_upgrade_selected)
	layer_ui.add_child(upgrade_selection_screen)


func _on_upgrade_selected(upgrade: AbilityUpgrade):
	_apply_upgrade(upgrade)
