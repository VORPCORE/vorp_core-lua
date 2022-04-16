------------------------------------------------------------------------------------------------------------
--------------------------------------------- ADMIN ACTIONS ------------------------------------------------

function TeleportAndFoundGroundAsync(tpCoords)
    local groundZ = 0.0
    local foundGround = false
    local wayPoint = GetWaypointCoords()
    for i = 0, 1000 do
        SetEntityCoords(PlayerPedId(), tpCoords.x, tpCoords.y, i, true, true, true, false)
        foundGround = GetGroundZAndNormalFor_3dCoord(tpCoords.x, tpCoords.y, i, groundZ, normal)
        Citizen.Wait(1)
        if foundGround then
            SetEntityCoords(PlayerPedId(), tpCoords.x, tpCoords.y, i, true, true, true, false)
            break
        end
    end
end



function TeleportToWaypoint()
	local player = PlayerPedId()
	local wayPoint = GetWaypointCoords()

	if (wayPoint.x == 0 and wayPoint.y == 0) then
        TriggerEvent("vorp:TipRight", Config.Langs.wayPoint, 3000) 
	else

       
        local height = 1

        for height = 1, 1000 do
            SetEntityCoords(player, wayPoint.x, wayPoint.y, height + 0.0)
            local foundground, groundZ, normal = GetGroundZAndNormalFor_3dCoord(wayPoint.x, wayPoint.y, height + 0.0)
            if foundground then
                SetEntityCoords(player, wayPoint.x, wayPoint.y, height + 0.0)
                
                break
            end
            Wait(25)
        end

     
	end
end



function GetVehicleInDirection()
	local playerPed    = PlayerPedId()
	local playerCoords = GetEntityCoords(playerPed)
	local inDirection  = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
	local rayHandle    = StartExpensiveSynchronousShapeTestLosProbe(playerCoords, inDirection, 10, playerPed, 0)
	local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

	if hit == 1 and GetEntityType(entityHit) == 2 then
		local entityCoords = GetEntityCoords(entityHit)
		return entityHit, entityCoords
	end

	return nil
end

local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end

        enum.destructor = nil
        enum.handle = nil
    end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end

        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)

        local next = true
        repeat
        coroutine.yield(id)
        next, id = moveFunc(iter)
        until not next

        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end




function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end


function GetVehicles()
    local vehicles = {}

    for vehicle in EnumerateVehicles() do
        table.insert(vehicles, vehicle)
    end

    return vehicles
end


function GetVehiclesInArea(coords, area)
    local vehicles       = GetVehicles()
    local vehiclesInArea = {}

    for i=1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

        if distance <= area then
            table.insert(vehiclesInArea, vehicles[i])
        end
    end

    return vehiclesInArea
end




function HealPlayer()
    ---------- get player ----------
    local player = PlayerPedId()
    local closestPlayerPed = player
    ----------- stamina ----------------
    local health = GetAttributeCoreValue(closestPlayerPed, 0)
    local newHealth = health + 100
    local stamina = GetAttributeCoreValue(closestPlayerPed, 1)
    local newStamina = stamina + 100
    ----------- health -----------------
    local health2 = GetEntityHealth(closestPlayerPed)
    local newHealth2 = health2 + 100
    Citizen.InvokeNative(0xC6258F41D86676E0, closestPlayerPed, 0, newHealth)
    Citizen.InvokeNative(0xC6258F41D86676E0, closestPlayerPed, 1, newStamina) 
    -------- set health ------------
    SetEntityHealth(closestPlayerPed, newHealth2)
end

function delHorse()
    local player = PlayerPedId()
    local mount   = GetMount(player)
    if IsPedOnMount(player) then
        DeleteEntity(mount)
    
    end
end


RegisterNetEvent('vorp:deleteVehicle')
AddEventHandler('vorp:deleteVehicle', function(radius)
    local player = PlayerPedId()

    if radius and tonumber(radius) then
        radius = tonumber(radius) + 0.01
        local vehicles = GetVehiclesInArea(GetEntityCoords(player), radius)
        for k,entity in ipairs(vehicles) do
            local attempt = 0

            while not NetworkHasControlOfEntity(entity) and attempt < 100 and DoesEntityExist(entity) do
                Wait(100)
                NetworkRequestControlOfEntity(entity)
                attempt = attempt + 1
            end

            if DoesEntityExist(entity) and NetworkHasControlOfEntity(entity) then
			    SetEntityAsMissionEntity(entity, true, true)
                DeleteVehicle(entity)
            end
        end
    else
        local vehicle, attempt = GetVehicleInDirection(), 0

        if IsPedInAnyVehicle(player, true) then
            vehicle = GetVehiclePedIsIn(player, false)
        end

        while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
            Wait(100)
            NetworkRequestControlOfEntity(vehicle)
            attempt = attempt + 1
        end

        if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
			SetEntityAsMissionEntity(vehicle, true, true)
            DeleteVehicle(vehicle)

        end
    end
end)


RegisterNetEvent('vorp:delHorse')
AddEventHandler('vorp:delHorse', function()
	delHorse()
end)


RegisterNetEvent('vorp:teleportWayPoint')
AddEventHandler('vorp:teleportWayPoint', function(WayPoint)
	TeleportToWaypoint()
end)

RegisterNetEvent('vorp:heal')
AddEventHandler('vorp:heal', function()
    HealPlayer()
end)