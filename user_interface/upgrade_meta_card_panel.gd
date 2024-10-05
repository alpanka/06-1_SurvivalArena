## Piece of card to be displayed on card upgrade screen
extends PanelContainer

#signal card_selected

@export var sample: AbilityUpgrade

var upgrade: MetaUpgradeResource
var played_in_anim: bool = false
#var active: bool = true


func _ready() -> void:
	%PurchaseButton.pressed.connect(_on_purchase_button_pressed)


# Get card details from upgrade_selection_screen
func set_upgrade_labels(upgrade: MetaUpgradeResource):
	# Pass selected upgrade and update xp progress bar
	self.upgrade = upgrade
	_update_exp_progress()
	#print("resource ", upgrade)
	#print(upgrade.name, " ", upgrade.description)
	%UpgradeNameLabel.text = upgrade.title
	%UpgradeDescriptionLabel.text = upgrade.description


# Update XP progress bar value
# (owned XP amount)/(upgrade XP amount)
func _update_exp_progress() -> void:
	var owned_currency = MetaProgression.save_data["meta_upgrade_currency"]
	var percent: float = owned_currency / upgrade.exp_cost
	percent = min(percent, 1.0)
	# Update progess bar
	%XPProgressBar.value = percent
	
	# Update label text
	%XPLabel.text = str(owned_currency) + "/" + str(upgrade.exp_cost)
	
	# Disable purchase button if not enough xp
	%PurchaseButton.disabled = percent < 1


func _on_purchase_button_pressed() -> void:
	if upgrade == null:
		push_warning("upgrade is null!")
		return
	
	# Add the upgrade to owned upgrades
	MetaProgression.add_meta_upgrade(upgrade)
	
	# Update owned XP and AutoSave
	MetaProgression.save_data["meta_upgrade_currency"] -= upgrade.exp_cost
	MetaProgression.save_file()
	
	# Update all cards value
	get_tree().call_group("upgrade_meta_card", "_update_exp_progress")
	
	%AnimationPlayer.play("selected")


## Animation to be played as cards area added.
#func play_in(delay: float = 0.0) -> void:
	#if not active:
		#return
	##if delay > 0:
		##await get_tree().create_timer(delay).timeout
	#self.modulate = Color.TRANSPARENT
	#%AnimationPlayer.play("in")
	#
	#await  %AnimationPlayer.animation_finished
	#played_in_anim = true


#func _on_mouse_entered() -> void:
	#if not active:
		#return
	#
	#%AnimationPlayer.play("hover")