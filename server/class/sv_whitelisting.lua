--class for whitelist entries
function Whitelist(id, identifier, status, firstconnection)
    local self = {}

    self._id = id
    self._identifier = identifier
    self._status = status
    self._firstconnection = firstconnection

    self.Id = function()
        return self._id
    end

    self.Identifier = function()
        return self._identifier
    end

    self.Status = function(value)
        if value~=nil then
            self._status = value
            exports.ghmattimysql:execute('UPDATE whitelist SET status = @status where id = @id', {['@status'] = value, ['@id']=self.Id()}, function(result) end)
        end
        return self._status
    end

    self.Firstconnection = function(value)
        if value~=nil then
            self._firstconnection = value
            exports.ghmattimysql:execute('UPDATE whitelist SET firstconnection = @firstconnection where id = @id', {['@firstconnection'] = value, ['@id']=self.Id()}, function(result) end)
        end
        return self._firstconnection
    end

    self.GetEntry = function()
        local whitelistData = {}

        whitelistData.getId = function()
            return self.Id()
        end

        whitelistData.getIdentifier = function()
            return self.Identifier()
        end

        whitelistData.getStatus = function()
            return self.Status()
        end

        whitelistData.setStatus = function(value)
            return self.Status(value)
        end

        whitelistData.getFirstconnection = function()
            return self.Firstconnection()
        end

        whitelistData.setFirstconnection = function(value)
            return self.Firstconnection(value)
        end

        return whitelistData
    end

    return self
end