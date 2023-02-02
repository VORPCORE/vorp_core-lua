--============================================ PLAYER COMMANDS ==============================================--

PlayersCommands = {
    hideui = {
        command = "hideui",
        suggestion = "VORPcore command to HIDE all UI's from screen, nice to take screenshots.",
        run = ToggleAllUI,
        restricted = false
    },
    toggleui = {
        command = "toggleui",
        suggestion = "VORPcore command to toggle vorp UI's from screen",
        run = ToggleVorpUI,
        restricted = false
    },
    clear = {
        command = "cleartask",
        suggestion = "VORPcore command to use if you are stuck on an animation.",
        run = function ()
            local player = PlayerPedId()
            ClearPedTasksImmediately(player)
        end,
        restricted = false
    },
    pvp = {
        command = "pvp",
        suggestion = "VORPcore command to TOGGLE pvp for your character.",
        run = function ()
            local pvp = TogglePVP()

            if pvp then
                TriggerEvent("vorp:TipRight", Config.Langs.PVPNotifyOn, 4000)
            else
                TriggerEvent("vorp:TipRight", Config.Langs.PVPNotifyOff, 4000)
            end
        end,
        restricted = not Config.PVPToggle -- false means it should not display, so we have to negate with the not
    }
}

CreateThread(function()
    for _, value in pairs(PlayersCommands) do
        if not value.restricted then
            RegisterCommand(value.command, function()
                value.run()
            end)
            TriggerEvent("chat:addSuggestion", "/" .. value.command, value.suggestion)
        end
    end
end)

--============================================================================================================--
