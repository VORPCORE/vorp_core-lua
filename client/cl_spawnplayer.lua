local firstSpawn = true
local active = false
local playerHash = GetHashKey("PLAYER")

local mapTypeOnMount = Config.mapTypeOnMount
local playerCores = Config.playerCores
local horseCores = Config.horseCores
local mapTypeOnFoot = Config.mapTypeOnFoot
local enableTypeRadar = Config.enableTypeRadar




function setPVP()
    NetworkSetFriendlyFireOption(true)
    SetRelationshipBetweenGroups(5, playerHash, playerHash)
end

--------------------------- UI RADAR SHOW OR HIDE ---------------------
function UI()
    local player = PlayerPedId()  
    local playerOnMout = IsPedOnMount(player)
    local playerOnVeh = IsPedInAnyVehicle(player)
    if Config.HideUi then
        TriggerEvent("vorp:showUi", false)
    end
    if enableTypeRadar then
        if not playerOnMout and not playerOnVeh then
            SetMinimapType(mapTypeOnFoot)

        elseif  playerOnMout or playerOnVeh  then
            SetMinimapType(mapTypeOnMount)

        end
    end
end
----------------------------------------------------------------------

RegisterNetEvent('vorp:initCharacter', function(coords, heading, isdead)
    local player = PlayerPedId()
    
    TeleportToCoords(coords.x+0.0, coords.y+0.0, coords.z+0.0, heading+0.0)
    if isdead then
        if not Config.CombatLogDeath then 
            TriggerServerEvent("vorp:PlayerForceRespawn")
            TriggerEvent("vorp:PlayerForceRespawn")
            resspawnPlayer()
        else
            Citizen.Wait(8000) -- this is needed to ensure the player has enough time to load in their character before it kills them. other wise they revive when the character loads in
            TriggerEvent("vorp_inventory:CloseInv")
            SetEntityHealth(PlayerPedId(),0,0)
        end
    end
end)

RegisterNetEvent('vorp:SelectedCharacter', function()
    local player = PlayerPedId()
    local playerCoords, playerHeading = GetEntityCoords(player, true, true), GetEntityHeading(player)
    local playerId = PlayerId()
    TriggerServerEvent("vorp:saveLastCoords", playerCoords, playerHeading)
        
    firstSpawn = false

    SetMinimapHideFow(true)

    if Config.ActiveEagleEye then
        Citizen.InvokeNative(0xA63FCAD3A6FEC6D2, playerId, true)
    end

    if Config.ActiveDeadEye then
        Citizen.InvokeNative(0x95EE1DEE1DCD9070, playerId, true)
    end

    setPVP()
  
end)

AddEventHandler('playerSpawned', function(spawnInfo)
    Citizen.Wait(4000)
    TriggerServerEvent("vorp:playerSpawn")
    TriggerServerEvent("vorp:chatSuggestion") --- chat add suggestion trigger 


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

        UI()  


        if not firstSpawn then
            local player = PlayerPedId()
            local playerCoords, playerHeading = GetEntityCoords(player, true, true), GetEntityHeading(player)
            TriggerServerEvent("vorp:saveLastCoords", playerCoords, playerHeading)
        end
    end
end)




