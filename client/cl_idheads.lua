local UseIDHeads = Config["HeadId"]
local UseKeyMode = Config["ModeKey"]
local keyShow = Config["KeyShowIds"]
local distanceConfig = Config["HeadIdDistance"]

local PlayerTags = {}
local showIds = true

local function GetDistanceFromPlayer(p)
    local playerCoords = GetEntityCoords(GetPlayerPed(p), true, true)
    local myCoords = GetEntityCoords(PlayerPedId(), true, true)
    return #(myCoords - playerCoords)
end

Citizen.CreateThread(function()
    while UseIDHeads and UseKeyMode ~= 0 do
        if IsControlPressed(0, keyShow) then
            showIds = true
        else
            showIds = false
        end
        
        Citizen.Wait(0)
    end
end)


Citizen.CreateThread(function()
    while UseIDHeads do
        for _, i in ipairs(GetActivePlayers()) do
            if GetPlayerPed(i) ~= PlayerPedId() then
                if PlayerTags[i] then
                    if IsMpGamerTagActive(PlayerTags[i]) then
                        if GetDistanceFromPlayer(i) < distanceConfig and showIds then
                            Citizen.InvokeNative(0x93171DDDAB274EB8, PlayerTags[i], 2)
                        else
                            Citizen.InvokeNative(0x93171DDDAB274EB8, PlayerTags[i], 0)
                        end
                    else
                        local tagId = CreateMpGamerTag(i, GetPlayerServerId(i), false, false, "", 0)
                        PlayerTags[i] = tagId
                    end
                else
                    local tagId = CreateMpGamerTag(i, GetPlayerServerId(i), false, false, "", 0)
                    PlayerTags[i] = tagId
                end
            end
        end

        Citizen.Wait(0)
    end
end)
