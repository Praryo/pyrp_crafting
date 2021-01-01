ESX = nil

function Draw3DText(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local isCrafting = false

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(GetPlayerPed(-1))
        local isClose = false

		local craft_dist = GetDistanceBetweenCoords(playerCoords, Config.CraftingLocation.x, Config.CraftingLocation.y, Config.CraftingLocation.z, 1)

		if craft_dist <= 2.0 and not isCrafting then
			isClose = true
			Draw3DText(Config.CraftingLocation.x, Config.CraftingLocation.y, Config.CraftingLocation.z, "[E] Crafting Menu")
			if IsControlJustReleased(0, 38) then
				CraftingMenu()
			end
		end        


        if not isClose then
            Citizen.Wait(1000)
        end


    end
end)

function CraftingMenu()
	local elements = {}
	for k,v in pairs(Config.ItemsCrafting) do
		table.insert(elements, {label = v.label, value = k})
	end
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'crafting_menu', {
        title    = 'Crafting Menu',
        align    = 'center',
        elements = elements
    }, function(data, menu)
        menu.close()
		CheckCrafting(data.current.value)
    end, function(data, menu)
        menu.close()
    end) 
end

function CheckCrafting(item)
	local elements = {
        { label = "View Recipe", value = "view_recipe" },
        { label = "Craft Item", value = "craft_item" },
    }
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'crafting_info', {
        title    = Config.ItemsCrafting[item].label .. ' Crafting Information',
        align    = 'center',
        elements = elements
    }, function(data, menu)
        menu.close()

        if data.current.value == "view_recipe" then
			ViewRecipe(item)
        elseif data.current.value == "craft_item" then
			TriggerServerEvent('pyrp_crafting:checkCrafting', item)
        end

    end, function(data, menu)
        menu.close()
    end)  
end

function ViewRecipe(item)
	local elements = {}
	for k,v in pairs(Config.ItemsCrafting[item].requiredItems) do
		table.insert(elements, {label = v.amount ..'x ' ..v.item_label})
	end
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'crafting_recipe', {
        title    = Config.ItemsCrafting[item].label .. ' Recipe',
        align    = 'center',
        elements = elements
    }, function(data, menu)
        menu.close()
    end, function(data, menu)
        menu.close()
    end) 
end

RegisterNetEvent('pyrp_crafting:startCrafting')
AddEventHandler('pyrp_crafting:startCrafting', function(item)
	isCrafting = true
	StartCrafting(item)
end)

function StartCrafting(item)
	TriggerEvent("mythic_progbar:client:progress", {
        name = "unique_action_name",
        duration = Config.ItemsCrafting[item].craftingtime,
        label = "Crafting Item...",
        useWhileDead = false,
        canCancel = false,
        controlDisables = {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        },
        animation = {
            animDict = "mini@repair",
            anim = "fixing_a_ped",
        }
    }, function(status)
        if not status then
            isCrafting = false
			TriggerServerEvent('pyrp_crafting:giveCraftedItem', item)
			StopAnimTask(GetPlayerPed(-1), "mini@repair", "fixing_a_ped", 1.0)
        end
    end)
end

------------------------ PAWN SHOP

Citizen.CreateThread(function()

    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(GetPlayerPed(-1))
        local isClose = false

		local pawn_dist = GetDistanceBetweenCoords(playerCoords, Config.PawnLocation.x, Config.PawnLocation.y, Config.PawnLocation.z, 1)

		if pawn_dist <= 2.0 then
			isClose = true
			Draw3DText(Config.PawnLocation.x, Config.PawnLocation.y, Config.PawnLocation.z, "[E] Access Pawnshop")
			if IsControlJustReleased(0, 38) then
				PawnshopMenu()
			end
		end        


        if not isClose then
            Citizen.Wait(1000)
        end


    end
end)


function PawnshopMenu()
	local elements = {}
	for k,v in pairs(Config.PawnItems) do
		table.insert(elements, {label = v.label .. ' | $' .. v.price, item = k, type = 'slider', value = v.min, min = v.min, max = v.max})
	end
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'pawnshop', {
        title    = 'Pawnshop',
        align    = 'center',
        elements = elements
    }, function(data, menu)
        menu.close()
		TriggerServerEvent('pyrp_crafting:sellPawnshop', data.current.item, data.current.value)
    end, function(data, menu)
        menu.close()
    end) 
end


function CreateBlipCircle(coords, text, color, sprite)
	blip = AddBlipForCoord(coords)

	SetBlipSprite (blip, sprite)
	SetBlipScale  (blip, 1.0)
	SetBlipColour (blip, color)
	SetBlipAsShortRange(blip, true)

	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(text)
	EndTextCommandSetBlipName(blip)
end

Citizen.CreateThread(function()
	CreateBlipCircle(vector3(Config.PawnLocation.x, Config.PawnLocation.y, Config.PawnLocation.z), 'Pawnshop', 3, 272)
end)
