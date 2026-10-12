ESX = exports["es_extended"]:getSharedObject()

local ox_inventory = exports.ox_inventory

if Config.UseESX then

	RegisterServerEvent('fuel:pay')
	AddEventHandler('fuel:pay', function(price)
		local xPlayer = ESX.GetPlayerFromId(source)
		local amount = ESX.Math.Round(price)

		if price > 0 then
			ox_inventory:RemoveItem(source, 'money', amount)
		end
	end)
end

RegisterServerEvent('ss-bensin:delbensin')
AddEventHandler('ss-bensin:delbensin', function(id)
	local ox_inventory = exports.ox_inventory
	ox_inventory:RemoveItem(id,'WEAPON_PETROLCAN', 1)
end)

RegisterServerEvent('ss-bensin:getbensin')
AddEventHandler('ss-bensin:getbensin', function(id)
	local ox_inventory = exports.ox_inventory
	ox_inventory:AddItem(id,'WEAPON_PETROLCAN', 1)
end)