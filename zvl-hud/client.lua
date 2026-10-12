ESX = exports["es_extended"]:getSharedObject()

local isNearPump = false
local isFueling = false
local currentFuel = 0.0
local currentCost = 0.0
local currentCash = 1000
local fuelSynced = false
local inBlacklisted = false


function GetFuel(vehicle)
	return DecorGetFloat(vehicle, Config.FuelDecor)
end

--HUD
local zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }
local directions = {
    [0] = 'North Bound',
    [45] = 'West Bound',
    [90] = 'West Bound',
    [135] = 'South Bound',
    [180] = 'South Bound',
    [225] = 'East Bound',
    [270] = 'East Bound',
    [315] = 'North Bound',
    [360] = 'North Bound'
}

local direction = "North Bound"
local bensin = 100
local nos = 0
local uiopen = false
local nosEnabled = false
local colorblind = false
local seatbelt = false
local cruise = false
local atl = false
local engine = false
local GasTank = false
local isCompass = false

local isVehOn = false
local isMotor = false
local namaJalan = ""
local angkakmh = 0
local isSupir = false

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            Citizen.Wait(0)
            bensin = math.ceil(GetVehicleFuelLevel(cache.vehicle))
            isVehOn = true

            if GetVehicleEngineHealth(GetVehiclePedIsIn(PlayerPedId(), false)) < 400.0 then
                engine = true
            else
                engine = false
            end

            if bensin < 20 then
                GasTank = true
            else
                GasTank = false
            end

            if (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()) then
                isSupir = true
            else
                isSupir = false
            end

            if GetVehicleClass(GetVehiclePedIsIn(PlayerPedId(), false)) == 8 then
                isMotor = true
            else
                isMotor = false
            end

            if IsPedInAnyPlane(PlayerPedId()) or IsPedInAnyHeli(PlayerPedId()) then
                atl = string.format("%.1f", GetEntityHeightAboveGround(GetVehiclePedIsIn(PlayerPedId(), false)) * 3.28084)
            end
        else
            isVehOn = false
        end    
        Citizen.Wait(5000)
    end
end)

-- lib.onCache('vehicle', function(vehicle)
--     while true do
--         local ped = PlayerPedId()
--         if IsPedInAnyVehicle(ped, false) then
--         Citizen.Wait(0)
--         bensin = math.ceil(GetVehicleFuelLevel(cache.vehicle))
--         isVehOn = IsVehicleEngineOn(GetVehiclePedIsIn(PlayerPedId(), false))

--         if GetVehicleEngineHealth(GetVehiclePedIsIn(PlayerPedId(), false)) < 400.0 then
--             engine = true
--         else
--         	engine = false
--         end

--         if bensin < 20 then
--             GasTank = true
--         else
--         	GasTank = false
--         end

--         if (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()) then
--             isSupir = true
--         else
--         	isSupir = false
--         end

--         if GetVehicleClass(GetVehiclePedIsIn(PlayerPedId(), false)) == 8 then
--         	isMotor = true
--         else
--         	isMotor = false
--         end

--         if IsPedInAnyPlane(PlayerPedId()) or IsPedInAnyHeli(PlayerPedId()) then
--             atl = string.format("%.1f", GetEntityHeightAboveGround(GetVehiclePedIsIn(PlayerPedId(), false)) * 3.28084)
--         end
--     end
--         Citizen.Wait(100)
--     end
-- end)

local time = "12:00"

