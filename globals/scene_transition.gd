extends CanvasLayer

signal transitioned_halfway

var skip_emit: bool = false


func scene_transition() -> void:
	%AnimationPlayer.play("default")
	await transitioned_halfway
	skip_emit = true
	%AnimationPlayer.play_backwards("default")


func transition_to_scene(target_scene: PackedScene) -> void:
	scene_transition()
	await transitioned_halfway
	get_tree().change_scene_to_packed(target_scene)


func emit_transitioned_halfway() -> void:
	if skip_emit:
		skip_emit = false
		return
	
	transitioned_halfway.emit()
