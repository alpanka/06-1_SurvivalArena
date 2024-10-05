extends Node

var save_data: Dictionary = {
	"meta_upgrade_currency": 0,
	"meta_upgrades": {}
}


func _ready() -> void:
	_initialize_meta_progession()
	print(save_data)


func _initialize_meta_progession() -> void:
	Signals.exp_vial_collected.connect(_on_exp_vial_collected)
	#save_data["meta_upgrade_currency"] = 1000
	#save_file()
	load_save_file()


func load_save_file() -> void:
	if not FileAccess.file_exists(Names.SAVE_FILE_PATH):
		return
	
	var load_file := FileAccess.open(Names.SAVE_FILE_PATH, FileAccess.READ)
	save_data = load_file.get_var()


func save_file() -> void:
	var save_file := FileAccess.open(Names.SAVE_FILE_PATH, FileAccess.WRITE)
	save_file.store_var(save_data)


# Save passed upgrade
func add_meta_upgrade(upgrade: MetaUpgradeResource) -> void:
	# Check if upgrade already exists
	# If not, add an entry
	if not save_data["meta_upgrades"].has(upgrade.id):
		save_data["meta_upgrades"][upgrade.id] = {
			"quantity": 0
		}

	save_data["meta_upgrades"][upgrade.id]["quantity"] += 1
	
	# AutoSave
	save_file()


# Add collected XP amount
func _on_exp_vial_collected(_exp: int) -> void:
	save_data["meta_upgrade_currency"] += _exp
