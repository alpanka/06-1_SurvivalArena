extends Node2D


func _ready() -> void:
	$PickupArea.area_entered.connect(_on_pickup_area_entered)


func _on_pickup_area_entered(area: Area2D) -> void:
	Signals.exp_vial_collected.emit(1.0)
	queue_free()
