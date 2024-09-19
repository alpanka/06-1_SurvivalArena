class_name ArenaTimerManager
extends Node

signal difficulty_increased(difficulty: int)

@export var endgame_scene: PackedScene
@export var level_duration: float = 60 # Time for level to be done. In seconds

@onready var level_timer: Timer = $LevelTimer
@onready var difficulty_timer: Timer = $DifficultyTimer

var difficulty_timer_duration: float = 5.0
var difficulty: int = 0


func _ready() -> void:
	_initialize_level_timer()
	_initialize_difficulty_timer()


func _initialize_level_timer() -> void:
	level_timer.timeout.connect(_on_level_timer_timeout)
	level_timer.autostart = true
	level_timer.one_shot = true
	level_timer.wait_time = level_duration
	level_timer.start()


func _initialize_difficulty_timer() -> void:
	difficulty_timer.timeout.connect(_on_difficulty_timer_timeout)
	difficulty_timer.autostart = true
	difficulty_timer.one_shot = false
	difficulty_timer.wait_time = difficulty_timer_duration
	difficulty_timer.start()


## Return how many seconds has passed
func get_elapsed_time() -> float:
	return level_timer.wait_time - level_timer.time_left


## Run endgame screen with WON setting
func _on_level_timer_timeout() -> void:
	var endgame_screen = endgame_scene.instantiate() as EndGameScreen
	endgame_screen.endgame_type = endgame_screen.TYPE.WON
	add_child(endgame_screen)


## Emit difficulty increase every xx difficulty duration
func _on_difficulty_timer_timeout() -> void:
	difficulty += 1
	difficulty_increased.emit(difficulty)
