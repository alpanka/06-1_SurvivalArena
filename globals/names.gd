extends Node

@export_subgroup("SCENES")
## Floating Text Scene
@export var floating_text_scene: PackedScene = preload("res://user_interface/floating_text.tscn")

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

#endregion
