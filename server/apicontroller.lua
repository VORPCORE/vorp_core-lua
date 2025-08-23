---@class CORE_SERVER
---@field public maxCharacters fun(source:number):number
---@field public getUsers fun():table
---@field public getUser fun(source:number):table | nil
---@field public getUserByCharId fun(charid:number):table | nil
---@field public NotifyTip fun(source:number, text:string, duration:number)
---@field public NotifyLeft fun(source:number, title:string, subtitle:string, dict:string, icon:string, duration:number, color:string)
---@field public NotifyRightTip fun(source:number, text:string, duration:number)
---@field public NotifyObjective fun(source:number, text:string, duration:number)
---@field public NotifyTop fun(source:number, text:string, location:string, duration:number)
---@field public NotifySimpleTop fun(source:number, text:string, subtitle:string, duration:number)
---@field public NotifyAvanced fun(source:number, text:string, dict:string, icon:string, text_color:string, duration:number, quality:number, showquality:boolean)
---@field public NotifyCenter fun(source:number, text:string, duration:number, color:string)
---@field public NotifyBottomRight fun(source:number, text:string, duration:number)
---@field public NotifyFail fun(source:number, text:string, subtitle:string, duration:number)
---@field public NotifyDead fun(source:number, title:string, audioRef:string, audioName:string, duration:number)
---@field public NotifyUpdate fun(source:number, title:string, subtitle:string, duration:number)
---@field public NotifyBasicTop fun(source:number, title:string, duration:number)
---@field public NotifyWarning fun(source:number, title:string, msg:string, audioRef:string, audioName:string, duration:number)
---@field public NotifyLeftRank fun(source:number, title:string, subtitle:string, dict:string, icon:string, duration:number, color:string)
---@field public dbUpdateAddTables fun(tbl:table)
---@field public dbUpdateAddUpdates fun(updt:table)
---@field public AddWebhook fun(title:string, webhook:string, description:string, color:string, name:string, logo:string?, footerlogo:string?, avatar:string?)
---@field public Register fun(name:string, callback:function)
---@field public TriggerAsync fun(name:string, source:number, callback:function, ...:any?)
---@field public TriggerAwait fun(name:string, source:number, ...:any?):any
---@field public getEntry fun(identifier:string):table
---@field public whitelistUser fun(steam:string):nil | boolean
---@field public unWhitelistUser fun(steam:string):nil | boolean
---@field public Heal fun(source:number)
---@field public Revive fun(source:number, param:any)
---@field public Respawn fun(source:number, param:any)
CoreFunctions = {}

CoreFunctions.maxCharacters = function(source)
    return GetMaxCharactersAllowed(source)
end

CoreFunctions.getUsers = function()
    return _users
end

CoreFunctions.getUser = function(source)
    if not source then return nil end

    local sid = GetPlayerIdentifierByType(tostring(source), 'steam')
    if not sid or not _users[sid] then return nil end

    return _users[sid].GetUser()
end

CoreFunctions.getUserByCharId = function(charid)
    if charid == nil then return nil end
    for _, v in pairs(_users) do
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
    --- register a server callback to be triggered by the client
    ---@param name string callback name
    ---@param callback function callback function
    Register = function(name, callback)
        ServerRPC.Callback.Register(name, callback)
    end,
    --- asynchronous callback
    ---@param name string callback name
    ---@param source number source id
    ---@param callback function callback function
    ---@param ... any callback arguments if any
    TriggerAsync = function(name, source, callback, ...)
        ServerRPC.Callback.TriggerAsync(name, source, callback, ...)
    end,
    --- synchronous callback
    ---@param name string callback name
    ---@param source number source id
    ---@param ... any callback arguments if any
    ---@return any callback return value if more than one send as a table
    TriggerAwait = function(name, source, ...)
        return ServerRPC.Callback.TriggerAwait(name, source, ...)
    end
}

CoreFunctions.Whitelist = {
    --- get a whitelist entry by identifier
    ---@param identifier string identifier
    ---@return table? entry
    getEntry = function(identifier)
        if not identifier then return nil end
        local userid = Whitelist.Functions.GetUserId(identifier)
        if userid then
            return Whitelist.Functions.GetUsersData(userid)
        end
        return nil
    end,

    --- whitelist a user
    ---@param steam string steam identifier
    ---@return  nil | boolean
    whitelistUser = function(steam)
        if not steam then return end
        return Whitelist.Functions.InsertWhitelistedUser({ identifier = steam, status = true })
    end,
    --- unwhitelist a user
    ---@param steam string steam identifier
    unWhitelistUser = function(steam)
        if not steam then return end
        local id = Whitelist.Functions.GetUserId(steam)
        if id then
            Whitelist.Functions.WhitelistUser(id, false)
        end
    end,
}

CoreFunctions.Player = {
    --- heal a player
    ---@param source number source id
    Heal = function(source)
        if not source then return end
        TriggerEvent("vorp_core:Server:OnPlayerHeal", source)
        TriggerClientEvent("vorp_core:Client:OnPlayerHeal", source)
    end,
    --- revive a player
    ---@param source number source id
    ---@param param any parameter
    Revive = function(source, param)
        if not source then return end
        TriggerEvent("vorp_core:Server:OnPlayerRevive", source, param)
        TriggerClientEvent("vorp_core:Client:OnPlayerRevive", source, param)
    end,
    --- respawn a player
    ---@param source number source id
    ---@param param any parameter
    Respawn = function(source, param)
        if not source then return end
        TriggerEvent("vorp_core:Server:OnPlayerRespawn", source, param)
        TriggerClientEvent("vorp_core:Client:OnPlayerRespawn", source, param)
    end,
}

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


