local T = Translation[Lang].MessageOfSystem
local S = Translation[Lang].SuggestChat

--============================================ PLAYER COMMANDS ==============================================--

PlayersCommands = {
    hideui = {
        command = Config.CommandHideIU,
        suggestion = S.hideUi,
        run = ToggleAllUI,
        restricted = false
    },
    toggleui = {
        command = Config.CommandToogleUI,
        suggestion = S.toogleUi,
        run = ToggleVorpUI,
        restricted = false
    },
    clear = {
        command = Config.CommandClearAnim,
        suggestion = S.stopAnim,
        run = function()
            local player = PlayerPedId()
            ClearPedTasksImmediately(player)
        end,
        restricted = false
    },
    pvp = {
        command = Config.CommandOnOffPVP,
        suggestion = S.tooglePVP,
        run = function()
            local pvp = TogglePVP()

            if pvp then
                TriggerEvent("vorp:TipRight", T.PVPNotifyOn, 4000)
            else
                TriggerEvent("vorp:TipRight", T.PVPNotifyOff, 4000)
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
