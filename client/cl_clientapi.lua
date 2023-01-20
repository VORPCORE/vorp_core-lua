--================================ VORP CORE API =====================================--
-- for examples look at vorp codumentation

AddEventHandler('getCore', function(cb)
    local corefunctions = {}


    corefunctions.RpcCall = function(name, callback, args)
        TriggerEvent('vorp:ExecuteServerCallBack', name, callback, args)
    end

    corefunctions.Warning = function(text)
        print("^3WARNING: ^7" .. tostring(text) .. "^7")
    end

    corefunctions.Error = function(text)
        print("^1ERROR: ^7" .. tostring(text) .. "^7")
        TriggerClientEvent("vorp_core:LogError")
    end

    corefunctions.Success = function(text)
        print("^2SUCCESS: ^7" .. tostring(text) .. "^7")
    end

    corefunctions.instancePlayers = function(set)
        TriggerServerEvent("vorp_core:instanceplayers", set)
    end

    corefunctions.NotifyTip = function(text, duration)
        exports.vorp_core:DisplayTip(tostring(text), tonumber(duration))
    end

    corefunctions.NotifyLeft = function(title, subtitle, dict, icon, duration, color)
        if not LoadTexture(dict) then
            LoadTexture(dict)
        end
        exports.vorp_core:DisplayLeftNotification(tostring(title), tostring(subtitle), tostring(dict), tostring(icon),
            tonumber(duration), tostring(color))
    end

    corefunctions.NotifyRightTip = function(text, duration)
        exports.vorp_core:DisplayRightTip(tostring(text), tonumber(duration))
    end

    corefunctions.NotifyObjective = function(text, duration)
        exports.vorp_core:DisplayObjective(tostring(text), tonumber(duration))
    end

    corefunctions.NotifyTop = function(text, location, duration)
        exports.vorp_core:DisplayTopCenterNotification(tostring(text), tostring(location), tonumber(duration))
    end

    corefunctions.NotifySimpleTop = function(text, subtitle, duration)
        exports.vorp_core:ShowTopNotification(tostring(text), tostring(subtitle), tonumber(duration))
    end

    corefunctions.NotifyAvanced = function(text, dict, icon, text_color, duration, quality, showquality)
        if not LoadTexture(dict) then
            LoadTexture(dict)
        end
        exports.vorp_core:ShowAdvancedRightNotification(tostring(text), tostring(dict), tostring(icon),
            tostring(text_color), tonumber(duration), quality, showquality)
    end

    corefunctions.NotifyCenter = function(text, duration, text_color)
        exports.vorp_core:ShowSimpleCenterText(tostring(text), tonumber(duration), tostring(text_color))
    end

    corefunctions.NotifyBottomRight = function(text, duration)
        exports.vorp_core:showBottomRight(tostring(text), tonumber(duration))
    end

    corefunctions.NotifyFail = function(text, subtitle, duration)
        exports.vorp_core:failmissioNotifY(tostring(text), tostring(subtitle), tonumber(duration))
    end

    corefunctions.NotifyDead = function(title, audioRef, audioName, duration)
        exports.vorp_core:deadplayerNotifY(tostring(title), tostring(audioRef), tostring(audioName), tonumber(duration))
    end

    corefunctions.NotifyUpdate = function(title, subtitle, duration)
        exports.vorp_core:updatemissioNotify(tostring(title), tostring(subtitle), tonumber(duration))
    end

    corefunctions.NotifyWarning = function(title, msg, audioRef, audioName, duration)
        exports.vorp_core:warningNotify(tostring(title), tostring(msg), tostring(audioRef), tostring(audioName),
            tonumber(duration))
    end

    corefunctions.AddWebhook = function(title, webhook, description, color, name, logo, footerlogo, avatar)
        TriggerServerEvent('vorp_core:addWebhook', title, webhook, description, color, name, logo, footerlogo, avatar)
    end

    cb(corefunctions)
end)

--==========================================================================================--
