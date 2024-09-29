class_name FloatingText
extends Node2D


func _ready() -> void:
	pass


func initialize_floating(text: String) -> void:
	# Set label text
	$FloatingLabel.text = text

	# Set tween
	var tween_jump: Tween = get_tree().create_tween()
	var tween_scale: Tween = get_tree().create_tween()
	tween_jump.set_parallel(true)
	
	var target_pos_1: Vector2 = global_position + (Vector2.UP * 16)
	var target_pos_2: Vector2 = global_position + (Vector2.UP * 48)
	
	# First bump
	tween_jump.tween_property(self, "global_position", target_pos_1, 0.3)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_CUBIC)
	
	# Second bump
	tween_jump.tween_property(self, "global_position", target_pos_2, 0.5)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_CUBIC)
	tween_jump.chain()

	# First scale
	tween_scale.tween_property(self, "scale", (Vector2.ONE * 1.5), 0.15)\
	.set_ease(Tween.EASE_OUT)\
	.set_trans(Tween.TRANS_CUBIC)

	# Second scale
	tween_scale.tween_property(self, "scale", Vector2.ONE, 0.15)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_CUBIC)
	tween_scale.chain()

	tween_jump.tween_callback(queue_free)
