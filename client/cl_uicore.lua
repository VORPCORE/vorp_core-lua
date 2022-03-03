RegisterNetEvent('vorp:updateUi', function(stringJson)
    SendNUIMessage(json.decode(stringJson))
end)

RegisterNetEvent('vorp:showUi', function(active)
    local jsonpost = {type="ui",action="hide"}
    if active then jsonpost = {type="ui",action="show"} end
    SendNUIMessage(jsonpost)
end)
