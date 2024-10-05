extends Node

#region SCENES
## Main menu
var main_menu_scene: PackedScene = preload("res://user_interface/main_menu.tscn")

## Main game scene
var main_game_scene: PackedScene = preload("res://scenes/levels/main_scene.tscn")

## Settings menu scene
var settings_menu_scene: PackedScene = preload("res://user_interface/settings_menu.tscn")

## Pause menu scene
var pause_menu_scene: PackedScene = preload("res://user_interface/pause_menu.tscn")

## Meta Upgrade Card Scene
var upgrade_meta_card_scene: PackedScene = preload("res://user_interface/upgrade_meta_card_panel.tscn")

## Floating Text Scene
var floating_text_scene: PackedScene = preload("res://user_interface/floating_text.tscn")
#endregion


#region UPGRADE RESOURCES

## Axe weapon resource
var axe_weapon_resource: AbilityUpgrade = preload("res://resources/upgrades/weapon/axe_weapon.tres")

## Sword rate resource
var sword_rate_resource: AbilityUpgrade = preload("res://resources/upgrades/sword_rate.tres")

## Sword damage rate resource
var sword_damage_rate_resource: AbilityUpgrade = preload("res://resources/upgrades/sword_damage.tres")

## Axe damage rate resource
var axe_damage_rate_resource: AbilityUpgrade = preload("res://resources/upgrades/axe_damage.tres")

## Player speed upgrade resource
var player_speed_resource: AbilityUpgrade = preload("res://resources/upgrades/player_speed.tres")

#endregion


#region CONSTANTS

# Save file location
const SAVE_FILE_PATH: String = "user://game.save"

#endregion
