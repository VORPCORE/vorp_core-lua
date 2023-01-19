--=================================================== ADMIN ACTIONS ================================================================--

local TeleportToWaypoint = function()

    local ped = PlayerPedId()
    local GetGroundZAndNormalFor_3dCoord = GetGroundZAndNormalFor_3dCoord
    local waypoint = IsWaypointActive()
    local coords = GetWaypointCoords()
    local x, y, groundZ, startingpoint = coords.x, coords.y, 650.0, 750.0
    local found = false

    if not waypoint then
        return
    end
    DoScreenFadeOut(500)
    Wait(1000)
    FreezeEntityPosition(ped, true)
    for i = startingpoint, 0, -25.0 do
        local z = i
        if (i % 2) ~= 0 then
            z = startingpoint + i
        end
        SetEntityCoords(ped, x, y, z - 1000)
        Wait(1000)
        found, groundZ = GetGroundZAndNormalFor_3dCoord(x, y, z)
        if found then
            SetEntityCoords(ped, x, y, groundZ)
            FreezeEntityPosition(ped, false)
            Wait(1000)
            DoScreenFadeIn(650)
            break
        end
    end
end


local GetVehicleInDirection = function()
    local playerPed      = PlayerPedId()
    local playerCoords   = GetEntityCoords(playerPed)
    local inDirection    = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0,
        0.0)
    local rayHandle      = StartExpensiveSynchronousShapeTestLosProbe(playerCoords
        , inDirection, 10, playerPed, 0)
    local hit, entityHit = GetShapeTestResult(rayHandle)

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

---comment
---@param initFunc any
---@param moveFunc any
---@param disposeFunc any
local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end

        local enum = { handle = iter, destructor = disposeFunc }
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

local EnumerateVehicles = function()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end
---comment
---@return table
local GetVehicles = function()
    local vehicles = {}

    for vehicle in EnumerateVehicles() do
        table.insert(vehicles, vehicle)
    end

    return vehicles
end

---comment
---@param coords any
---@param area any
---@return table
local GetVehiclesInArea = function(coords, area)
    local vehicles       = GetVehicles()
    local vehiclesInArea = {}

    for i = 1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

        if distance <= area then
            table.insert(vehiclesInArea, vehicles[i])
        end
    end

    return vehiclesInArea
end

--==================== HEAL PLAYER ==========================--
HealPlayer = function()
    local ped = PlayerPedId()
    Citizen.InvokeNative(0xC6258F41D86676E0, ped, 0, 100) -- inner first
    SetEntityHealth(ped, 600, 1) -- outter after
    Citizen.InvokeNative(0xC6258F41D86676E0, ped, 1, 100) -- only fills inner
    Citizen.InvokeNative(0x675680D089BFA21F, ped, 1065330373) -- only fills outter with a weird amount of numbers
    --TriggerEvent("vorpmetabolism:setValue", "Thirst", 1000) -- metabolism
    -- TriggerEvent("vorpmetabolism:setValue", "Hunger", 1000)
end

local DelHorse = function()
    local player = PlayerPedId()
    local mount  = GetMount(player)
    if IsPedOnMount(player) then
        DeleteEntity(mount)
    else
        TriggerEvent("vorp:TipRight", Config.Langs.sit, 3000)
    end
end
---comment
---@param target number
---@param status any
---@param banTime any
local BanPlayerByUserId = function(target, status, banTime)
    TriggerServerEvent("vorpbans:addtodb", status, target, banTime)
end
---comment
---@param target number
---@param status any
local WarnPlayerByUserId = function(target, status)
    TriggerServerEvent("vorpwarns:addtodb", status, target)
end
---comment
---@param target number
---@param status any
local CharPlayerByUserId = function(target, status)
    TriggerServerEvent("vorpchar:addtodb", status, target)
end
---comment
---@param radius number
local DeleteWagonsRadius = function(radius)
    local player = PlayerPedId()

    if radius and tonumber(radius) then
        radius = tonumber(radius) + 0.01
        local vehicles = GetVehiclesInArea(GetEntityCoords(player), radius)
        for k, entity in ipairs(vehicles) do
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
end

--=========================================================== EVENTS ======================================================--
RegisterNetEvent('vorp:deleteVehicle')
AddEventHandler('vorp:deleteVehicle', function(radius)
    DeleteWagonsRadius(radius)
end)

RegisterNetEvent('vorp:delHorse')
AddEventHandler('vorp:delHorse', function()
    DelHorse()
end)

RegisterNetEvent('vorp:teleportWayPoint', function()
    TeleportToWaypoint()
end)

RegisterNetEvent('vorp:heal', function()
    HealPlayer()
end)

RegisterNetEvent('vorp:ban', function(target, banTime)
    BanPlayerByUserId(target, true, banTime)
end)

RegisterNetEvent('vorp:unban', function(target)
    BanPlayerByUserId(target, false, 0)
end)

RegisterNetEvent('vorp:warn', function(target)
    WarnPlayerByUserId(target, true)
end)

RegisterNetEvent('vorp:unwarn', function(target)
    WarnPlayerByUserId(target, false)
end)

RegisterNetEvent('vorp:addchar', function(target)
    CharPlayerByUserId(target, true)
end)

RegisterNetEvent('vorp:removechar', function(target)
    CharPlayerByUserId(target, false)
end)
--===========================================================================================================================--
