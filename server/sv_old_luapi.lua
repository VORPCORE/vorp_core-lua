--DEPRECATE PLEASE UPDATE TO NEW API

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

        return user
    end

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
