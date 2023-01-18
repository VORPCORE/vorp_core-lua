--============================= NOTIFICATIONS ==========================================--
RegisterNetEvent('vorp:NotifyLeft')
RegisterNetEvent('vorp:Tip')
RegisterNetEvent('vorp:NotifyTop')
RegisterNetEvent('vorp:TipRight')
RegisterNetEvent('vorp:TipBottom')
RegisterNetEvent('vorp:ShowTopNotification')
RegisterNetEvent('vorp:ShowAdvancedRightNotification')
RegisterNetEvent('vorp:ShowBasicTopNotification')
RegisterNetEvent('vorp:ShowSimpleCenterText')
RegisterNetEvent('vorp:ShowBottomRight')
RegisterNetEvent('vorp:failmissioNotifY')
RegisterNetEvent('vorp:deadplayerNotifY')
RegisterNetEvent('vorp:updatemissioNotify')
RegisterNetEvent('vorp:warningNotify')


AddEventHandler('vorp:NotifyLeft', function(firsttext, secondtext, dict, icon, duration, color)
    local _dict = dict
    local _icon = icon
    local _color = color or "COLOR_WHITE"
    LoadTexture(_dict)

    exports.vorp_core:DisplayLeftNotification(tostring(firsttext), tostring(secondtext), tostring(_dict), tostring(_icon)
        , tonumber(duration), tostring(_color))
end)

AddEventHandler('vorp:Tip', function(text, duration)
    exports.vorp_core:DisplayTip(tostring(text), tonumber(duration))
end)

AddEventHandler('vorp:NotifyTop', function(text, location, duration)
    exports.vorp_core:DisplayTopCenterNotification(tostring(text), tostring(location), tonumber(duration))
end)

AddEventHandler('vorp:TipRight', function(text, duration)
    exports.vorp_core:DisplayRightTip(tostring(text), tonumber(duration))
end)

AddEventHandler('vorp:TipBottom', function(text, duration)
    exports.vorp_core:DisplayObjective(tostring(text), tonumber(duration))
end)

AddEventHandler('vorp:ShowTopNotification', function(tittle, subtitle, duration)
    exports.vorp_core:ShowTopNotification(tostring(tittle), tostring(subtitle), tonumber(duration))
end)

AddEventHandler('vorp:ShowAdvancedRightNotification', function(text, dict, icon, text_color, duration)
    local _dict = dict
    local _icon = icon
    if not LoadTexture(_dict) then
        _dict = "generic_textures"
        LoadTexture(_dict)
        _icon = "tick"
    end
    exports.vorp_core:ShowAdvancedRightNotification(tostring(text), tostring(_dict), tostring(_icon),
        tostring(text_color), tonumber(duration))
end)

AddEventHandler('vorp:ShowBasicTopNotification', function(text, duration)
    exports.vorp_core:ShowBasicTopNotification(tostring(text), tonumber(duration))
end)

AddEventHandler('vorp:ShowSimpleCenterText', function(text, duration)
    exports.vorp_core:ShowSimpleCenterText(tostring(text), tonumber(duration))
end)

AddEventHandler('vorp:ShowBottomRight', function(text, duration)
    exports.vorp_core:showBottomRight(tostring(text), tonumber(duration))
end)

AddEventHandler('vorp:failmissioNotifY', function(title, subtitle, duration)
    exports.vorp_core:failmissioNotifY(tostring(title), tostring(subtitle), tonumber(duration))
end)

AddEventHandler('vorp:deadplayerNotifY', function(title, audioRef, audioName, duration)
    exports.vorp_core:deadplayerNotifY(tostring(title), tostring(audioRef), tostring(audioName), tonumber(duration))
end)


AddEventHandler('vorp:updatemissioNotify', function(utitle, umsg, duration)
    exports.vorp_core:updatemissioNotify(tostring(utitle), tostring(umsg), tonumber(duration))
end)

AddEventHandler('vorp:warningNotify', function(title, msg, audioRef, audioName, duration)
    exports.vorp_core:warningNotify(tostring(title), tostring(msg), tostring(audioRef), tostring(audioName),
        tonumber(duration))
end)
--====================================================================--
