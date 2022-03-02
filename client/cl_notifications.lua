RegisterNetEvent('vorp:NotifyLeft', function(title, text, dic, icon, miliseconds)
    LoadTexture(dic)
    exports["vorp_core"]:DisplayLeftNotification(title, text, dic, icon, miliseconds)
end)

RegisterNetEvent('vorp:NotifyTop', function(text, location, miliseconds)
    exports["vorp_core"]:DisplayTopCenterNotification(text, location, miliseconds)
end)

RegisterNetEvent('vorp:TipBottom', function(text, miliseconds)
    exports["vorp_core"]:DisplayObjetive(text, miliseconds)
end)

RegisterNetEvent('vorp:TipRight', function(text, miliseconds)
    exports["vorp_core"]:DisplayRightTip(text, miliseconds)
end)

RegisterNetEvent('vorp:Tip', function(text, miliseconds)
    exports["vorp_core"]:DisplayTip(text, miliseconds)
end)