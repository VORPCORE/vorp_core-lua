local T = Translation[Lang].MessageOfSystem


local function HidePlayerCores()
    local playerCores = {
        playerhealth = 0,
        playerhealthcore = 1,
        playerdeadeye = 3,
        playerdeadeyecore = 2,
        playerstamina = 4,
        playerstaminacore = 5,
    }

    local horsecores = {
        horsehealth = 6,
        horsehealthcore = 7,
        horsedeadeye = 9,
        horsedeadeyecore = 8,
        horsestamina = 10,
        horsestaminacore = 11,
    }

    if Config.HideOnlyDEADEYE then
        UitutorialSetRpgIconVisibility(2, 2)
        UitutorialSetRpgIconVisibility(3, 2)
    end
    if Config.HidePlayersCore then
        for key, value in pairs(playerCores) do
            UitutorialSetRpgIconVisibility(value, 2)
        end
    end
    if Config.HideHorseCores then
        for key, value in pairs(horsecores) do
            UitutorialSetRpgIconVisibility(value, 2)
        end
    end
end

local function FillUpCores()
    local a2 = DataView.ArrayBuffer(12 * 8)
    local a3 = DataView.ArrayBuffer(12 * 8)
    InventoryAddItemWithGuid(1, a2:Buffer(), a3:Buffer(), GetHashKey("UPGRADE_HEALTH_TANK_1"), 1084182731, Config.maxHealth, 752097756)
    local a2 = DataView.ArrayBuffer(12 * 8)
    local a3 = DataView.ArrayBuffer(12 * 8)
    InventoryAddItemWithGuid(1, a2:Buffer(), a3:Buffer(), GetHashKey("UPGRADE_STAMINA_TANK_1"), 1084182731, Config.maxStamina, 752097756)
end

-- remove event notifications
local Events = {
    `EVENT_CHALLENGE_GOAL_COMPLETE`,
    `EVENT_CHALLENGE_REWARD`,
    `EVENT_DAILY_CHALLENGE_STREAK_COMPLETED`
}

CreateThread(function()
    HidePlayerCores()
    FillUpCores()
    while true do
        Wait(0)
        local event = GetNumberOfEvents(0)

        if event > 0 then
            for i = 0, event - 1 do
                local eventAtIndex = GetEventAtIndex(0, i)
                for _, value in pairs(Events) do
                    if eventAtIndex == value then
                        UiFeedClearAllChannels()
                    end
                end
            end
        end

        if Config.disableAutoAIM then
            SetPlayerTargetingMode(3)
            SetPlayerInVehicleTargetingMode(3)
        end
    end
end)

-- show players id when focus on other players
CreateThread(function()
    repeat Wait(1000) until LocalPlayer.state.IsInSession
    while Config.showplayerIDwhenfocus do
        local sleep = 1000
        if #GetActivePlayers() > 1 then -- we also count ourselfs
            sleep = 400
            for _, playersid in ipairs(GetActivePlayers()) do
                if playersid ~= PlayerId() then
                    local ped = GetPlayerPed(playersid)
                    SetPedPromptName(ped, T.PlayerWhenFocus .. tostring(GetPlayerServerId(playersid)))
                end
            end
        end
        Wait(sleep)
    end
end)
