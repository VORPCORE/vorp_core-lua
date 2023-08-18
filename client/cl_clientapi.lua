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
        VorpNotification:DisplayTip(tostring(text), tonumber(duration))
    end

    corefunctions.NotifyLeft = function(title, subtitle, dict, icon, duration, color)
        VorpNotification:NotifyLeft(tostring(title), tostring(subtitle), tostring(dict), tostring(icon),
            tonumber(duration), tostring(color or "COLOR_WHITE"))
    end

    corefunctions.NotifyRightTip = function(text, duration)
        VorpNotification:DisplayTipRight(tostring(text), tonumber(duration))
    end

    corefunctions.NotifyObjective = function(text, duration)
        VorpNotification:DisplayObjective(tostring(text), tonumber(duration))
    end

    corefunctions.NotifyTop = function(text, location, duration)
        VorpNotification:DisplayTopCenter(tostring(text), tostring(location), tonumber(duration))
    end

    corefunctions.NotifySimpleTop = function(text, subtitle, duration)
        VorpNotification:ShowTopNotification(tostring(text), tostring(subtitle), tonumber(duration))
    end

    corefunctions.NotifyAvanced = function(text, dict, icon, text_color, duration, quality, showquality)
        VorpNotification:ShowAdvancedRightNotification(tostring(text), tostring(dict), tostring(icon),
            tostring(text_color), tonumber(duration), quality, showquality)
    end

    corefunctions.NotifyCenter = function(text, duration, text_color)
        VorpNotification:ShowSimpleCenterText(tostring(text), tonumber(duration), tostring(text_color))
    end

    corefunctions.NotifyBottomRight = function(text, duration)
        VorpNotification:ShowBottomRight(tostring(text), tonumber(duration))
    end

    corefunctions.NotifyFail = function(text, subtitle, duration)
        VorpNotification:ShowFailedMission(tostring(text), tostring(subtitle), tonumber(duration))
    end

    corefunctions.NotifyDead = function(title, audioRef, audioName, duration)
        VorpNotification:ShowDeadPlayer(tostring(title), tostring(audioRef), tostring(audioName), tonumber(duration))
    end

    corefunctions.NotifyUpdate = function(title, subtitle, duration)
        VorpNotification:ShowUpdateMission(tostring(title), tostring(subtitle), tonumber(duration))
    end

    corefunctions.NotifyWarning = function(title, msg, audioRef, audioName, duration)
        VorpNotification:ShowWarning(tostring(title), tostring(msg), tostring(audioRef), tostring(audioName),
            tonumber(duration))
    end

    corefunctions.NotifyLeftRank = function(title, subtitle, dict, icon, duration, color)
        VorpNotification:LeftRank(tostring(title), tostring(subtitle), tostring(dict), tostring(icon),
            tonumber(duration), tostring(color or "COLOR_WHITE"))
    end

    corefunctions.AddWebhook = function(title, webhook, description, color, name, logo, footerlogo, avatar)
        TriggerServerEvent('vorp_core:addWebhook', title, webhook, description, color, name, logo, footerlogo, avatar)
    end

    cb(corefunctions)
end)

--==========================================================================================--
