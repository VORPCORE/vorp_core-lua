---@param player number
---@return table|nil
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

---@param player number
---@return table|nil
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

    coreData.maxCharacters = Config["MaxCharacters"]

    coreData.addRpcCallback = function(name, callback)
        TriggerEvent("vorp:addNewCallBack", name, callback)
    end

    coreData.getUsers = function()
        return _users
    end

    coreData.Warning = function(text)
        print("^3WARNING: ^7" .. tostring(text) .. "^7")
    end

    coreData.Error = function(text)
        print("^1ERROR: ^7" .. tostring(text) .. "^7")
        TriggerClientEvent("vorp_core:LogError")
    end

    coreData.Success = function(text)
        print("^2SUCCESS: ^7" .. tostring(text) .. "^7")
    end

    coreData.NotifyTip = function(source, text, duration)
        local _source = source
        TriggerClientEvent('vorp:Tip', _source, text, duration)
    end

    coreData.NotifyLeft = function(source, title, subtitle, dict, icon, duration, colors)
        local _source = source
        TriggerClientEvent('vorp:NotifyLeft', _source, title, subtitle, dict, icon, duration, colors)
    end

    coreData.NotifyRightTip = function(source, text, duration)
        local _source = source
        TriggerClientEvent('vorp:TipRight', _source, text, duration)
    end

    coreData.NotifyObjective = function(source, text, duration)
        local _source = source
        TriggerClientEvent('vorp:TipBottom', _source, text, duration)
    end

    coreData.NotifyTop = function(source, text, location, duration)
        local _source = source
        TriggerClientEvent('vorp:NotifyTop', _source, text, location, duration)
    end

    coreData.NotifySimpleTop = function(source, text, subtitle, duration)
        local _source = source
        TriggerClientEvent('vorp:ShowTopNotification', _source, text, subtitle, duration)
    end

    coreData.NotifyAvanced = function(source, text, dict, icon, text_color, duration, quality, showquality)
        local _source = source
        TriggerClientEvent('vorp:ShowAdvancedRightNotification', _source, text, dict, icon, text_color, duration, quality
            , showquality)
    end

    coreData.NotifyCenter = function(source, text, duration, color)
        local _source = source
        TriggerClientEvent('vorp:ShowSimpleCenterText', _source, text, duration, color)
    end

    coreData.NotifyBottomRight = function(source, text, duration)
        local _source = source
        TriggerClientEvent('vorp:ShowBottomRight', _source, text, duration)
    end

    coreData.NotifyFail = function(source, text, subtitle, duration)
        local _source = source
        TriggerClientEvent('vorp:failmissioNotifY', _source, text, subtitle, duration)
    end

    coreData.NotifyDead = function(source, title, audioRef, audioName, duration)
        local _source = source
        TriggerClientEvent('vorp:deadplayerNotifY', _source, title, audioRef, audioName, duration)
    end

    coreData.NotifyUpdate = function(source, title, subtitle, duration)
        local _source = source
        TriggerClientEvent('vorp:updatemissioNotify', title, subtitle, duration)
    end

    coreData.NotifyWarning = function(source, title, msg, audioRef, audioName, duration)
        local _source = source
        TriggerClientEvent('vorp:warningNotify', _source, title, msg, audioRef, audioName, duration)
    end

    coreData.dbUpdateAddTables = function(tbl)
        if VorpInitialized == true then
            print('Updates must be added before vorpcore is initiates')
        end
        dbupdaterAPI.addTables(tbl)
    end

    coreData.dbUpdateAddUpdates = function(updt)
        if VorpInitialized == true then
            print('Updates must be added before vorpcore is initiates')
        end
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
