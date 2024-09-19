extends CanvasLayer

@export var arena_time_manager: Node
@onready var level_time_label: Label = %LevelTimeLabel

var elapsed_time_str: String
var elapsed_time_sec: float
var minutes: int
var seconds: int


func _process(delta: float) -> void:
	_update_elapsed_time_label()


func _update_elapsed_time_label() -> void:
	elapsed_time_sec = arena_time_manager.get_elapsed_time()
	
	minutes = floor(elapsed_time_sec/60)
	seconds = floor(elapsed_time_sec - (minutes*60))
	
	elapsed_time_str = "%02d:%02d" % [minutes, seconds]
	
	level_time_label.text = elapsed_time_str
