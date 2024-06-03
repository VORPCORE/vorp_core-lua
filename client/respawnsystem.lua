local setDead = false
local TimeToRespawn = 1
local cam
local angleY = 0.0
local angleZ = 0.0
local prompts = GetRandomIntInRange(0, 0xffffff)
local prompt
local PressKey = false
local carried = false
local Done = false
local T = Translation[Lang].MessageOfSystem
local keepdown
local UseControlsCamera = Config.UseControlsCamera 

RegisterNetEvent('vorp:SelectedCharacter', function() 
    DeathCam2()
    DeathCam1()
end)

function DeathCam1()
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1)
            
            if UseControlsCamera and (deadcam and Dead) then 
                ProcessCamControls()
            end
        end
    end)
end

function DeathCam2()
    Citizen.CreateThread(function()
        while true do
            local ped = PlayerPedId()
            Citizen.Wait(500)
            if not Dead and IsPedDeadOrDying(ped) then
                Dead = true
                if UseControlsCamera then -- Check UseControlsCamera flag
                    StartDeathCam()
                end
            elseif Dead and not IsPedDeadOrDying(ped) then
                Dead = false
                EndDeathCam()
            end
        end
    end)
end

local function CheckLabel()
    if not carried then
        if not Done then
            local label = CreateVarString(10, 'LITERAL_STRING',
                T.RespawnIn .. TimeToRespawn .. T.SecondsMove .. T.message)
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

local function RespawnTimer()
    TimeToRespawn = Config.RespawnTime
    CreateThread(function() -- asyncronous
        while true do
            Wait(1000)
            TimeToRespawn = TimeToRespawn - 1
            if TimeToRespawn < 0 and setDead then
                TimeToRespawn = 0
                break
            end

            if not setDead then
                TimeToRespawn = Config.RespawnTime
                break
            end
        end
    end)
end

function ProcessNewPosition()
    local mouseX = 0.0
    local mouseY = 0.0
    
    -- keyboard
    if (IsInputDisabled(0)) then
        -- rotation
        mouseX = GetDisabledControlNormal(1, 0x6BC904FC) * 8.0
        mouseY = GetDisabledControlNormal(1, 0x84574AE8) * 8.0
        
    -- controller
    else
        -- rotation
        mouseX = GetDisabledControlNormal(1, 0x6BC904FC) * 0.5
        mouseY = GetDisabledControlNormal(1, 0x84574AE8) * 0.5
    end

    angleZ = angleZ - mouseX -- around Z axis (left / right)
    angleY = angleY + mouseY -- up / down
    -- limit up / down angle to 90°
    if (angleY > 89.0) then angleY = 89.0 elseif (angleY < -89.0) then angleY = -89.0 end
    
    local pCoords = GetEntityCoords(PlayerPedId())
    
    local behindCam = {
        x = pCoords.x + ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * (0.5 + 0.5),
        y = pCoords.y + ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * (0.5 + 0.5),
        z = pCoords.z + ((Sin(angleY))) * (0.5 + 0.5)
    }
    local rayHandle = StartShapeTestRay(pCoords.x, pCoords.y, pCoords.z + 0.5, behindCam.x, behindCam.y, behindCam.z, -1, PlayerPedId(), 0)
    local a, hitBool, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
    
    local maxRadius = 3.5
    if (hitBool and Vdist(pCoords.x, pCoords.y, pCoords.z + 0.0, hitCoords) < 0.5 + 0.5) then
        maxRadius = Vdist(pCoords.x, pCoords.y, pCoords.z + 0.0, hitCoords)
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

