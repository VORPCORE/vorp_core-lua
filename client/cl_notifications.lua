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
RegisterNetEvent('vorp:LeftRank')


AddEventHandler('vorp:NotifyLeft', function(firsttext, secondtext, dict, icon, duration, color)
    VorpNotification:NotifyLeft(tostring(firsttext), tostring(secondtext), tostring(dict), tostring(icon)
    , tonumber(duration), (tostring(color) or "COLOR_WHITE"))
end)

AddEventHandler('vorp:Tip', function(text, duration)
    VorpNotification:DisplayTip(tostring(text), tonumber(duration))
end)

AddEventHandler('vorp:NotifyTop', function(text, location, duration)
    VorpNotification:DisplayTopCenter(tostring(text), tostring(location), tonumber(duration))
end)

AddEventHandler('vorp:TipRight', function(text, duration)
    VorpNotification:DisplayTipRight(tostring(text), tonumber(duration))
end)

AddEventHandler('vorp:TipBottom', function(text, duration)
    VorpNotification:DisplayObjective(tostring(text), tonumber(duration))
end)

AddEventHandler('vorp:ShowTopNotification', function(tittle, subtitle, duration)
    VorpNotification:ShowTopNotification(tostring(tittle), tostring(subtitle), tonumber(duration))
end)

AddEventHandler('vorp:ShowAdvancedRightNotification', function(text, dict, icon, text_color, duration, quality)
    VorpNotification:ShowAdvancedRightNotification(tostring(text), tostring(dict), tostring(icon),
        tostring(text_color), tonumber(duration), quality)
end)

AddEventHandler('vorp:ShowBasicTopNotification', function(text, duration)
    VorpNotification:ShowBasicTopNotification(tostring(text), tonumber(duration))
end)

AddEventHandler('vorp:ShowSimpleCenterText', function(text, duration)
    VorpNotification:ShowSimpleCenterText(tostring(text), tonumber(duration))
end)

AddEventHandler('vorp:ShowBottomRight', function(text, duration)
    VorpNotification:ShowBottomRight(tostring(text), tonumber(duration))
end)

AddEventHandler('vorp:failmissioNotifY', function(title, subtitle, duration)
    VorpNotification:ShowFailedMission(tostring(title), tostring(subtitle), tonumber(duration))
end)

AddEventHandler('vorp:deadplayerNotifY', function(title, audioRef, audioName, duration)
    VorpNotification:ShowDeadPlayer(tostring(title), tostring(audioRef), tostring(audioName), tonumber(duration))
end)

AddEventHandler('vorp:updatemissioNotify', function(utitle, umsg, duration)
    VorpNotification:ShowUpdateMission(tostring(utitle), tostring(umsg), tonumber(duration))
end)

AddEventHandler('vorp:warningNotify', function(title, msg, audioRef, audioName, duration)
    VorpNotification:ShowWarning(tostring(title), tostring(msg), tostring(audioRef), tostring(audioName),
        tonumber(duration))
end)

AddEventHandler('vorp:LeftRank', function(title, subtitle, dict, icon, duration, color)
    VorpNotification:LeftRank(tostring(title), tostring(subtitle), tostring(dict), tostring(icon) , tonumber(duration), (tostring(color))) 
end)
 
