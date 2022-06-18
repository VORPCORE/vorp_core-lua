local setDead = false
local TimeToRespawn = 1
local cam = nil
local angleY = 0.0
local angleZ = 0.0
local prompts = GetRandomIntInRange(0, 0xffffff)

RegisterNetEvent('vorp:resurrectPlayer', function()
    resurrectPlayer()
end)

-- new event to trigger respawn function from server
RegisterNetEvent('vorp_core:respawnPlayer', function()
    resspawnPlayer()
end)


function resspawnPlayer()
    local currentHospital, minDistance, playerCoords = '', -1, GetEntityCoords(PlayerPedId(), true, true)

    ResurrectPed(PlayerPedId())
    --AnimpostfxStop("DeathFailMP01")
	EndDeathCam()
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
    --TriggerEvent("vorp:showUi", true)
    DisplayHud(true)
    DisplayRadar(true)
    setPVP()
end

function resurrectPlayer()
    ResurrectPed(PlayerPedId())
    --AnimpostfxStop("DeathFailMP01")
	EndDeathCam()
    DoScreenFadeIn(1000)
    TriggerServerEvent("vorp:ImDead", false)
    setDead = false
    Citizen.Wait(100)
    NetworkSetInSpectatorMode(false, PlayerPedId())
    --TriggerEvent("vorp:showUi", true)
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
	PromptSetStandardMode(prompt,1)
    PromptSetHoldMode(prompt, 1)
	PromptSetGroup(prompt, prompts)
	Citizen.InvokeNative(0xC5F428EE08FA7F2C,prompt,true)
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
            --AnimpostfxPlay("DeathFailMP01")
            DisplayHud(false)
            DisplayRadar(false)
            --TriggerEvent("vorp:showUi", false)
            TimeToRespawn = Config["RespawnTime"]
           
			StartDeathCam()
            
            while TimeToRespawn >= 0 and setDead do
                Citizen.Wait(1000)
                TimeToRespawn = TimeToRespawn - 1
                exports["spawnmanager"].setAutoSpawn(false)
            end
			
           
            local pressKey = false
            local promptLabel = Config.Langs["promptLabel"]
			
            while not pressKey and setDead do
                Citizen.Wait(0)
                if not IsEntityAttachedToAnyPed(PlayerPedId()) then
					local GetCoords = GetEntityCoords(PlayerPedId())
                    NetworkSetInSpectatorMode(false, PlayerPedId())
                    DrawText3D(GetCoords.x,GetCoords.y,GetCoords.z, Config.Langs["TitleOnDead"])
                    local label  = CreateVarString(10, 'LITERAL_STRING', promptLabel)
                    PromptSetActiveGroupThisFrame(prompts, label)
                    if Citizen.InvokeNative(0xC92AC953F0A982AE,prompt) then
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
        else
            Citizen.Wait(500)
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		local GetCoords = GetEntityCoords(PlayerPedId())
        if IsEntityAttachedToAnyPed(PlayerPedId()) and setDead then
            local carrier = Citizen.InvokeNative(0x09B83E68DE004CD4, PlayerPedId())
            NetworkSetInSpectatorMode(false, PlayerPedId())
			ProcessCamControls()
			DrawText3D(GetCoords.x,GetCoords.y,GetCoords.z+0.20, Config.Langs["YouAreCarried"])
        elseif TimeToRespawn >= 0 and setDead then
			ProcessCamControls()
            NetworkSetInSpectatorMode(false, PlayerPedId())
            DrawText3D(GetCoords.x,GetCoords.y,GetCoords.z, Config.Langs["TitleOnDead"])
            DrawText3D(GetCoords.x,GetCoords.y,GetCoords.z-0.2, Config.Langs["RespawnIn"]..TimeToRespawn..Config.Langs["SecondsMove"])
        else
            Citizen.Wait(500)
        end
    end
end)

camDeath = Config.camDeath

function StartDeathCam()
    Citizen.CreateThread(function()
        if camDeath then
            ClearFocus()
            local playerPed = PlayerPedId()
            cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(playerPed), 0, 0, 0, GetGameplayCamFov())
            SetCamActive(cam, true)
            RenderScriptCams(true, true, 1000, true, false)
        end
    end)
end


function EndDeathCam()
    Citizen.CreateThread(function()
        NetworkSetInSpectatorMode(false, PlayerPedId())
        ClearFocus()
        RenderScriptCams(false, false, 0, true, false)
        DestroyCam(cam, false)
        cam = nil
    end)
end


function ProcessCamControls()
    Citizen.CreateThread(function()
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local newPos = ProcessNewPosition()
        SetCamCoord(cam, newPos.x, newPos.y, newPos.z)
        PointCamAtCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z + 0.5)
    end)
end

function ProcessNewPosition()
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
    local rayHandle = StartShapeTestRay(pCoords.x, pCoords.y, pCoords.z + 0.5, behindCam.x, behindCam.y, behindCam.z, -1, PlayerPedId(), 0)
    local a, hitBool, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

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

local spriteGrey = Config.spriteGrey
local sprite = Config.sprite
function DrawText3D(x, y, z, text)
	local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
	local px,py,pz=table.unpack(GetGameplayCamCoord())  
	local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
	local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
	if onScreen then
		SetTextScale(0.30, 0.30)
		SetTextFontForCurrentCommand(6)
		SetTextColor(255, 255, 255, 255)
		SetTextCentre(1)
		SetTextDropshadow(1, 1, 0, 0, 200)
		DisplayText(str,_x,_y)
		local factor = (string.len(text)) / 225
		if sprite then
            if spriteGrey then
		        DrawSprite("generic_textures", "hud_menu_4a", _x, _y+0.0125,0.015+ factor, 0.03, 0.1, 35, 35, 35, 190, 0)
            else
               DrawSprite("feeds", "toast_bg", _x, _y+0.0125,0.015+ factor, 0.03, 0.1, 100, 1, 1, 190, 0)
            end
	    end
	end
end