RegisterNetEvent("timeheader")
AddEventHandler("timeheader", function(h, m)
    if h < 10 then
        h = "0"..h
    end
    if m < 10 then
        m = "0"..m
    end
    time = h .. ":" .. m
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(100)
        if isVehOn then
            if not uiopen then uiopen = true SendNUIMessage({ open = 1 }) end
            SendNUIMessage({ open = 5 })
            angkakmh = math.ceil(GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 3.6)    

            if isMotor then
                SendNUIMessage({
                  open = 2,
                  mph = angkakmh,
                  fuel = bensin,
                  street = namaJalan,
                  belt = true,
                  cruise = cruise,
                  nos = nos,
                  nosEnabled = nosEnabled,
                  time = time,
                  colorblind = colorblind,
                  atl = atl,
                  engine = engine,
                  GasTank = GasTank,
                })
            else
                SendNUIMessage({
                  open = 2,
                  mph = angkakmh,
                  fuel = bensin,
                  street = namaJalan,
                  belt = seatbelt,
                  cruise = cruise,
                  nos = nos,
                  nosEnabled = nosEnabled,
                  time = time,
                  colorblind = colorblind,
                  atl = atl,
                  engine = engine,
                  GasTank = GasTank,
                })
            end
        else
            if uiopen then
            	if not isCompass then
            		SendNUIMessage({ open = 3, }) 
                	uiopen = false
                end
                cruise = false
                seatbelt = false
                isSupir = false
                atl = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(200)
        if isVehOn then
        	local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))
        	local current_zone = zones[GetNameOfZone(x, y, z)]
        	local var1, var2 = GetStreetNameAtCoord(x, y, z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())

        	if direction then
        		if tostring(GetStreetNameFromHashKey(var2)) == "" then
        			namaJalan = direction .. " | ".. tostring(GetStreetNameFromHashKey(var1)) .." | " .. current_zone
        		else
        			namaJalan = direction .. " | ".. tostring(GetStreetNameFromHashKey(var1)) .." | " .. tostring(GetStreetNameFromHashKey(var2)).." | ".. current_zone
        		end
        	end

            for k,v in pairs(directions)do
                direction = GetEntityHeading(GetPlayerPed(-1))
                if (math.abs(direction - k) < 22.5) then
                    direction = v
                    break
                end
            end
        end    
    end
end)

CreateThread(function()
    while true do
        Wait(0)
        if IsPedInAnyVehicle(PlayerPedId()) then
            if IsControlJustReleased(0, 29) and IsPedInAnyVehicle(PlayerPedId()) and GetVehicleClass(GetVehiclePedIsIn(PlayerPedId(), false)) ~= 8 then
                if seatbelt == false then
                    PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
                    ESX.ShowNotification('Seat Belt Enabled')
                else
                    PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
                    ESX.ShowNotification('Seat Belt Disabled')
                end
                seatbelt = not seatbelt
            end

            if IsControlJustReleased(0, 137) and isSupir then
                if cruise == false then
                    local asu = GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false))
                    local kmh = tostring(math.ceil(asu * 3.6))
                    PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
                    ESX.ShowNotification('Cruise Active at ' .. kmh ..  '/kmh')
                else
                    PlaySoundFrontend(-1, "Faster_Click", "RESPAWN_ONLINE_SOUNDSET", 1)
                    ESX.ShowNotification('Cruise Inactive')
                end
                cruise = not cruise
            end
            if cruise then 
                SetEntityMaxSpeed(cache.vehicle, GetEntitySpeed(cache.vehicle)) 
            else 
                SetEntityMaxSpeed(cache.vehicle, GetVehicleHandlingFloat(GetVehiclePedIsIn(PlayerPedId(), false),"CHandlingData","fInitialDriveMaxFlatVel")) 
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        if not isVehOn and isCompass then
        	if not uiopen then
                uiopen = true
                SendNUIMessage({
                  open = 1,
                })
            end
        	SendNUIMessage({
                open = 4,
                time = time,
                direction = math.floor(calcHeading(-GetFinalRenderedCamRot(0).z % 360)),
            })
        end
    end
end)

---------------------------------
-- Compass shit
---------------------------------

--[[
    Heavy Math Calcs
 ]]--

 local imageWidth = 100 -- leave this variable, related to pixel size of the directions
 local containerWidth = 100 -- width of the image container
 
 -- local width =  (imageWidth / containerWidth) * 100; -- used to convert image width if changed
 local width =  0;
 local south = (-imageWidth) + width
 local west = (-imageWidth * 2) + width
 local north = (-imageWidth * 3) + width
 local east = (-imageWidth * 4) + width
 local south2 = (-imageWidth * 5) + width
 
 function calcHeading(direction)
     if (direction < 90) then
         return lerp(north, east, direction / 90)
     elseif (direction < 180) then
         return lerp(east, south2, rangePercent(90, 180, direction))
     elseif (direction < 270) then
         return lerp(south, west, rangePercent(180, 270, direction))
     elseif (direction <= 360) then
         return lerp(west, north, rangePercent(270, 360, direction))
     end
 end
 
 
 function rangePercent(min, max, amt)
     return (((amt - min) * 100) / (max - min)) / 100
 end
 
 function lerp(min, max, amt)
     return (1 - amt) * min + amt * max
 end
 
