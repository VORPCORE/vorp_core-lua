local T = Translation[Lang].MessageOfSystem

-- remove event notifications
local Events = {
    `EVENT_CHALLENGE_GOAL_COMPLETE`,
    `EVENT_CHALLENGE_REWARD`,
    `EVENT_DAILY_CHALLENGE_STREAK_COMPLETED`
}

CreateThread(function()
    while true do
        Wait(0)
        local event = GetNumberOfEvents(0)
        if event > 0 then
            for i = 0, event - 1 do
                local eventAtIndex = GetEventAtIndex(0, i)
                for _, value in pairs(Events) do
                    if eventAtIndex == value then
                        Citizen.InvokeNative(0x6035E8FBCA32AC5E) -- remove events
                    end
                end
            end
        end
        if Config.disableAutoAIM then
            Citizen.InvokeNative(0xD66A941F401E7302, 3)
            Citizen.InvokeNative(0x19B4F71703902238, 3)
        end
    end
end)

-- show players id when focus on other players
CreateThread(function()
    while Config.showplayerIDwhenfocus do
        for _, playersid in ipairs(GetActivePlayers()) do
            --? needs a check if player is focusing on another player for better performance
            local ped = GetPlayerPed(playersid)
            SetPedPromptName(ped, T.message4 .. tostring(GetPlayerServerId(playersid)))
        end
        Wait(800)
    end
end)

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

-- hide or show players cores
CreateThread(function()
    if Config.HideOnlyDEADEYE then
        Citizen.InvokeNative(0xC116E6DF68DCE667, 2, 2)
        Citizen.InvokeNative(0xC116E6DF68DCE667, 3, 2)
    end
    if Config.HidePlayersCore then
        for key, value in pairs(playerCores) do
            Citizen.InvokeNative(0xC116E6DF68DCE667, value, 2)
        end
    end
    if Config.HideHorseCores then
        for key, value in pairs(horsecores) do
            Citizen.InvokeNative(0xC116E6DF68DCE667, value, 2)
        end
    end
end)
