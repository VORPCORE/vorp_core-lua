local setDead = false
local TimeToRespawn = 1
local cam = nil
local angleY = 0.0
local angleZ = 0.0
local prompts = GetRandomIntInRange(0, 0xffffff)
local prompt
local PressKey = false
local carried = false
local Done = false

RegisterNetEvent('vorp:resurrectPlayer', function()
    resurrectPlayer()
end)


RegisterNetEvent('vorp:killPlayer', function()
    killPlayer()
end)
-- new event to trigger respawn function from server
RegisterNetEvent('vorp_core:respawnPlayer', function()
    resspawnPlayer()
end)


function resspawnPlayer()
    local currentHospital, minDistance, playerCoords = '', -1, GetEntityCoords(PlayerPedId(), true, true)
    ResurrectPed(PlayerPedId())
    local innerHealth = Citizen.InvokeNative(0x36731AC041289BB1, PlayerPedId(), 0)
    SetEntityHealth(PlayerPedId(), Config.HealthOnRespawn + innerHealth)
    EndDeathCam()
    for k, Hospital in pairs(Config["hospital"]) do
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

    Citizen.InvokeNative(0x203BEFFDBE12E96A, PlayerPedId(), Config["hospital"][currentHospital]["x"],
        Config["hospital"][currentHospital]["y"], Config["hospital"][currentHospital]["z"],
        Config["hospital"][currentHospital]["h"], false, false, false)
    Citizen.Wait(100)
    TriggerServerEvent("vorpcharacter:getPlayerSkin")
    DoScreenFadeIn(1000)
    TriggerServerEvent("vorp:ImDead", false)
    setDead = false
    NetworkSetInSpectatorMode(false, PlayerPedId())
    DisplayHud(true)
    DisplayRadar(true)
    setPVP()
end
function killPlayer()
    local innerHealth = Citizen.InvokeNative(0x36731AC041289BB1, PlayerPedId(), 0)
    SetEntityHealth(PlayerPedId(),health + innerHealth >0)
    Citizen.InvokeNative(0x697157CED63F18D4, PlayerPedId(), 500000, false, true, true)
    DisplayHud(false)
    DisplayRadar(false)
end
function resurrectPlayer()
    ResurrectPed(PlayerPedId())
    local innerHealth = Citizen.InvokeNative(0x36731AC041289BB1, PlayerPedId(), 0)
    SetEntityHealth(PlayerPedId(), Config.HealthOnResurrection + innerHealth)
    EndDeathCam()
    DoScreenFadeIn(1000)
    TriggerServerEvent("vorp:ImDead", false)
    setDead = false
    Citizen.Wait(100)
    NetworkSetInSpectatorMode(false, PlayerPedId())

    DisplayHud(true)
    DisplayRadar(true)
    setPVP()
end

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    local str = Config.Langs.prompt
    local keyPress = Config["RespawnKey"]
    prompt = PromptRegisterBegin()
    PromptSetControlAction(prompt, keyPress)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(prompt, str)
    PromptSetEnabled(prompt, 1)
    PromptSetVisible(prompt, 1)
    PromptSetHoldMode(prompt, Config.RespawnKeyTime)
    PromptSetGroup(prompt, prompts)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, prompt, true)
    PromptRegisterEnd(prompt)
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsPlayerDead(PlayerId()) then
            if not setDead then
                TriggerServerEvent("vorp:ImDead", true)
                setDead = true
            end
            NetworkSetInSpectatorMode(false, PlayerPedId())

--================================= FUNCTIONS ==========================================--


---GET LABLE FOR PROMPT
---@return string
local CheckLable = function()
    if not carried then
        if not Done then
            local label = CreateVarString(10, 'LITERAL_STRING',
                Config.Langs.RespawnIn ..
                TimeToRespawn .. Config.Langs.SecondsMove .. Config.Langs.message)
            return label
        else
            local label = CreateVarString(10, 'LITERAL_STRING', Config.Langs.message2)
            return label
        end
    else
        local label = CreateVarString(10, 'LITERAL_STRING', Config.Langs.YouAreCarried)
        return label
    end
end

