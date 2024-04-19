local T = Translation[Lang].MessageOfSystem
local S = Translation[Lang].SuggestChat

PlayerCommands = {
    hideui = {
        command = Config.CommandHideIU,
        suggestion = S.hideUi,
        run = function()
            CoreAction.Utils.ToggleAllUI()
        end,
        restricted = false
    },
    toggleui = {
        command = Config.CommandToogleUI,
        suggestion = S.toogleUi,
        run = function()
            CoreAction.Utils.ToggleVorpUI()
        end,
        restricted = false
    },
    clear = {
        command = Config.CommandClearAnim,
        suggestion = S.stopAnim,
        run = function()
            local ped = PlayerPedId()
            local hogtied = IsPedHogtied(ped) == 1 or IsPedHogtied(ped) == true
            local IsBeingHogtied = IsPedBeingHogtied(ped) == 1 or IsPedBeingHogtied(ped) == true
            local beingGrapple = Citizen.InvokeNative(0x3BDFCF25B58B0415, ped)
            if hogtied or IsPedCuffed(ped) or IsBeingHogtied or beingGrapple then
                return
            end
            ClearPedTasksImmediately(ped)
        end,
        restricted = false
    },
    pvp = {
        command = Config.CommandOnOffPVP,
        suggestion = S.tooglePVP,
        run = function()
            local pvp = CoreAction.Utils.TogglePVP()

            if pvp then
                VorpNotification:NotifyRightTip(T.PVPNotifyOn, 4000)
            else
                VorpNotification:NotifyRightTip(T.PVPNotifyOff, 4000)
            end
        end,
        restricted = not Config.PVPToggle -- false means it should not display, so we have to negate with the not
    }
}

CreateThread(function()
    repeat Wait(0) until LocalPlayer.state.IsInSession
    for _, value in pairs(PlayerCommands) do
        if not value.restricted then
            RegisterCommand(value.command, function()
                value.run()
            end, false)
            TriggerEvent("chat:addSuggestion", "/" .. value.command, value.suggestion)
        end
    end
end)
