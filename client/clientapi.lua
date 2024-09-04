local ScreenResolution = nil
local CoreFunctions = {}

CoreFunctions.RpcCall = function(name, callback, ...)
    ClientRPC.Callback.TriggerAsync(name, callback, ...)
end

CoreFunctions.instancePlayers = function(set)
    TriggerServerEvent("vorp_core:instanceplayers", set)
end

CoreFunctions.AddWebhook = function(title, webhook, description, color, name, logo, footerlogo, avatar)
    TriggerServerEvent('vorp_core:addWebhook', title, webhook, description, color, name, logo, footerlogo, avatar)
end

CoreFunctions.NotifyTip = function(text, duration)
    VorpNotification:NotifyTip(tostring(text), tonumber(duration))
end

CoreFunctions.NotifyLeft = function(title, subtitle, dict, icon, duration, color)
    VorpNotification:NotifyLeft(tostring(title), tostring(subtitle), tostring(dict), tostring(icon), tonumber(duration), tostring(color or "COLOR_WHITE"))
end

CoreFunctions.NotifyRightTip = function(text, duration)
    VorpNotification:NotifyRightTip(tostring(text), tonumber(duration))
end

CoreFunctions.NotifyObjective = function(text, duration)
    TriggerEvent('vorp:TipBottom', text, duration) -- listner
    -- VorpNotification:NotifyObjective(tostring(text), tonumber(duration))
end

CoreFunctions.NotifyTop = function(text, location, duration)
    VorpNotification:NotifyTop(tostring(text), tostring(location), tonumber(duration))
end

CoreFunctions.NotifySimpleTop = function(text, subtitle, duration)
    VorpNotification:NotifySimpleTop(tostring(text), tostring(subtitle), tonumber(duration))
end

CoreFunctions.NotifyAvanced = function(text, dict, icon, text_color, duration, quality, showquality)
    VorpNotification:NotifyAvanced(tostring(text), tostring(dict), tostring(icon), tostring(text_color), tonumber(duration), quality, showquality)
end

CoreFunctions.NotifyBasicTop = function(text, duration)
    VorpNotification:NotifyBasicTop(tostring(text), tonumber(duration))
end

CoreFunctions.NotifyCenter = function(text, duration, text_color)
    VorpNotification:NotifyCenter(tostring(text), tonumber(duration), tostring(text_color))
end

CoreFunctions.NotifyBottomRight = function(text, duration)
    VorpNotification:NotifyBottomRight(tostring(text), tonumber(duration))
end

CoreFunctions.NotifyFail = function(text, subtitle, duration)
    VorpNotification:NotifyFail(tostring(text), tostring(subtitle), tonumber(duration))
end

CoreFunctions.NotifyDead = function(title, audioRef, audioName, duration)
    VorpNotification:NotifyDead(tostring(title), tostring(audioRef), tostring(audioName), tonumber(duration))
end

CoreFunctions.NotifyUpdate = function(title, subtitle, duration)
    VorpNotification:NotifyUpdate(tostring(title), tostring(subtitle), tonumber(duration))
end

CoreFunctions.NotifyWarning = function(title, msg, audioRef, audioName, duration)
    VorpNotification:NotifyWarning(tostring(title), tostring(msg), tostring(audioRef), tostring(audioName), tonumber(duration))
end

CoreFunctions.NotifyLeftRank = function(title, subtitle, dict, icon, duration, color)
    VorpNotification:NotifyLeftRank(tostring(title), tostring(subtitle), tostring(dict), tostring(icon), tonumber(duration), tostring(color or "COLOR_WHITE"))
end

local promise = promise.new()

CoreFunctions.Graphics = {

    ScreenResolution = function()
        if ScreenResolution then
            return ScreenResolution
        end
        SendNUIMessage({ type = "getRes" })
        ScreenResolution = Citizen.Await(promise)
        return ScreenResolution
    end
}

CoreFunctions.Callback = {

    Register = function(name, callback)
        ClientRPC.Callback.Register(name, callback)
    end,
    TriggerAsync = function(name, callback, ...)
        ClientRPC.Callback.TriggerAsync(name, callback, ...)
    end,
    TriggerAwait = function(name, ...)
        return ClientRPC.Callback.TriggerAwait(name, ...)
    end
}

exports('GetCore', function()
    return CoreFunctions
end)

RegisterNUICallback('getRes', function(args, cb)
    promise:resolve(args)
    cb('ok')
end)

--- use exports
---@deprecated
AddEventHandler('getCore', function(cb)
    return cb(CoreFunctions)
end)
