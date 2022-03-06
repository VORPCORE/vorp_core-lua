local firstSpawn = true
local active = false
local playerHash = GetHashKey("PLAYER")

function setPVP()
    NetworkSetFriendlyFireOption(true)
    SetRelationshipBetweenGroups(5, playerHash, playerHash)
end

RegisterNetEvent('vorp:initCharacter', function(coords, heading, isdead)
    TeleportToCoords(coords.x+0.0, coords.y+0.0, coords.z+0.0, heading+0.0)

    if isdead then
        if not Config.CombatLogDeath then 
            TriggerServerEvent("vorp:PlayerForceRespawn")
            TriggerEvent("vorp:PlayerForceRespawn")
            resspawnPlayer()
        else
            Citizen.Wait(8000) --Don't think this is needed...
            TriggerEvent("vorp_inventory:CloseInv")
            SetEntityHealth(PlayerPedId(),0,0)
        end
    end
end)

RegisterNetEvent('vorp:SelectedCharacter', function()
    local playerPedId = PlayerPedId()
    local playerCoords, playerHeading = GetEntityCoords(playerPedId, true, true), GetEntityHeading(playerPedId)

    TriggerServerEvent("vorp:saveLastCoords", playerCoords, playerHeading)
        
    firstSpawn = false

    SetMinimapHideFow(true)

    if Config["ActiveEagleEye"] then
        Citizen.InvokeNative(0xA63FCAD3A6FEC6D2, PlayerId(), true)
    end

    if Config["ActiveDeadEye"] then
        Citizen.InvokeNative(0x95EE1DEE1DCD9070, PlayerId(), true)
    end

    setPVP()
end)

AddEventHandler('playerSpawned', function(spawnInfo)
    Citizen.Wait(4000)
    TriggerServerEvent("vorp:playerSpawn")
end)

Citizen.CreateThread(function()
    while true do
        DisableControlAction(0, 0x580C4473, true) -- Disable hud
        DisableControlAction(0, 0xCF8A4ECA, true) -- Disable hud
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local pped = PlayerPedId()
        local count = 0

        if IsControlPressed(0, 0xCEFD9220) then
            SetRelationshipBetweenGroups(1, playerHash, playerHash)
            active = true
            Citizen.Wait(4000)
        end

        if not IsPedOnMount(pped) and not IsPedInAnyVehicle(pped, false) and active then
            SetRelationshipBetweenGroups(5, playerHash, playerHash)
            active = false
        elseif active and IsPedOnMount(pped) or IsPedInAnyVehicle(pped, false) then
            if IsPedInAnyVehicle(pped, false) then
                --Nothing?
            elseif GetPedInVehicleSeat(GetMount(pped), -1) == pped then
                SetRelationshipBetweenGroups(5, playerHash, playerHash)
                active = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3000)

        if not firstSpawn then
            local playerPedId = PlayerPedId()
            local playerCoords, playerHeading = GetEntityCoords(playerPedId, true, true), GetEntityHeading(playerPedId)

            TriggerServerEvent("vorp:saveLastCoords", playerCoords, playerHeading)
        end
    end
end)
