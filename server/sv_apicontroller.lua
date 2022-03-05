local commandSuggestions = {}

AddEventHandler('vorp:getCharacter', function(player, cb)
    local sid = GetSteamID(player)

    if _users[sid] ~= nil then
        cb(_users[sid].GetUsedCharacter().getCharacter())
    end
end)

AddEventHandler('vorp:addMoney', function(player, typeCash, quantity)
    local sid = GetSteamID(player)

    if _users[sid] ~= nil then
        _users[sid].GetUsedCharacter().addCurrency(typeCash, quantity)
        _users[sid].GetUsedCharacter().updateCharUi()
    end
end)

AddEventHandler('vorp:removeMoney', function(player, typeCash, quantity)
    local sid = GetSteamID(player)

    if _users[sid] ~= nil then
        _users[sid].GetUsedCharacter().removeCurrency(typeCash, quantity)
        _users[sid].GetUsedCharacter().updateCharUi()
    end
end)

AddEventHandler('vorp:addXp', function(player, quantity)
    local sid = GetSteamID(player)

    if _users[sid] ~= nil then
        _users[sid].GetUsedCharacter().addXp(quantity)
        _users[sid].GetUsedCharacter().updateCharUi()
    end
end)

AddEventHandler('vorp:removeXp', function(player, quantity)
    local sid = GetSteamID(player)

    if _users[sid] ~= nil then
        _users[sid].GetUsedCharacter().removeXp(quantity)
        _users[sid].GetUsedCharacter().updateCharUi()
    end
end)

AddEventHandler('vorp:setJob', function(player, job)
    local sid = GetSteamID(player)

    if _users[sid] ~= nil then
        _users[sid].GetUsedCharacter().setJob(job)
    end
end)

AddEventHandler('vorp:setGroup', function(player, group)
    local sid = GetSteamID(player)

    if _users[sid] ~= nil then
        _users[sid].GetUsedCharacter().setGroup(group)
    end
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
        print('Callback registered -> ' .. name)
        --ServerCallBacks[name] = callback
        TriggerEvent("vorp:addNewCallBack", name, callback)
    end

    coreData.getUsers = function()
        return _users
    end

    coreData.sendLog = function(msg, type)
        --Nothing
    end
    
    cb(coreData)
end)

AddEventHandler('vorp:addSuggestion', function(commandName, suggestion)
    table.insert(commandSuggestions, {
        name = commandName,
        help = suggestion
    })
end)

RegisterNetEvent('chat:init', function()
    local source = source
    Citizen.Wait(2000)
    TriggerClientEvent('chat:addSuggestions', source, commandSuggestions)
end)
