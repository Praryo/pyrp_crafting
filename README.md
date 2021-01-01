# pyrp_crafting
ESX Praryo RP Crafting & Pawnshop

### Requirements
------------
- [es_extended](https://github.com/esx-framework/es_extended/releases)
- [mythic_notify](https://github.com/JayMontana36/mythic_notify)
- [mythic_progbar](https://github.com/HalCroves/mythic_progbar)

### Setup

This resource requires ESX to be installed properly, it means that you must have setted up items. This script is fully configurable in the `config.lua` file

### Configuration Guide

## Crafting
```lua

Items and recipes are defined in this structure.
['thermite'] = {
	label = 'Thermite',
	craftingtime = 20000,
	requiredItems = {
		{ item = "scrap_metal", item_label = "Scrap Metal", amount = 25 },
		{ item = "scrap_brakes", item_label = "Scrap Brakes", amount = 15 },
	}
},
```

The `thermite` is the item name given in your items table in your database, `label` is in your choice, it can be anything since it is just a label to be shown in the esx menu. The next one is the `crafting time`, the given value is milliseconds so 20000 is 20 secs crafting time. In the `requireditems`, these are the ingridients. You can add more ingridients here as much as you want.

## Pawnshop

```lua
['jewels'] = {
	label = 'Jewels',
	min = 50,
	max = 200,
	price = 64
},
```

This is the same as the crafting configuration, the `min` is the minimum amount that a person can sell and the `max` is the maximum that a player can sell. The `price` is per piece of the item given.
