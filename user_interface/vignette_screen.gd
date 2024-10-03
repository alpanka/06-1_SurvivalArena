extends CanvasLayer


func _ready() -> void:
	Signals.player_damaged.connect(_on_player_damaged)


func _on_player_damaged() -> void:
	%AnimationPlayer.play("got_hit")
