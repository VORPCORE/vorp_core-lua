local vorpHideUI = true


RegisterNetEvent('vorp:updateUi', function(stringJson)
    SendNUIMessage(json.decode(stringJson))
end)

RegisterNetEvent('vorp:showUi', function(active)
    local jsonpost = {type="ui",action="hide"}
    if active then jsonpost = {type="ui",action="show"} end

    vorpHideUI = active

    SendNUIMessage(jsonpost)
end)

RegisterNetEvent('vorp:SelectedCharacter', function()
    Citizen.Wait(10000)
    SendNUIMessage({
        type="ui",
        action="initiate",
        hidegold = Config.HideGold,
        hidemoney = Config.HideMoney,
        hidelevel = Config.HideLevel,
        hideid = Config.HideID,
        hidetokens = Config.HideTokens,
        uiposition = Config.UIPosition
    })

    Citizen.CreateThread(function()
        while true do
            if vorpHideUI then
                if IsRadarHidden() then
                    SendNUIMessage({type="ui", action="hide"})
                    vorpHideUI = false
                end
            end

            Citizen.Wait(1000)
        end
    end)
end)

function ToggleVorpUI()
    vorpHideUI = not vorpHideUI
    TriggerEvent("vorp:showUi", vorpHideUI)
end

local hideUI = true
function ToggleAllUI()
    hideUI = not hideUI
    ExecuteCommand("togglechat")
    DisplayRadar(hideUI)
    TriggerEvent("syn_displayrange", hideUI)
    TriggerEvent("vorp:showUi", hideUI)
end