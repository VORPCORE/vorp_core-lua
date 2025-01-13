---@deprecated PLEASE UPDATE TO NEW API
exports('vorpAPI', function()
    local self = {}

    self.getCharacter = function(source)
        local timeout = 200 -- 5 seconds
        local user = nil
        TriggerEvent("vorp:getCharacter", source, function(result)
            user = result
        end)

        while user == nil and timeout ~= 0 do
            timeout = timeout - 1
            Wait(25)
        end

        if timeout == 0 then
            print("VORP Core: Callback is nil or not loaded ERROR: Timeout")
        end
        print("JUST A WARNING: this are deprecated API please refer to api docs to use new ones.")
        return user
    end
    print("JUST A WARNING: this are deprecated API please refer to api docs to use new ones.")

    self.addMoney = function(source, currency, quantity)
        TriggerEvent("vorp:addMoney", source, tonumber(currency), tonumber(quantity))
    end

    self.removeMoney = function(source, currency, quantity)
        TriggerEvent("vorp:removeMoney", source, tonumber(currency), tonumber(quantity))
    end

    self.addXp = function(source, quantity)
        TriggerEvent("vorp:addXp", source, tonumber(quantity))
    end

    self.removeXp = function(source, quantity)
        TriggerEvent("vorp:removeXp", source, tonumber(quantity))
    end

    self.setJob = function(source, jobname)
        TriggerEvent("vorp:setJob", source, jobname)
    end

    self.setGroup = function(source, groupname)
        TriggerEvent("vorp:setGroup", source, groupname)
    end

    self.setJobGrade = function(source, jobgrade)
        TriggerEvent("vorp:setJobGrade", source, jobgrade)
    end

    self.setInstancePlayer = function(source, active)
        TriggerClientEvent("vorp:setInstancePlayer", source, active)
    end

    self.addNewCallBack = function(name, cb)
        TriggerEvent("vorp:addNewCallBack", name, cb)
    end

    return self
end)


local function _getUsedCharacter(player)
    local sid = GetPlayerIdentifierByType(player, 'steam')

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


AddEventHandler('vorp:getCharacter', function(player, cb)
    local function _getCharDetails(player)
        local used_char = _getUsedCharacter(player)

        if not used_char then
            return nil
        end

        local char = used_char.getCharacter() or nil

        return char
    end

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
