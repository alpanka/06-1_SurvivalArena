extends Node

#region SCENES
## Main menu
const main_menu_scene: PackedScene = preload("res://user_interface/main_menu.tscn")

## Main game scene
const main_game_scene: PackedScene = preload("res://scenes/levels/main_scene.tscn")

## Settings menu scene
const settings_menu_scene: PackedScene = preload("res://user_interface/settings_menu.tscn")

## Pause menu scene
const pause_menu_scene: PackedScene = preload("res://user_interface/pause_menu.tscn")

## Meta Upgrade Card Scene
const meta_card_scene: PackedScene = preload("res://user_interface/upgrade_meta_card_panel.tscn")

## Meta upgrades menu scene
const meta_selection_menu_scene: PackedScene = preload("res://user_interface/upgrade_meta_selection_menu.tscn")

## Floating Text Scene
const floating_text_scene: PackedScene = preload("res://user_interface/floating_text.tscn")
#endregion


#region UPGRADE RESOURCES

## Anvil weapon resource
const anvil_weapon_resource: AbilityUpgrade = preload("res://resources/upgrades/weapon/anvil_weapon.tres")

## Anvil count upgrade resource
const anvil_count_resource: AbilityUpgrade = preload("res://resources/upgrades/anvil_count.tres")

## Axe weapon resource
const axe_weapon_resource: AbilityUpgrade = preload("res://resources/upgrades/weapon/axe_weapon.tres")

## Sword rate resource
const sword_rate_resource: AbilityUpgrade = preload("res://resources/upgrades/sword_rate.tres")

## Sword damage rate resource
const sword_damage_rate_resource: AbilityUpgrade = preload("res://resources/upgrades/sword_damage.tres")

## Axe damage rate resource
const axe_damage_rate_resource: AbilityUpgrade = preload("res://resources/upgrades/axe_damage.tres")

## Player speed upgrade resource
const player_speed_resource: AbilityUpgrade = preload("res://resources/upgrades/player_speed.tres")

#endregion


#region CONSTANTS

# Save file location
const SAVE_FILE_PATH: String = "user://game.save"

#endregion
