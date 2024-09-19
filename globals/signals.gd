extends Node

## Signal to inform that an XP vial is collected
signal exp_vial_collected(xp: float)

## Signal to inform that an upgrade has been selected
signal ability_upgrade_added(upgrade: AbilityUpgrade, owned_upgrades: Dictionary)
