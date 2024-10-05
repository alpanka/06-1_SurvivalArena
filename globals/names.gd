extends Node

#region SCENES
@export_subgroup("SCENES")
## Main menu
@export var main_menu_scene: PackedScene = preload("res://user_interface/main_menu.tscn")

## Main game scene
@export var main_game_scene: PackedScene = preload("res://scenes/levels/main_scene.tscn")

## Settings menu scene
@export var settings_menu_scene: PackedScene = preload("res://user_interface/settings_menu.tscn")

## Pause menu scene
@export var pause_menu_scene: PackedScene = preload("res://user_interface/pause_menu.tscn")

## Floating Text Scene
@export var floating_text_scene: PackedScene = preload("res://user_interface/floating_text.tscn")
#endregion


#region UPGRADE RESOURCES

@export_subgroup("UPGRADES")
## Axe weapon resource
@export var axe_weapon_resource: AbilityUpgrade = preload("res://resources/upgrades/weapon/axe_weapon.tres")

## Sword rate resource
@export var sword_rate_resource: AbilityUpgrade = preload("res://resources/upgrades/sword_rate.tres")

## Sword damage rate resource
@export var sword_damage_rate_resource: AbilityUpgrade = preload("res://resources/upgrades/sword_damage.tres")

## Axe damage rate resource
@export var axe_damage_rate_resource: AbilityUpgrade = preload("res://resources/upgrades/axe_damage.tres")

## Player speed upgrade resource
@export var player_speed_resource: AbilityUpgrade = preload("res://resources/upgrades/player_speed.tres")

#endregion


#region CONSTANTS
# Save file location
const SAVE_FILE_PATH: String = "user://game.save"
#endregion
