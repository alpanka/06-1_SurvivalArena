extends Node

## XP vial is collected
signal exp_vial_collected(xp: float)

## Upgrade has been selected
signal ability_upgrade_added(upgrade: AbilityUpgrade, owned_upgrades: Dictionary)

## Player damaged
signal player_damaged()
