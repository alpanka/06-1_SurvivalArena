extends Node


var save_data: Dictionary = {
	"meta_upgrade_currency": 0,
	"meta_upgrades": {},
	"settings": {
		"SFX": 1,
		"MUSIC": 1,
		"WINDOW_MODE": 0
	}
}

# { "meta_upgrade_currency": 0, 
#	"meta_upgrades": 
#		{ "exp_gain": { "quantity": 10 } } }


func _ready() -> void:
	#_on_exp_vial_collected(2000) # For debug, add exp points
	_initialize_meta_progession()
	load_settings()
	print("Opened save file: ", save_data)


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
	var _save_file := FileAccess.open(Names.SAVE_FILE_PATH, FileAccess.WRITE)
	_save_file.store_var(save_data)


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


func get_meta_upgrade_count(upgrade_id: String) -> int:
	if save_data["meta_upgrades"].has(upgrade_id):
		return save_data["meta_upgrades"][upgrade_id]["quantity"]
	else:
		return 0


# Add collected XP amount
func _on_exp_vial_collected(_exp: int) -> void:
	save_data["meta_upgrade_currency"] += _exp


# Save settings parameters to file
func update_settigs(sfx_vol: float, music_vol: float, window_mode: int) -> void:
	save_data["SFX"] = sfx_vol
	save_data["MUSIC"] = music_vol
	save_data["WINDOW_MODE"] = window_mode
	save_file()


# Load settings parameters
func load_settings() -> void:
	# Add settings parameters if they do not exist
	if not save_data.has("settings"):
		save_data["settings"] = {}
		save_data["settings"]["SFX"] = 1
		save_data["settings"]["MUSIC"] = 1
		save_data["settings"]["WINDOW_MODE"] = 0

	# Set saved window mode on launch
	DisplayServer.window_set_mode(save_data["settings"]["WINDOW_MODE"])
	# Set volume values on launch
	_set_bus_volume("SFX", save_data["settings"]["SFX"])
	_set_bus_volume("MUSIC", save_data["settings"]["MUSIC"])


# Set volume
func _set_bus_volume(bus_name: String, volume_lin: float) -> void:
	var bus_index := AudioServer.get_bus_index(bus_name)
	var bus_volume_db := linear_to_db(volume_lin)
	
	AudioServer.set_bus_volume_db(bus_index, bus_volume_db)
