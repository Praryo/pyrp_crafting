Config = {}

Config.CraftingLocation = vector3(947.33, -1250.27, 27.08)

Config.ItemsCrafting = {
	['thermite'] = {
		label = 'Thermite',
		craftingtime = 20000,
		requiredItems = {
			{ item = "scrap_metal", item_label = "Scrap Metal", amount = 25 },
			{ item = "scrap_brakes", item_label = "Scrap Brakes", amount = 15 },
		}
	},
}

-------------------------- PAWNSHOP

Config.PawnLocation = vector3(182.79, -1319.38, 29.32)
Config.PawnBlackMoney = true

Config.PawnItems = {

	['jewels'] = {
		label = 'Jewels',
		min = 50,
		max = 200,
		price = 64
	},
	
	['goldwatch'] = {
		label = 'Gold Watch',
		min = 10,
		max = 15,
		price = 72
	},
	
}