---comment
---@return table
local ProcessNewPosition = function()
    local mouseX = 0.0
    local mouseY = 0.0
    if (IsInputDisabled(0)) then
        mouseX = GetDisabledControlNormal(1, 0x4D8FB4C1) * 1.5
        mouseY = GetDisabledControlNormal(1, 0xFDA83190) * 1.5
    else
        mouseX = GetDisabledControlNormal(1, 0x4D8FB4C1) * 0.5
        mouseY = GetDisabledControlNormal(1, 0xFDA83190) * 0.5
    end
    angleZ = angleZ - mouseX
    angleY = angleY + mouseY

    if (angleY > 89.0) then angleY = 89.0 elseif (angleY < -89.0) then angleY = -89.0 end
    local pCoords = GetEntityCoords(PlayerPedId())
    local behindCam = {
        x = pCoords.x + ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * (3.0 + 0.5),
        y = pCoords.y + ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * (3.0 + 0.5),
        z = pCoords.z + ((Sin(angleY))) * (3.0 + 0.5)
    }
    local rayHandle = StartShapeTestRay(pCoords.x, pCoords.y, pCoords.z + 0.5, behindCam.x, behindCam.y, behindCam.z, -1
        , PlayerPedId(), 0)
    local hitBool, hitCoords = GetShapeTestResult(rayHandle)

    local maxRadius = 3.0
    if (hitBool and Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords) < 3.0 + 0.5) then
        maxRadius = Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords)
    end

    local offset = {
        x = ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * maxRadius,
        y = ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * maxRadius,
        z = ((Sin(angleY))) * maxRadius
    }

    local pos = {
        x = pCoords.x + offset.x,
        y = pCoords.y + offset.y,
        z = pCoords.z + offset.z
    }

    return pos
end

local EndDeathCam = function()
    NetworkSetInSpectatorMode(false, PlayerPedId())
    ClearFocus()
    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(cam, false)
    cam = nil
    DestroyAllCams(true)
end

local ResurrectPlayer = function(currentHospital)
    local player = PlayerPedId()
    Citizen.InvokeNative(0xCE7A90B160F75046, false)
    if Config.HideUi then -- SHOW VORP core ui
        TriggerEvent("vorp:showUi", false)
    else
        TriggerEvent("vorp:showUi", true)
    end
    ResurrectPed(player)
    Wait(200)
    EndDeathCam()
    TriggerServerEvent("vorp:ImDead", false)
    setDead = false
    DisplayHud(true)
    DisplayRadar(true)
    setPVP()
    if currentHospital ~= "dontTeleport" and currentHospital then -- set entitycoords with heading
        Citizen.InvokeNative(0x203BEFFDBE12E96A, player, currentHospital.x, currentHospital.y, currentHospital.z,
            currentHospital.h, false, false, false)
    end
    Wait(2000)
    HealPlayer() -- heal fully the player
    DoScreenFadeIn(1000)
end

ResspawnPlayer = function()
    local player = PlayerPedId()
    TriggerServerEvent("vorp:PlayerForceRespawn")
    TriggerEvent("vorp:PlayerForceRespawn")
    local currentHospital, minDistance, playerCoords = '', -1, GetEntityCoords(player, true, true)

    for _, Hospital in pairs(Config.hospital) do
        local Doctor = vector3(Hospital.x, Hospital.y, Hospital.z)
        local currentDistance = #(playerCoords - Doctor)
        if minDistance ~= -1 and minDistance >= currentDistance then
            minDistance = currentDistance
            currentHospital = Hospital
        elseif minDistance == -1 then
            minDistance = currentDistance
            currentHospital = Hospital
        end
    end

    ResurrectPlayer(currentHospital)
    TriggerServerEvent("vorpcharacter:getPlayerSkin")
end

--[[local StartDeathCam = function()
    ClearFocus()
    local playerPed = PlayerPedId()
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(playerPed), 0, 0, 0, GetGameplayCamFov())
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, false)

end

local ProcessCamControls = function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local newPos = playerCoords
    SetCamCoord(cam, newPos.x, newPos.y, newPos.z)
    PointCamAtCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z + 0.5)
end]]

local StartDeathCam = function()
    ClearFocus()
    local playerPed = PlayerPedId()
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(playerPed), 0, 0, 0, GetGameplayCamFov())
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, false)
end

