Core = {}
Core.CharacterData = {}

AddEventHandler('getCore', function(cb)

    --callback
    Core.RpcCall = function(name, callback, args)
        TriggerEvent('vorp:ExecuteServerCallBack', name, callback, args)
    end

    Core.Warning = function(text)
        print("^3WARNING: ^7" .. tostring(text) .. "^7")
    end

    Core.Error = function(text)
        print("^1ERROR: ^7" .. tostring(text) .. "^7")
        TriggerClientEvent("vorp_core:LogError")
    end

    Core.Success = function(text)
        print("^2SUCCESS: ^7" .. tostring(text) .. "^7")
    end

    Core.instancePlayers = function(set)
        TriggerServerEvent("vorp_core:instanceplayers", set)
    end

    Core.NotifyTip = function(text, duration)
        exports.vorp_core:DisplayTip(tostring(text), tonumber(duration))
    end

    Core.NotifyLeft = function(title, subtitle, dict, icon, duration, colors)
        local color = colors or "COLOR_WHITE"
        LoadTexture(dict)
        exports.vorp_core:DisplayLeftNotification(tostring(title), tostring(subtitle), tostring(dict), tostring(icon),
            tonumber(duration), tostring(color))
    end

    Core.NotifyRightTip = function(text, duration)
        exports.vorp_core:DisplayRightTip(tostring(text), tonumber(duration))
    end

    Core.NotifyObjective = function(text, duration)
        exports.vorp_core:DisplayObjective(tostring(text), tonumber(duration))
    end

    Core.NotifyTop = function(text, location, duration)
        exports.vorp_core:DisplayTopCenterNotification(tostring(text), tostring(location), tonumber(duration))
    end

    Core.NotifySimpleTop = function(text, subtitle, duration)
        exports.vorp_core:ShowTopNotification(tostring(text), tostring(subtitle), tonumber(duration))
    end

    Core.NotifyAvanced = function(text, dict, icon, text_color, duration)
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

    Core.NotifyCenter = function(text, duration, text_color)
        exports.vorp_core:ShowSimpleCenterText(tostring(text), tonumber(duration), tostring(text_color))
    end

    Core.NotifyBottomRight = function(text, duration)
        exports.vorp_core:showBottomRight(tostring(text), tonumber(duration))
    end

    Core.NotifyFail = function(text, subtitle, duration)
        exports.vorp_core:failmissioNotifY(tostring(title), tostring(subtitle), tonumber(duration))
    end

    Core.NotifyDead = function(title, audioRef, audioName, duration)
        exports.vorp_core:deadplayerNotifY(tostring(title), tostring(audioRef), tostring(audioName), tonumber(duration))
    end

    Core.NotifyUpdate = function(title, subtitle, duration)
        exports.vorp_core:updatemissioNotify(tostring(title), tostring(subtitle), tonumber(duration))
    end

    Core.NotifyWarning = function(title, msg, audioRef, audioName, duration)
        exports.vorp_core:warningNotify(tostring(title), tostring(msg), tostring(audioRef), tostring(audioName),
            tonumber(duration))
    end

    Core.AddWebhook = function(title, webhook, description, color, name, logo, footerlogo, avatar)
        TriggerServerEvent('vorp_core:addWebhook', title, webhook, description, color, name, logo, footerlogo, avatar)
    end

    Core.GetCharacterData = function() 
        return Core.CharacterData
    end

    Core.GetCurrency = function(currency) 
        if Core.CharacterData.currency[currency] then
            return Core.CharacterData.currency[currency]
        end
        return nil
    end

    Core.GetJob = function()
        return Core.CharacterData.job
    end

    Core.GetFullName = function() 
        return Core.CharacterData.firstname, Core.CharacterData.lastname
    end

    Core.GetXp = function() 
        return Core.CharacterData.xp
    end

    cb(Core)
end)


RegisterNetEvent("vorp:setCharacterData", function(CharacterData) 
    Core.CharacterData = CharacterData
end)

RegisterNetEvent("vorp:setFirstname", function(firstName) 
    Core.CharacterData.firstname = firstName
end)

RegisterNetEvent("vorp:setLastname", function(lastName) 
    Core.CharacterData.lastname = lastName
end)

RegisterNetEvent("vorp:setCurrency", function(currency, value) 
    if Core.CharacterData?.currency ~= nil and Core.CharacterData?.currency[currency] then
        Core.CharacterData.currency[currency] = value
    end
end)

RegisterNetEvent("vorp:setXp", function(xp) 
    Core.CharacterData.xp = xp
end)

RegisterNetEvent("vorp:setJob", function(newJob, oldJob) 
    Core.CharacterData.job = newJob
end)