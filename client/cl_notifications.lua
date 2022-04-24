RegisterNetEvent('vorp:NotifyLeft')
AddEventHandler('vorp:NotifyLeft', function(title, text, dic, icon, duration)
    LoadTexture(dic)
   exports.vorp_core:DisplayLeftNotification(tostring(title), tostring(text), tostring(dic), tostring(icon), tonumber(duration))
end)

RegisterNetEvent('vorp:NotifyTop')
AddEventHandler('vorp:NotifyTop', function(text, location, duration)
       exports.vorp_core:DisplayTopCenterNotification(tostring(text),tostring(location), tonumber(duration))
end) 

RegisterNetEvent('vorp:TipBottom')
AddEventHandler('vorp:TipBottom', function(text, duration)
   exports.vorp_core:DisplayObjetive(tostring(text), tonumber(duration))
end)

RegisterNetEvent('vorp:TipRight')
AddEventHandler('vorp:TipRight', function(text, duration)
   exports.vorp_core:DisplayRightTip(tostring(text), tonumber(duration))
end)

RegisterNetEvent('vorp:Tip')
AddEventHandler('vorp:Tip', function(text, duration)
    exports.vorp_core:DisplayTip(tostring(text), tonumber(duration))
end)


-------- play a sound -------------
RegisterNetEvent('vorp:PlaySoundFrontEnd')
AddEventHandler('vorp:PlaySoundFrontEnd', function(category,name)
	PlayFrontendSound(category,name)
end)

RegisterNetEvent('vorp:ShowAdvancedRightNotification')
AddEventHandler('vorp:ShowAdvancedRightNotification', function(text, dict, icon, text_color, duration)
    local _dict = dict
    local _icon = icon
    if not LoadTexture(_dict) then
        _dict = "generic_textures"
        LoadTexture(_dict)
        _icon = "tick"
    end
    exports.vorp_core:ShowAdvancedRightNotification(tostring(text), tostring(_dict), tostring(_icon), tostring(text_color), tonumber(duration))
end)
