class_name XPManager
extends Node

signal experience_updated(current_xp: float, target_xp: float)
signal leveled_up(current_level: int)

const XP_LEVEL_STEP: float = 5.0

var current_level: int = 1
var current_xp: float = 0
var target_xp: float = 2


func _ready() -> void:
	Signals.exp_vial_collected.connect(_on_experience_vial_collected)

# Update XP when vial collected
# Update level when target_xp reached
func _on_experience_vial_collected(xp: float):
	current_xp = min(current_xp + xp, target_xp)
	experience_updated.emit(current_xp, target_xp)
	
	if current_xp == target_xp:
		print("Level up! ", current_level+1)
		
		current_level += 1
		target_xp += XP_LEVEL_STEP
		current_xp = 0

		experience_updated.emit(current_xp, target_xp)
		leveled_up.emit(current_level)