function StartDeathCam()
    ClearFocus()

    local playerPed = PlayerPedId()
    deadcam = Citizen.InvokeNative(0x40C23491CE83708E,"DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(PlayerPedId()), 0, 0, 0, GetGameplayCamFov())

    SetCamActive(deadcam, true)
    RenderScriptCams(true, true, 1000, true, false)
end

function EndDeathCam()
    ClearFocus()

    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(deadcam, false)
    
    deadcam = nil
end

function ProcessCamControls()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(PlayerPedId())
    Citizen.InvokeNative(0x05AB44D906738426)
    
    local newPos = ProcessNewPosition()

    Citizen.InvokeNative(0xF9EE7D419EE49DE6,deadcam, newPos.x, newPos.y, newPos.z)
    
    Citizen.InvokeNative(0x948B39341C3A40C2,deadcam, playerCoords.x, playerCoords.y, playerCoords.z)
end

function CoreAction.Player.ResurrectPlayer(currentHospital, currentHospitalName, justrevive)
    local player = PlayerPedId()
    Citizen.InvokeNative(0xCE7A90B160F75046, false) --SET_CINEMATIC_MODE_ACTIVE
    TriggerEvent("vorp:showUi", not Config.HideUi)
    ResurrectPed(player)
    Wait(200)
    EndDeathCam()
    TriggerServerEvent("vorp:ImDead", false)

    TriggerServerEvent("vorp_core:Server:OnPlayerRevive")
    TriggerEvent("vorp_core:Client:OnPlayerRevive")

    setDead = false
    DisplayHud(true)
    DisplayRadar(true)
    CoreAction.Utils.setPVP()
    TriggerEvent("vorpcharacter:reloadafterdeath")
    Wait(500)
    if currentHospital and currentHospital then
        Citizen.InvokeNative(0x203BEFFDBE12E96A, player, currentHospital, false, false, false) -- _SET_ENTITY_COORDS_AND_HEADING
    end
    Wait(2000)
    CoreAction.Admin.HealPlayer()
    if Config.RagdollOnResurrection and not justrevive then
        keepdown = true
        CreateThread(function()
            while keepdown do
                Wait(0)
                SetPedToRagdoll(player, 4000, 4000, 0, false, false, false)
                ResetPedRagdollTimer(player)
                DisablePedPainAudio(player, true)
            end
        end)
        AnimpostfxPlay("Title_Gen_FewHoursLater")
        Wait(3000)
        DoScreenFadeIn(2000)
        AnimpostfxPlay("PlayerWakeUpInterrogation")
        Wait(19000)
        keepdown = false
        VorpNotification:NotifyLeft(currentHospitalName or T.message6, T.message5, "minigames_hud", "five_finger_burnout",
            8000, "COLOR_PURE_WHITE")
    else
        DoScreenFadeIn(2000)
    end
end

function CoreAction.Player.RespawnPlayer(allow)
    local player = PlayerPedId()
    if allow then
        TriggerServerEvent("vorp:PlayerForceRespawn")
    end
    TriggerEvent("vorp:PlayerForceRespawn")
    local closestDistance = math.huge
    local closestLocation = ""
    local coords = nil
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

    TriggerEvent("vorpmetabolism:changeValue", "Thirst", 1000)
    TriggerEvent("vorpmetabolism:changeValue", "Hunger", 1000)
    CoreAction.Player.ResurrectPlayer(coords, closestLocation, false)
end

-- EVENTS
RegisterNetEvent('vorp:resurrectPlayer', function(just)
    local dont = false
    local justrevive = just or true
    AnimpostfxStop("PauseMenuIn") -- Stop the animpostfx effect when the player is resurrected
    CoreAction.Player.ResurrectPlayer(dont, nil, justrevive)
end)

RegisterNetEvent('vorp_core:respawnPlayer', function()
    CoreAction.Player.RespawnPlayer()
end)

RegisterNetEvent("vorp_core:Client:AddTimeToRespawn")
AddEventHandler("vorp_core:Client:AddTimeToRespawn", function(time)
    if TimeToRespawn >= 1 then
        TimeToRespawn = TimeToRespawn + time
    else
        RespawnTimer()
    end
end)

-- DEATH HANDLER
CreateThread(function()
    repeat Wait(1000) until LocalPlayer.state.IsInSession
    while Config.UseDeathHandler do
        local sleep = 1000

        if IsPlayerDead(PlayerId()) then
            if not setDead then
                setDead = true
                PressKey = false
                NetworkSetInSpectatorMode(false, PlayerPedId())
                exports.spawnmanager.setAutoSpawn(false)
                TriggerServerEvent("vorp:ImDead", true) -- internal event

                TriggerServerEvent("vorp_core:Server:OnPlayerDeath")
                TriggerEvent("vorp_core:Client:OnPlayerDeath")
                
                DisplayRadar(false)
                AnimpostfxPlay("PauseMenuIn") -- Play the animpostfx effect when the player dies
                CreateThread(function()
                    RespawnTimer()
                    if UseControlsCamera then -- Check UseControlsCamera flag
                        StartDeathCam()
                    end
                end)
            end
            if not PressKey and setDead then
                sleep = 0
                if not IsEntityAttachedToAnyPed(PlayerPedId()) then
                    -- Draw the 3D text above the player's head
                    local playerPed = PlayerPedId()
                    local playerCoords = GetEntityCoords(playerPed)
                    
                    if TimeToRespawn > 0 then
                        DrawText3D(playerCoords.x, playerCoords.y, playerCoords.z - 0.5, "Estado crítico em: " .. TimeToRespawn .. " Segundos", {255, 255, 0, 255}, {34, 20, 20, 200})
                        DrawText3D(playerCoords.x, playerCoords.y, playerCoords.z - 0.3, "Alerta os médicos com /alertamedico", {34, 139, 34, 255}, {34, 20, 20, 200})
                    else
                        DrawText3D(playerCoords.x, playerCoords.y, playerCoords.z - 0.3, "Estado Crítico, podes ir para Hospital!", {153, 0, 0, 255}, {34, 20, 20, 200})
                        DrawText3D(playerCoords.x, playerCoords.y, playerCoords.z - 0.5, "Pressiona [E]", {153, 0, 0, 255}, {34, 20, 20, 200})
                    end

                    if IsControlJustReleased(0, Config.RespawnKey) and TimeToRespawn <= 0 then
                        DoScreenFadeOut(3000)
                        Wait(3000)
                        AnimpostfxStop("PauseMenuIn") -- Stop the animpostfx effect when the player respawns
                        CoreAction.Player.RespawnPlayer(true)
                        PressKey      = true
                        carried       = false
                        Done          = false
                        TimeToRespawn = Config.RespawnTime
                    end

                    if TimeToRespawn >= 1 and setDead then
                        ProcessCamControls()
                        Done = false
                    else
                        ProcessCamControls()
                        Done = true
                    end
                    carried = false
                else
                    if setDead then
                        ProcessCamControls()
                        carried = true
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

function DrawText3D(x, y, z, text, textColor, spriteColor)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    if onScreen then
        SetTextScale(0.30, 0.30)
        SetTextFontForCurrentCommand(1)
        SetTextColor(textColor[1], textColor[2], textColor[3], textColor[4])
        SetTextCentre(1)
        DisplayText(str, _x, _y)
        local factor = (string.len(text)) / 225
        DrawSprite("feeds", "help_text_bg", _x, _y + 0.0125, 0.015 + factor, 0.03, 0.1, spriteColor[1], spriteColor[2], spriteColor[3], spriteColor[4], 0)
    end
end

-- Ensure TimeToRespawn is correctly initialized and decremented
TimeToRespawn = Config.RespawnTime

CreateThread(function()
    while setDead do
        if TimeToRespawn > 0 then
            Wait(1000)
            TimeToRespawn = TimeToRespawn - 1
        end
    end
end)