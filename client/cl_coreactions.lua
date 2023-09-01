---@class CoreAction CoreAction
---@field HealPlayer fun()
---@field DeleteHorse fun()
---@field DeleteVehicleInRadius fun(radius: number)
CoreAction = {}
---@class CoreAction.Admin CoreAction.Admin
CoreAction.Admin = {}

---@class CoreAction.Utils CoreAction.Functions
CoreAction.Utils = {}

local T = Translation[Lang].MessageOfSystem

--- heal player cores
function CoreAction.Admin.HealPlayer()
    local player = PlayerPedId()
    Citizen.InvokeNative(0xC6258F41D86676E0, player, 0, 100) -- SetAttributeCoreValue
    SetEntityHealth(player, 600, 1)
    Citizen.InvokeNative(0xC6258F41D86676E0, player, 1, 100) -- SetAttributeCoreValue
    Citizen.InvokeNative(0x675680D089BFA21F, player, 1065330373)
end

--- delete horse if player is on horse
function CoreAction.Admin.DeleteHorse()
    local player = PlayerPedId()
    if IsPedOnMount(player) then
        local mount = GetMount(player)
        DeleteEntity(mount)
    else
        VorpNotification:NotifyRightTip(T.sit, 3000)
    end
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


--- delete all vehicles within radius
---@param radius number
function CoreAction.Admin.DeleteVehicleInRadius(radius)
    local player = PlayerPedId()

    local function EnumerateVehicles()
        return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
    end

    local function GetVehicles()
        local vehicles = {}

        for vehicle in EnumerateVehicles() do
            table.insert(vehicles, vehicle)
        end

        return vehicles
    end

    local function GetVehiclesInArea(coords, area)
        local vehicles       = GetVehicles()
        local vehiclesInArea = {}

        for i = 1, #vehicles, 1 do
            local vehicleCoords = GetEntityCoords(vehicles[i])
            local distance      = #(coords - vehicleCoords)

            if distance <= area then
                table.insert(vehiclesInArea, vehicles[i])
            end
        end

        return vehiclesInArea
    end

    local function GetVehicleInDirection()
        local playerPed               = PlayerPedId()
        local playerCoords            = GetEntityCoords(playerPed)
        local inDirection             = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
        local rayHandle               = StartExpensiveSynchronousShapeTestLosProbe(playerCoords.x, playerCoords.y,
            playerCoords.z, inDirection.x, inDirection.y, inDirection.z, 10, playerPed, 0)
        local _, hit, _, _, entityHit = GetShapeTestResult(rayHandle)

        if hit == 1 and GetEntityType(entityHit) == 2 then
            local entityCoords = GetEntityCoords(entityHit)
            return entityHit, entityCoords
        end

        return nil
    end

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

--- teleport player to waypoint
function CoreAction.Admin.TeleportToWayPoint()
    local ped = PlayerPedId()
    local GetGroundZAndNormalFor_3dCoord = GetGroundZAndNormalFor_3dCoord
    local waypoint = IsWaypointActive()
    local coords = GetWaypointCoords()
    local x, y, groundZ, startingpoint = coords.x, coords.y, 650.0, 750.0
    local found = false

    if not waypoint then
        return VorpNotification:NotifyRightTip("you need to set a waypoint", 3000)
    end

    DoScreenFadeOut(500)
    Wait(1000)
    FreezeEntityPosition(ped, true)
    for i = startingpoint, 0, -25.0 do
        local z = i
        if (i % 2) ~= 0 then
            z = startingpoint + i
        end
        SetEntityCoords(ped, x, y, z - 1000, false, false, false, false)
        Wait(1000)
        found, groundZ = GetGroundZAndNormalFor_3dCoord(x, y, z)
        if found then
            SetEntityCoords(ped, x, y, groundZ, false, false, false, false)
            while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
                RequestCollisionAtCoord(x, y, groundZ)
                Wait(500)
            end
            FreezeEntityPosition(ped, false)
            Wait(1000)
            DoScreenFadeIn(650)
            break
        end
    end
end

function CoreAction.Utils.LoadModel(hash)
    if IsModelValid(hash) then
        RequestModel(hash, false)
        while not HasModelLoaded(hash) do
            Wait(0)
        end
        return true
    end
    return false
end

function CoreAction.Utils.LoadTexture(hash)
    if not HasStreamedTextureDictLoaded(hash) then
        RequestStreamedTextureDict(hash, true)
        while not HasStreamedTextureDictLoaded(hash) do
            Wait(1)
        end
        return true
    end
    return false
end

function CoreAction.Utils.bigInt(text)
    local string1 = DataView.ArrayBuffer(16)
    string1:SetInt64(0, text)
    return string1:GetInt64(0)
end