--BARHUD
local EVHud = true

local hunger = 100
local thirst = 100
local tension = 0
local drunk = 0

Citizen.CreateThread(
    function()
    Citizen.Wait(500)
    while true do 
        if ESX ~= nil and EVHud then
            local PedId = PlayerPedId()
            local playerTalking = NetworkIsPlayerTalking(PlayerId())
			if GetEntityMaxHealth(PedId) ~= 200 then
				SetEntityMaxHealth(PedId, 200)
				SetEntityHealth(PedId, 200)
			end
                SendNUIMessage({
                    action = "hudtick",
                    show = IsPauseMenuActive(),
                    health = GetEntityHealth(PedId),
                    armor = GetPedArmour(PedId),
                    thirst = thirst,
                    hunger = hunger,
                    drunk = drunk,
					tension = tension,
					voice = playerTalking,
                })
            end  
            Citizen.Wait(1000)
    end
end)

RegisterNetEvent("esx_status:onTick") 
AddEventHandler("esx_status:onTick", function(Status)
    TriggerEvent('esx_status:getStatus', 'hunger', function(status)
        hunger = status.val / 10000  
    end)
    
    TriggerEvent('esx_status:getStatus', 'thirst', function(status)   
        thirst = status.val / 10000  
    end)

	TriggerEvent('esx_status:getStatus', 'drunk', function(status)   
        drunk = status.val / 10000  
    end)

	TriggerEvent('esx_status:getStatus', 'stress', function(status)   
        tension = status.val / 10000  
    end)
end)

RegisterNetEvent('pma-voice:setTalkingMode')
AddEventHandler('pma-voice:setTalkingMode', function(newTalkingRange)
    SendNUIMessage({
        action = "proximity",
        prox = newTalkingRange
    })
end)

Citizen.CreateThread(function()
    local currSpeed = 0.0
    local cruiseSpeed = 999.0
    local prevVelocity = {x = 0.0, y = 0.0, z = 0.0}
    local seatbeltEjectSpeed = 45.0 
    local seatbeltEjectAccel = 100.0

    while true do
        Citizen.Wait(0)
        local player = GetPlayerPed(-1)
        local position = GetEntityCoords(player)
        local vehicle = GetVehiclePedIsIn(player, false)
        
        if IsPedInAnyVehicle(player, false) then
            local vehicleClass = GetVehicleClass(vehicle)
            if IsPedInAnyVehicle(player, false) and vehicleClass ~= 13 then
                local prevSpeed = currSpeed
                currSpeed = GetEntitySpeed(vehicle)

                SetPedConfigFlag(PlayerPedId(), 32, true)
                if not seatbelt then
                    local vehIsMovingFwd = GetEntitySpeedVector(vehicle, true).y > 1.0
                    local vehAcc = (prevSpeed - currSpeed) / GetFrameTime()
                    if (vehIsMovingFwd and (prevSpeed > (seatbeltEjectSpeed/2.237)) and (vehAcc > (seatbeltEjectAccel*9.81))) then
                        SetEntityCoords(player, position.x, position.y, position.z - 0.47, true, true, true)
                        SetEntityVelocity(player, prevVelocity.x, prevVelocity.y, prevVelocity.z)
                        Citizen.Wait(1)
                        SetPedToRagdoll(player, 1000, 1000, 0, 0, 0, 0)
                    else
                        prevVelocity = GetEntityVelocity(vehicle)
                    end
                else
                    DisableControlAction(0, 75, true) -- Disable exit vehicle when stop
                    DisableControlAction(27, 75, true) -- Disable exit vehicle when Driving
                end


            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local dimobil = IsPedInAnyVehicle(playerPed, false)
        if dimobil then
            DisplayRadar(true)
        else
            DisplayRadar(false)
        end
    end
end)