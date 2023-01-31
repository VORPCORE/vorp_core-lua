--============================================ PLAYER COMMANDS ==============================================--

PlayersCommands = {
    hideui = {
        command = "hideui",
        suggestion = "VORPcore command to HIDE all UI's from screen, nice to take screenshots." 
    },
    toggleui = {
        command = "toggleui",
        suggestion = "VORPcore command to toggle vorp UI's from screen"
        
    },
    clear = {
        command = "cleartask",
        suggestion = "VORPcore command to use if you are stuck on an animation."
    },
    pvp = {
        command = "pvp",
        suggestion = "VORPcore command to TOGGLE pvp for your character."
    }
}

CreateThread(function()
    for _, value in pairs(PlayersCommands) do
        RegisterCommand(value.command, function(source, args)
            if value.command == "hideui" then
                ToggleAllUI()
            elseif value.command == "toggleui" then
                ToggleVorpUI()
            elseif value.command == "cleartask" then
                local player = PlayerPedId()
                ClearPedTasksImmediately(player)
            elseif value.command == "pvp" then
                if Config.PVPToggle then
                    Pvp = not Pvp
                    if Pvp then
                        TriggerEvent("vorp:TipRight", Config.Langs.PVPNotifyOn, 4000)
                    else
                        TriggerEvent("vorp:TipRight", Config.Langs.PVPNotifyOff, 4000)
                    end
                end
            end
        end)

        if Config.PVPToggle then
            TriggerEvent("chat:addSuggestion", "/" .. value.command, value.suggestion)
        else
            if value.command ~= "pvp" then
                TriggerEvent("chat:addSuggestion", "/" .. value.command, value.suggestion)
            end
        end
    end
end)

--============================================================================================================--
