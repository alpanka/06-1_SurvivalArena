extends AudioStreamPlayer


func _ready() -> void:
	self.finished.connect(_on_player_finished)
	$Timer.timeout.connect(_on_timer_timeout)


func _on_player_finished() -> void:
	$Timer.start()


func _on_timer_timeout() -> void:
	self.play()
