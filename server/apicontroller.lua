if GetCurrentResourceName() ~= 'vorp_core' then
    return error(
    "^3WARNING ^0This resource is not named correctly, please change it to ^1'vorp_core'^0 to work properly.", 1)
end

local CoreFunctions = {}

CoreFunctions.getUser = function(source)
    if source == nil then return nil end
    local sid = GetSteamID(source)
    if not sid or not _users[sid] then return nil end

    return _users[sid].GetUser()
end

CoreFunctions.maxCharacters = Config.MaxCharacters

CoreFunctions.addRpcCallback = function(name, callback)
    ServerRPC.Callback.Register(name, callback)
end

CoreFunctions.getUsers = function()
    return _users
end

CoreFunctions.NotifyTip = function(source, text, duration)
    TriggerClientEvent('vorp:Tip', source, text, duration)
end

CoreFunctions.NotifyLeft = function(source, title, subtitle, dict, icon, duration, colors)
    TriggerClientEvent('vorp:NotifyLeft', source, title, subtitle, dict, icon, duration, colors)
end

CoreFunctions.NotifyRightTip = function(source, text, duration)
    TriggerClientEvent('vorp:TipRight', source, text, duration)
end

CoreFunctions.NotifyObjective = function(source, text, duration)
    TriggerClientEvent('vorp:TipBottom', source, text, duration)
end

CoreFunctions.NotifyTop = function(source, text, location, duration)
    TriggerClientEvent('vorp:NotifyTop', source, text, location, duration)
end

CoreFunctions.NotifySimpleTop = function(source, text, subtitle, duration)
    TriggerClientEvent('vorp:ShowTopNotification', source, text, subtitle, duration)
end

CoreFunctions.NotifyAvanced = function(source, text, dict, icon, text_color, duration, quality, showquality)
    TriggerClientEvent('vorp:ShowAdvancedRightNotification', source, text, dict, icon, text_color, duration, quality,
        showquality)
end

CoreFunctions.NotifyCenter = function(source, text, duration, color)
    TriggerClientEvent('vorp:ShowSimpleCenterText', source, text, duration, color)
end

CoreFunctions.NotifyBottomRight = function(source, text, duration)
    TriggerClientEvent('vorp:ShowBottomRight', source, text, duration)
end

CoreFunctions.NotifyFail = function(source, text, subtitle, duration)
    TriggerClientEvent('vorp:failmissioNotifY', source, text, subtitle, duration)
end

CoreFunctions.NotifyDead = function(source, title, audioRef, audioName, duration)
    TriggerClientEvent('vorp:deadplayerNotifY', source, title, audioRef, audioName, duration)
end

CoreFunctions.NotifyUpdate = function(source, title, subtitle, duration)
    TriggerClientEvent('vorp:updatemissioNotify', source, title, subtitle, duration)
end

CoreFunctions.NotifyBasicTop = function(source, title, duration)
    TriggerClientEvent('vorp:ShowBasicTopNotification', source, title, duration)
end

CoreFunctions.NotifyWarning = function(source, title, msg, audioRef, audioName, duration)
    TriggerClientEvent('vorp:warningNotify', source, title, msg, audioRef, audioName, duration)
end
CoreFunctions.NotifyLeftRank = function(source, title, subtitle, dict, icon, duration, color)
    TriggerClientEvent('vorp:LeftRank', source, title, subtitle, dict, icon, duration, color)
end

CoreFunctions.dbUpdateAddTables = function(tbl)
    dbupdaterAPI.addTables(tbl)
end

CoreFunctions.dbUpdateAddUpdates = function(updt)
    dbupdaterAPI.addUpdates(updt)
end

CoreFunctions.AddWebhook = function(title, webhook, description, color, name, logo, footerlogo, avatar)
    TriggerEvent('vorp_core:addWebhook', title, webhook, description, color, name, logo, footerlogo, avatar)
end

CoreFunctions.Callback = {
    Register = function(name, callback)
        ServerRPC.Callback.Register(name, callback)
    end,
    TriggerAsync = function(name, source, callback, ...)
        ServerRPC.Callback.TriggerAsync(name, source, callback, ...)
    end,
    TriggerAwait = function(name, source, ...)
        return ServerRPC.Callback.TriggerAwait(name, source, ...)
    end
}

exports('GetCore', function()
    return CoreFunctions
end)

--WHITE LIST
AddEventHandler('getWhitelistTables', function(cb)
    local whitelistData = {}

    whitelistData.getEntry = function(identifier)
        if identifier == nil then return nil end

        local userid = GetUserId(identifier)

        if _whitelist[userid] then
            return _whitelist[userid].GetEntry()
        else
            return nil
        end
    end

    whitelistData.getEntries = function()
        return _whitelist
    end

    cb(whitelistData)
end)

AddEventHandler('vorp:whitelistPlayer', function(id)
    AddUserToWhitelistById(id)
end)

AddEventHandler('vorp:unwhitelistPlayer', function(id)
    RemoveUserFromWhitelistById(id)
end)

--- use exports
---@deprecated
AddEventHandler('getCore', function(cb)
    cb(CoreFunctions)
end)
