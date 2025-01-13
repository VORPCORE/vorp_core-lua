CoreFunctions = {}

CoreFunctions.maxCharacters = function(source)
    return GetMaxCharactersAllowed(source)
end

CoreFunctions.getUsers = function()
    return _users
end

CoreFunctions.getUser = function(source)
    if not source then return nil end

    local sid = GetPlayerIdentifierByType(source, 'steam')
    if not sid or not _users[sid] then return nil end

    return _users[sid].GetUser()
end

CoreFunctions.getUserByCharId = function(charid)
    if charid == nil then return nil end
    for k, v in pairs(_users) do
        if v.usedCharacterId ~= -1 and tonumber(v.usedCharacterId) == tonumber(charid) then
            return v.GetUser()
        end
    end
    return nil
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
    TriggerClientEvent('vorp:ShowAdvancedRightNotification', source, text, dict, icon, text_color, duration, quality, showquality)
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

CoreFunctions.Whitelist = {

    getEntry = function(identifier)
        if not identifier then return nil end
        local userid = Whitelist.Functions.GetUserId(identifier)
        if userid then
            return Whitelist.Functions.GetUsersData(userid)
        end
        return nil
    end,

    whitelistUser = function(steam)
        if not steam then return end
        return Whitelist.Functions.InsertWhitelistedUser({ identifier = steam, status = true })
    end,

    unWhitelistUser = function(steam)
        if not steam then return end
        local id = Whitelist.Functions.GetUserId(steam)
        if id then
            Whitelist.Functions.WhitelistUser(id, false)
        end
    end,
}

CoreFunctions.Player = {
    Heal = function(source)
        if not source then return end
        TriggerEvent("vorp_core:Server:OnPlayerHeal", source)
        TriggerClientEvent("vorp_core:Client:OnPlayerHeal", source)
    end,
    Revive = function(source, param)
        if not source then return end
        TriggerEvent("vorp_core:Server:OnPlayerRevive", source, param)
        TriggerClientEvent("vorp_core:Client:OnPlayerRevive", source, param)
    end,
    Respawn = function(source, param)
        if not source then return end
        TriggerEvent("vorp_core:Server:OnPlayerRespawn", source, param)
        TriggerClientEvent("vorp_core:Client:OnPlayerRespawn", source, param)
    end,
}


-- WIP
--[[ CoreFunctions.Command = {

    Register = function(data)
        if Commands[data.name] then
            print('^1[ERROR] ^0Command ^1' .. data.name .. ' ^0already exists.')
            return
        end

        Commands[data.name] = data

        for index, value in pairs(data) do
            RegisterCommands(value, index)
        end
    end,

    Remove = function(name)
        if not Commands[name] then
            print('^1[ERROR] ^0Command ^1' .. name .. ' ^0does not exist can only remove commands you have added through core export.')
            return
        end
        Commands[name] = nil
    end
}
 ]]


--Example usage

--[[ local data = {
    CommandName = {                               -- must be unique
        --webhook
        webhook = "link",                         -- discord log when someone uses this command leave to false if you dont need
        custom = "message to display on webhook", -- for webhook
        title = "webhook title",                  -- webhook title
        ---#end webhook
        commandName = "command name",             -- name of the command to use
        label = "command label",                  -- label of command when using
        suggestion = {                            -- chat arguments needed this is needd to check all arguments have met
            { name = "Id",  help = "palyer id" }, -- add how many you need
            { name = "msg", help = "description" },
        },
        userCheck = true,                         -- does this command need to check if user is online ? lets say its an admin comand and argument is a player id or it could be identifier or char id etc
        groupAllowed = { "admin" },               -- from users table in the database this group will be allowed to use this command
        aceAllowed = 'vorpcore.setGroup.Command', -- ace allow or false must have this in your permissions file
        jobsAllow = {},                           -- jobs allowed ? remove or leave empty if not needed, not supporting ranks yet
        callFunction = function(data)             -- dont touch
            -- you can run code here trigger client events or server events , exports etc,
            -- local source = data.source -- player id
            -- local args = data.args -- arguments from chat
            -- local raw = data.rawCommand
            -- local data = data.config -- all the values you set above
        end
    }
}
 ]]


exports('GetCore', function()
    return CoreFunctions
end)

-----------------------------------------------------------------------------
--- use exports
---@deprecated
AddEventHandler('getCore', function(cb)
    cb(CoreFunctions)
end)

--- use exports
---@deprecated
AddEventHandler('getWhitelistTables', function(cb)
    cb(CoreFunctions.Whitelist)
end)

--- use Core object
---@deprecated
CoreFunctions.addRpcCallback = function(name, callback)
    ServerRPC.Callback.Register(name, callback)
end
