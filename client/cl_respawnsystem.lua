local setDead = false
local TimeToRespawn = 1

RegisterNetEvent('vorp:resurrectPlayer', function()
    resurrectPlayer()
end)

function resspawnPlayer()
    local currentHospital, minDistance, playerCoords = '', -1, GetEntityCoords(PlayerPedId(), true, true)

    ResurrectPed(PlayerPedId())
    AnimpostfxStop("DeathFailMP01")

    for k,Hospital in pairs(Config["hospital"]) do
        local Doctor = vector3(Hospital["x"], Hospital["y"], Hospital["z"])
        local currentDistance = #(playerCoords - Doctor)
        if minDistance ~= -1 and minDistance >= currentDistance then
            minDistance = currentDistance
            currentHospital = Hospital["name"]
        elseif minDistance == -1 then
            minDistance = currentDistance
            currentHospital = Hospital["name"]
        end
    end

    Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), Config["hospital"][currentHospital]["x"], Config["hospital"][currentHospital]["y"], Config["hospital"][currentHospital]["z"], Config["hospital"][currentHospital]["h"], false, false, false)
    Citizen.Wait(100)
    TriggerServerEvent("vorpcharacter:getPlayerSkin")
    DoScreenFadeIn(1000)
    TriggerServerEvent("vorp:ImDead", false)
    setDead = false
    NetworkSetInSpectatorMode(false, PlayerPedId())
    TriggerEvent("vorp:showUi", true)
    DisplayHud(true)
    DisplayRadar(true)
    setPVP()
end

function resurrectPlayer()
    ResurrectPed(PlayerPedId())
    AnimpostfxStop("DeathFailMP01")
    DoScreenFadeIn(1000)
    TriggerServerEvent("vorp:ImDead", false)
    setDead = false
    Citizen.Wait(100)
    NetworkSetInSpectatorMode(false, PlayerPedId())
    TriggerEvent("vorp:showUi", true)
    DisplayHud(true)
    DisplayRadar(true)
    setPVP()
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsPlayerDead(PlayerId()) then
            if not setDead then
                TriggerServerEvent("vorp:ImDead", true)
                setDead = true
            end

            NetworkSetInSpectatorMode(true, PlayerPedId())
            AnimpostfxPlay("DeathFailMP01")
            DisplayHud(false)
            DisplayRadar(false)
            TriggerEvent("vorp:showUi", false)
            TimeToRespawn = Config["RespawnTime"]

            while TimeToRespawn >= 0 and setDead do
                Citizen.Wait(1000)
                TimeToRespawn = TimeToRespawn - 1
                exports["spawnmanager"].setAutoSpawn(false)
            end

            local keyPress = Config["RespawnKey"]
            local pressKey = false

            while not pressKey and setDead do
                Citizen.Wait(0)
                if not IsEntityAttachedToAnyPed(PlayerPedId()) then
                    NetworkSetInSpectatorMode(true, PlayerPedId())
                    DrawText(Config.Langs["SubTitlePressKey"], Config["RespawnSubTitleFont"], 0.50, 0.50, 1.0, 1.0, 255, 255, 255, 255, true, true)
                    if IsControlJustPressed(0, keyPress) then
                        TriggerServerEvent("vorp:PlayerForceRespawn")
                        TriggerEvent("vorp:PlayerForceRespawn")
                        DoScreenFadeOut(3000)
                        Citizen.Wait(3000)
                        resspawnPlayer()
                        pressKey = true
                        Citizen.Wait(1000)
                    end
                end
            end
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if IsEntityAttachedToAnyPed(PlayerPedId()) and setDead then
            local carrier = GetCarrierAsPed(PlayerPedId())
            NetworkSetInSpectatorMode(true, carrier)
            DrawText(Config.Langs["YouAreCarried"], 4, 0.50, 0.30, 1.0, 1.0, 255, 255, 255, 255, true, true)
        elseif TimeToRespawn >= 0 and setDead then
            DrawText(Config.Langs["TitleOnDead"], Config["RespawnTitleFont"], 0.50, 0.50, 1.2, 1.2, 171, 3, 0, 255, true, true)
            DrawText(string.format(Config.Langs["SubTitleOnDead"], TimeToRespawn), Config["RespawnSubTitleFont"], 0.50, 0.60, 0.5, 0.5, 255, 255, 255, 255, true, true)
        end
    end
end)

