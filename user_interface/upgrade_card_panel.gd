## Piece of card to be displayed on card upgrade screen
extends PanelContainer

signal card_selected

@export var sample: AbilityUpgrade

var played_in_anim: bool = false
var active: bool = true

func _ready() -> void:
	gui_input.connect(_on_card_clicked)
	mouse_entered.connect(_on_mouse_entered)


# Animation to be played as cards area added.
func play_in(delay: float = 0.0) -> void:
	if not active:
		return
	#if delay > 0:
		#await get_tree().create_timer(delay).timeout
	self.modulate = Color.TRANSPARENT
	%AnimationPlayer.play("in")
	
	await  %AnimationPlayer.animation_finished
	played_in_anim = true


func play_discard() -> void:
	%AnimationPlayer.play("discard")


# Get card details from upgrade_selection_screen
func set_upgrade_labels(upgrade: AbilityUpgrade):
	#print("resource ", upgrade)
	#print(upgrade.name, " ", upgrade.description)
	%UpgradeNameLabel.text = upgrade.name
	%UpgradeDescriptionLabel.text = upgrade.description


func _on_card_clicked(event: InputEvent):
	if not active:
		return
	
	if event.is_action_pressed("LMB"):
		%AnimationPlayer.play("selected")
		
		for card in get_tree().get_nodes_in_group("upgrade_card"):
			if card == self:
				continue
			else:
				card.play_discard()
		
		await %AnimationPlayer.animation_finished
		card_selected.emit()


func _on_mouse_entered() -> void:
	if not active:
		return
	
	%AnimationPlayer.play("hover")
