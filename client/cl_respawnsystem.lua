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

local T = Translation[Lang].MessageOfSystem

--================================= FUNCTIONS ==========================================--

---GET LABLE FOR PROMPT
---@return string
local CheckLable = function()
    if not carried then
        if not Done then
            local label = CreateVarString(10, 'LITERAL_STRING',
                T.RespawnIn ..
                TimeToRespawn .. T.SecondsMove .. T.message)
            return label
        else
            local label = CreateVarString(10, 'LITERAL_STRING', T.message2)
            return label
        end
    else
        local label = CreateVarString(10, 'LITERAL_STRING', T.YouAreCarried)
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

local keepdown
local ResurrectPlayer = function(currentHospital, currentHospitalName, justrevive)
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
    TriggerEvent("vorpcharacter:reloadafterdeath")
    Wait(500)
    if currentHospital and currentHospital then -- set entitycoords with heading
        Citizen.InvokeNative(0x203BEFFDBE12E96A, player, currentHospital, false, false, false)
    end
    Wait(2000)
    HealPlayer() -- heal fully the player
    if Config.RagdollOnResurrection and not justrevive then
        keepdown = true
        CreateThread(function() -- tread to keep player down
            while keepdown do
                Wait(0)
                SetPedToRagdoll(PlayerPedId(), 4000, 4000, 0, 0, 0, 0)
                ResetPedRagdollTimer(PlayerPedId())
                DisablePedPainAudio(PlayerPedId(), true)
            end
        end)
        AnimpostfxPlay("Title_Gen_FewHoursLater")
        Wait(3000)
        DoScreenFadeIn(2000)
        AnimpostfxPlay("PlayerWakeUpInterrogation") -- disabled
        Wait(19000)
        keepdown = false
        local dict = "minigames_hud"
        local icon = "five_finger_burnout"
        TriggerEvent('vorp:NotifyLeft', currentHospitalName or T.message6, T.message5,
            dict, icon
            , 8000, "COLOR_PURE_WHITE") -- mesage only if this is active and justrevive is false
    else
        DoScreenFadeIn(2000)            -- fadein
    end
end

ResspawnPlayer = function()
    local player = PlayerPedId()
    TriggerServerEvent("vorp:PlayerForceRespawn")
    TriggerEvent("vorp:PlayerForceRespawn")
    local closestDistance = math.huge
    local closestLocation = ""
    local coords = ""
    local pedCoords = GetEntityCoords(player)
    for _, location in pairs(Config.Hospitals) do
        local locationCoords = vector3(location.pos.x, location.pos.y, location.pos.z)
        local currentDistance = #(pedCoords - locationCoords)

        if currentDistance < closestDistance then
            closestDistance = currentDistance
            closestLocation = location.name
            coords = location.pos
        end
    end
    ResurrectPlayer(coords, closestLocation, false)
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
    local playerCoords = ProcessNewPosition()
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
    local str = T.prompt
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
RegisterNetEvent('vorp:resurrectPlayer', function(just)
    local dont = false
    local justrevive = just or true
    ResurrectPlayer(dont, nil, justrevive)
end)

-- respawn player from server side
RegisterNetEvent('vorp_core:respawnPlayer', function()
    ResspawnPlayer()
end)

---RESPAWN TIME
local RespawnTimer = function()
    CreateThread(function() -- asyncronous
        while true do
            Wait(1000)      -- every second
            TimeToRespawn = TimeToRespawn - 1
            if TimeToRespawn < 0 and setDead then
                TimeToRespawn = 0
                break -- break the loop
            end
        end
    end)
end

-- use this events to request more time to a player to wait for respawn  for example if they call a doctor they need to wait if doctor answers back
RegisterNetEvent("vorp_core:Client:AddTimeToRespawn")               -- from server
AddEventHandler("vorp_core:Client:AddTimeToRespawn", function(time) -- from client
    if TimeToRespawn >= 1 then                                      -- if still has time then add more
        TimeToRespawn = TimeToRespawn + time
    else                                                            -- if not then create new timer
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
            if not setDead then      -- set only once
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
