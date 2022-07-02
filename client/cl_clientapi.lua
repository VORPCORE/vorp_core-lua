AddEventHandler('getCore', function(cb)
    local corefunctions = {}

    --callback
    corefunctions.RpcCall = function(name, callback, args)
        TriggerEvent('vorp:ExecuteServerCallBack', name, callback, args)
    end

    corefunctions.NotifyTip = function(text, duration)
        exports.vorp_core:DisplayTip(tostring(text), tonumber(duration))
    end

    corefunctions.NotifyLeft = function(title, subtitle, dict, icon, duration, colors)
        local color = colors or "COLOR_WHITE"
        LoadTexture(dict)
        exports.vorp_core:DisplayLeftNotification(tostring(title), tostring(subtitle), tostring(dict), tostring(icon),
            tonumber(duration), tostring(color))
    end

    corefunctions.displayRightTip = function(text, duration)
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

    corefunctions.NotifyAvanced = function(text, dict, icon, text_color, duration)
        local _dict = dict
        local _icon = icon
        if not LoadTexture(_dict) then
            _dict = "generic_textures"
            LoadTexture(_dict)
            _icon = "tick"
        end
        exports.vorp_core:ShowAdvancedRightNotification(tostring(text), tostring(_dict), tostring(_icon),
            tostring(text_color), tonumber(duration))
    end

    corefunctions.NotifyCenter = function(text, duration)
        exports.vorp_core:ShowSimpleCenterText(tostring(text), tonumber(duration),tostring(color))
    end

    corefunctions.NotifyBottomRight = function(text, duration)
        exports.vorp_core:showBottomRight(tostring(text), tonumber(duration))
    end

    corefunctions.NotifyFail = function(text, subtitle, duration)
        exports.vorp_core:failmissioNotifY(tostring(title), tostring(subtitle), tonumber(duration))
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

    cb(corefunctions)
end)