local ProcessCamControls = function()
    local playerCoords
    if Config.UseControlsCamera then
        playerCoords = ProcessNewPosition()
    else
        playerCoords = GetEntityCoords(PlayerPedId())
    end

    local newPos = playerCoords
    if IsEntityAttachedToAnyPed(PlayerPedId()) then

        SetCamCoord(cam, newPos.x, newPos.y + -2, newPos.z + 0.50)
        SetCamRot(cam, -20.0, 0.0, 0.0, 1)
        SetCamFov(cam, 50.0)
    else

        SetCamCoord(cam, newPos.x, newPos.y, newPos.z + 1.0)
        SetCamRot(cam, -80.0, 0.0, 0.0, 1)
        SetCamFov(cam, 50.0)

    end
end

-- CREATE PROMPT
CreateThread(function()
    Wait(1000)
    local str = Config.Langs.prompt
    local keyPress = Config.RespawnKey
    prompt = PromptRegisterBegin()
    PromptSetControlAction(prompt, keyPress)
    str = CreateVarString(10, 'LITERAL_STRING', str)
    PromptSetText(prompt, str)
    PromptSetEnabled(prompt, 1)
    PromptSetVisible(prompt, 1)
    PromptSetHoldMode(prompt, Config.RespawnKeyTime)
    PromptSetGroup(prompt, prompts)
    Citizen.InvokeNative(0xC5F428EE08FA7F2C, prompt, true)
    PromptRegisterEnd(prompt)
end)

--============================ EVENTS ================================--

-- revive player from server side use this event to revive and not teleport
RegisterNetEvent('vorp:resurrectPlayer', function()
    local dont = "dontTeleport"
    ResurrectPlayer(dont)
end)

-- respawn player from server side
RegisterNetEvent('vorp_core:respawnPlayer', function()
    ResspawnPlayer()
end)

---RESPAWN TIME
local RespawnTimer = function()
    CreateThread(function() -- asyncronous
        while true do
            Wait(1000) -- every second
            TimeToRespawn = TimeToRespawn - 1
            if TimeToRespawn < 0 and setDead then
                TimeToRespawn = 0
                break -- break the loop
            end
        end
    end)
end

-- use this events to request more time to a player to wait for respawn  for example if they call a doctor they need to wait if doctor answers back
RegisterNetEvent("vorp_core:Client:AddTimeToRespawn") -- from server
AddEventHandler("vorp_core:Client:AddTimeToRespawn", function(time) -- from client
    if TimeToRespawn >= 1 then -- if still has time then add more
        TimeToRespawn = TimeToRespawn + time
    else -- if not then create new timer
        RespawnTimer()
    end
end)
--=========================== DEATH HANDLER =================================--


--DEATH HANDLER
CreateThread(function()
    while Config.UseDeathHandler do
        Wait(0)
        local sleep = true
        local player = PlayerPedId() -- call it once

        if IsEntityDead(player) then -- if player is dead
            sleep = false
            if not setDead then -- set only once
                NetworkSetInSpectatorMode(false, player)
                exports.spawnmanager.setAutoSpawn(false)
                TriggerServerEvent("vorp:ImDead", true)
                DisplayRadar(false)
                TimeToRespawn = Config.RespawnTime
                CreateThread(function() -- asyncronous timer
                    RespawnTimer()
                    StartDeathCam()
                end)
                PressKey = false
                setDead = true
                PromptSetEnabled(prompt, 1)
            end

            if not PressKey and setDead then
                if not IsEntityAttachedToAnyPed(player) then -- is not  player being carried

                    PromptSetActiveGroupThisFrame(prompts, CheckLable())

                    if PromptHasHoldModeCompleted(prompt) then
                        DoScreenFadeOut(3000)
                        Wait(3000)
                        ResspawnPlayer()
                        PressKey = true
                        carried  = false
                        Done     = false
                        sleep    = true
                    end

                    if TimeToRespawn >= 1 and setDead then -- message will only show if timer has not been met
                        ProcessCamControls()
                        Done = false
                        PromptSetEnabled(prompt, 0)
                    else
                        ProcessCamControls()
                        Done = true
                        PromptSetEnabled(prompt, 1)
                    end
                    carried = false
                else -- if is being carried
                    if setDead then
                        PromptSetActiveGroupThisFrame(prompts, CheckLable())
                        PromptSetEnabled(prompt, 0)
                        ProcessCamControls()
                        carried = true
                    end
                end
            end
        else
            sleep = true
        end
        if sleep then -- controller
            Wait(1000)
        end
    end
end)
