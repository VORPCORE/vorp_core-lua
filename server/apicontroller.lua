local function _getUsedCharacter(player)
    local sid = GetSteamID(player)

    if not sid then
        return nil
    end

    local user = _users[sid] or nil

    if not user then
        return nil
    end

    local used_char = user.GetUsedCharacter() or nil

    return used_char
end

local function _getCharDetails(player)
    local used_char = _getUsedCharacter(player)

    if not used_char then
        return nil
    end

    local char = used_char.getCharacter() or nil

    return char
end

AddEventHandler('vorp:getCharacter', function(player, cb)
    local char_details = _getCharDetails(player)

    if char_details ~= nil then
        cb(char_details)
    end
end)

AddEventHandler('vorp:addMoney', function(player, typeCash, quantity)
    local used_char = _getUsedCharacter(player)

    if used_char ~= nil then
        used_char.addCurrency(typeCash, quantity)
        used_char.updateCharUi()
    end
end)

AddEventHandler('vorp:removeMoney', function(player, typeCash, quantity)
    local used_char = _getUsedCharacter(player)

    if used_char ~= nil then
        used_char.removeCurrency(typeCash, quantity)
        used_char.updateCharUi()
    end
end)

AddEventHandler('vorp:addXp', function(player, quantity)
    local used_char = _getUsedCharacter(player)

    if used_char ~= nil then
        used_char.addXp(quantity)
        used_char.updateCharUi()
    end
end)

AddEventHandler('vorp:removeXp', function(player, quantity)
    local used_char = _getUsedCharacter(player)

    if used_char ~= nil then
        used_char.removeXp(quantity)
        used_char.updateCharUi()
    end
end)

AddEventHandler('vorp:setJob', function(player, job, jobgrade)
    local used_char = _getUsedCharacter(player)

    if used_char ~= nil then
        used_char.setJob(job)
        used_char.setJobGrade(jobgrade)
    end
end)

AddEventHandler('vorp:setGroup', function(player, group)
    local used_char = _getUsedCharacter(player)

    if used_char ~= nil then
        used_char.setGroup(group)
    end
end)

AddEventHandler('vorp:whitelistPlayer', function(id)
    AddUserToWhitelistById(id)
end)

AddEventHandler('vorp:unwhitelistPlayer', function(id)
    RemoveUserFromWhitelistById(id)
end)

local ResourceName = GetCurrentResourceName()
if ResourceName ~= 'vorp_core' then
    return error(
        "^3WARNING ^0This resource is not named correctly, please change it to ^1'vorp_core'^0 to work properly.", 1)
end

AddEventHandler('getCore', function(cb)
    local coreData = {}

    coreData.getUser = function(source)
        if source == nil then return nil end

        local sid = GetSteamID(source)

        if _users[sid] then
            return _users[sid].GetUser()
        else
            return nil
        end
    end

    coreData.maxCharacters = Config.MaxCharacters

    coreData.addRpcCallback = function(name, callback)
        ServerRPC.Callback.Register(name, callback)
    end

    coreData.getUsers = function()
        return _users
    end

    coreData.NotifyTip = function(source, text, duration)
        TriggerClientEvent('vorp:Tip', source, text, duration)
    end

    coreData.NotifyLeft = function(source, title, subtitle, dict, icon, duration, colors)
        TriggerClientEvent('vorp:NotifyLeft', source, title, subtitle, dict, icon, duration, colors)
    end

    coreData.NotifyRightTip = function(source, text, duration)
        TriggerClientEvent('vorp:TipRight', source, text, duration)
    end

    coreData.NotifyObjective = function(source, text, duration)
        TriggerClientEvent('vorp:TipBottom', source, text, duration)
    end

    coreData.NotifyTop = function(source, text, location, duration)
        TriggerClientEvent('vorp:NotifyTop', source, text, location, duration)
    end

    coreData.NotifySimpleTop = function(source, text, subtitle, duration)
        TriggerClientEvent('vorp:ShowTopNotification', source, text, subtitle, duration)
    end

    coreData.NotifyAvanced = function(source, text, dict, icon, text_color, duration, quality, showquality)
        TriggerClientEvent('vorp:ShowAdvancedRightNotification', source, text, dict, icon, text_color, duration, quality,
            showquality)
    end

    coreData.NotifyCenter = function(source, text, duration, color)
        TriggerClientEvent('vorp:ShowSimpleCenterText', source, text, duration, color)
    end

    coreData.NotifyBottomRight = function(source, text, duration)
        TriggerClientEvent('vorp:ShowBottomRight', source, text, duration)
    end

    coreData.NotifyFail = function(source, text, subtitle, duration)
        TriggerClientEvent('vorp:failmissioNotifY', source, text, subtitle, duration)
    end

    coreData.NotifyDead = function(source, title, audioRef, audioName, duration)
        TriggerClientEvent('vorp:deadplayerNotifY', source, title, audioRef, audioName, duration)
    end

    coreData.NotifyUpdate = function(source, title, subtitle, duration)
        TriggerClientEvent('vorp:updatemissioNotify', source, title, subtitle, duration)
    end

    coreData.NotifyBasicTop = function(source, title, duration)
        TriggerClientEvent('vorp:ShowBasicTopNotification', source, title, duration)
    end

    coreData.NotifyWarning = function(source, title, msg, audioRef, audioName, duration)
        TriggerClientEvent('vorp:warningNotify', source, title, msg, audioRef, audioName, duration)
    end
    coreData.NotifyLeftRank = function(source, title, subtitle, dict, icon, duration, color)
        TriggerClientEvent('vorp:LeftRank', source, title, subtitle, dict, icon, duration, color)
    end

    coreData.dbUpdateAddTables = function(tbl)
        dbupdaterAPI.addTables(tbl)
    end

    coreData.dbUpdateAddUpdates = function(updt)
        dbupdaterAPI.addUpdates(updt)
    end

    coreData.AddWebhook = function(title, webhook, description, color, name, logo, footerlogo, avatar)
        TriggerEvent('vorp_core:addWebhook', title, webhook, description, color, name, logo, footerlogo, avatar)
    end

    cb(coreData)
end)

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
