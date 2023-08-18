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
    end

    corefunctions.Success = function(text)
        print("^2SUCCESS: ^7" .. tostring(text) .. "^7")
    end

    corefunctions.instancePlayers = function(set)
        TriggerServerEvent("vorp_core:instanceplayers", set)
    end

    corefunctions.NotifyTip = function(text, duration)
        VorpNotification:NotifyTip(tostring(text), tonumber(duration))
    end

    corefunctions.NotifyLeft = function(title, subtitle, dict, icon, duration, color)
        VorpNotification:NotifyLeft(tostring(title), tostring(subtitle), tostring(dict), tostring(icon),
            tonumber(duration), tostring(color or "COLOR_WHITE"))
    end

    corefunctions.NotifyRightTip = function(text, duration)
        VorpNotification:NotifyRightTip(tostring(text), tonumber(duration))
    end

    corefunctions.NotifyObjective = function(text, duration)
        VorpNotification:NotifyObjective(tostring(text), tonumber(duration))
    end

    corefunctions.NotifyTop = function(text, location, duration)
        VorpNotification:NotifyTop(tostring(text), tostring(location), tonumber(duration))
    end

    corefunctions.NotifySimpleTop = function(text, subtitle, duration)
        VorpNotification:NotifySimpleTop(tostring(text), tostring(subtitle), tonumber(duration))
    end

    corefunctions.NotifyAvanced = function(text, dict, icon, text_color, duration, quality, showquality)
        VorpNotification:NotifyAvanced(tostring(text), tostring(dict), tostring(icon),
            tostring(text_color), tonumber(duration), quality, showquality)
    end
   corefunctions.NotifyBasicTop = function(text, duration)
        VorpNotification:NotifyBasicTop(tostring(text), tonumber(duration))
    end
    corefunctions.NotifyCenter = function(text, duration, text_color)
        VorpNotification:NotifyCenter(tostring(text), tonumber(duration), tostring(text_color))
    end

    corefunctions.NotifyBottomRight = function(text, duration)
        VorpNotification:NotifyBottomRight(tostring(text), tonumber(duration))
    end

    corefunctions.NotifyFail = function(text, subtitle, duration)
        VorpNotification:NotifyFail(tostring(text), tostring(subtitle), tonumber(duration))
    end

    corefunctions.NotifyDead = function(title, audioRef, audioName, duration)
        VorpNotification:NotifyDead(tostring(title), tostring(audioRef), tostring(audioName), tonumber(duration))
    end

    corefunctions.NotifyUpdate = function(title, subtitle, duration)
        VorpNotification:NotifyUpdate(tostring(title), tostring(subtitle), tonumber(duration))
    end

    corefunctions.NotifyWarning = function(title, msg, audioRef, audioName, duration)
        VorpNotification:NotifyWarning(tostring(title), tostring(msg), tostring(audioRef), tostring(audioName),
            tonumber(duration))
    end

    corefunctions.NotifyLeftRank = function(title, subtitle, dict, icon, duration, color)
        VorpNotification:NotifyLeftRank(tostring(title), tostring(subtitle), tostring(dict), tostring(icon),
            tonumber(duration), tostring(color or "COLOR_WHITE"))
    end

    corefunctions.AddWebhook = function(title, webhook, description, color, name, logo, footerlogo, avatar)
        TriggerServerEvent('vorp_core:addWebhook', title, webhook, description, color, name, logo, footerlogo, avatar)
    end

    cb(corefunctions)
end)

--==========================================================================================--
