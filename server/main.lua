ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('pyrp_crafting:checkCrafting')
AddEventHandler('pyrp_crafting:checkCrafting', function(itemId)
	local pyrp = source
	local xPlayer = ESX.GetPlayerFromId(pyrp)
	local getPlayerInv = xPlayer.getInventoryItem()
	local requiredItems = Config.ItemsCrafting[itemId].requiredItems
	local canCraft = false
	
	for k,v in pairs(requiredItems) do
		if xPlayer.getInventoryItem(v.item).count >= v.amount then
			canCraft = true
		else
			canCraft = false
			break
		end
	end
	
	if canCraft then
		TriggerClientEvent('pyrp_crafting:startCrafting', xPlayer.source, itemId)
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'You don\'t have the required items for crafting.', length = 5000 })
	end
end)

RegisterServerEvent('pyrp_crafting:giveCraftedItem')
AddEventHandler('pyrp_crafting:giveCraftedItem', function(itemId)
	local pyrp = source
	local xPlayer = ESX.GetPlayerFromId(pyrp)
	local requiredItems = Config.ItemsCrafting[itemId].requiredItems
	for k,v in pairs(requiredItems) do
		xPlayer.removeInventoryItem(v.item, v.amount)
	end
	xPlayer.addInventoryItem(itemId, 1)
	TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'Crafting successful!', length = 5000 })
end)

--------------------- PAWNSHOP

RegisterServerEvent('pyrp_crafting:sellPawnshop')
AddEventHandler('pyrp_crafting:sellPawnshop', function(itemName, itemAmount)
	local pyrp = source
	local xPlayer = ESX.GetPlayerFromId(pyrp)
	local priceMultiplier = Config.PawnItems[itemName].price * itemAmount
	
	if xPlayer.getInventoryItem(itemName).count >= itemAmount then
		if Config.PawnBlackMoney then
			xPlayer.addAccountMoney('black_money', priceMultiplier)
		else
			xPlayer.addMoney(priceMultiplier)
		end
		xPlayer.removeInventoryItem(itemName, itemAmount)
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'inform', text = 'You\'ve sold '..Config.PawnItems[itemName].label..' for $'..priceMultiplier..'', length = 5000 })
	else
		TriggerClientEvent('mythic_notify:client:SendAlert', xPlayer.source, { type = 'error', text = 'You do not have more of this item.', length = 5000 })
	end
end)
