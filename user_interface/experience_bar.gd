extends CanvasLayer


@export var experience_manager: XPManager
@onready var xp_bar: ProgressBar = %XPBar


func _ready() -> void:
	xp_bar.value = 0
	experience_manager.experience_updated.connect(_update_xp_label)


func _update_xp_label(current_xp: float, target_xp: float) -> void:
	var xp_percent = current_xp / target_xp
	xp_bar.value = xp_percent
