---@class Whitelist
---@field _id number
---@field _identifier string
---@field _status boolean
---@field _discordid string
---@field _firstconnection boolean
---@alias whitelistFunctions {id : number, identifier : string, status : boolean, discordid : string, firstconnection : boolean}
Whitelist = {}
Whitelist.Functions = {}
Whitelist.__index = Whitelist
Whitelist.__call = function()
    return 'Whitelist'
end

---@param data {id: number, identifier: string, status: boolean, discordid: string, firstconnection: boolean}
function Whitelist:New(data)
    self = setmetatable({}, Whitelist)
    self._id = data.id
    self._identifier = data.identifier
    self._status = data.status
    self._discordid = data.discordid
    self._firstconnection = data.firstconnection
    return self
end

function Whitelist:Id()
    return self._id
end

function Whitelist:Identifier()
    return self._identifier
end

function Whitelist:Status(value)
    if value ~= nil then
        self._status = value
        MySQL.query('UPDATE whitelist SET status = @status where id = @id', { ['@status'] = value and 1 or 0, ['@id'] = self:Id() })
    end
    return self._status
end

function Whitelist:Discord(value)
    if value ~= nil then
        self._status = value
        MySQL.query('UPDATE whitelist SET discordid = @discordid where id = @id', { ['@discordid'] = value, ['@id'] = self:Id() })
    end
    return self._discordid
end

function Whitelist:Firstconnection(value)
    if value ~= nil then
        self._firstconnection = value
        MySQL.query('UPDATE whitelist SET firstconnection = @firstconnection where id = @id', { ['@firstconnection'] = value, ['@id'] = self:Id() })
    end
    return self._firstconnection
end

function Whitelist:GetEntry()
    return {
        id = self:Id(),
        identifier = self:Identifier(),
        status = self:Status(),
        discordid = self:Discord(),
        firstconnection = self:Firstconnection(),
    }
end

--FUNCTIONS

--- Get the data of a whitelisted user
---@param userid number entry id
---@return whitelistFunctions | nil
function Whitelist.Functions.GetUsersData(userid)
    if WhiteListedUsers[userid] then
        return WhiteListedUsers[userid]:GetEntry()
    end
    return nil
end

--- set the status of a whitelisted user
---@param id number entry id
---@param value boolean
function Whitelist.Functions.WhitelistUser(id, value)
    if not WhiteListedUsers[id] then
        return
    end
    WhiteListedUsers[id]:Status(value)
end

--- set Firstconnection of a whitelisted user
---@param id number entry id
function Whitelist.Functions.GetFirstConnection(id)
    if not WhiteListedUsers[id] then
        return
    end

    return WhiteListedUsers[id]:Firstconnection()
end

--- set Firstconnection of a whitelisted user
---@param id number entry id
---@param value boolean?
function Whitelist.Functions.SetFirstConnection(id, value)
    if not WhiteListedUsers[id] then
        return
    end

    WhiteListedUsers[id]:Firstconnection(value)
end

--- get user id by identifier
---@param identifier string
---@return number | nil
function Whitelist.Functions.GetUserId(identifier)
    for k, v in pairs(WhiteListedUsers) do
        if v:Identifier() == identifier then
            return v:Id()
        end
    end
    return nil
end

--- insert a new whitelisted user
---@param data {identifier: string, status: boolean, discordid: string}
---@return boolean success
function Whitelist.Functions.InsertWhitelistedUser(data)
    local entry = MySQL.single.await('SELECT * FROM whitelist WHERE identifier = ?', { data.identifier })

    if not entry then
        MySQL.prepare.await("INSERT INTO whitelist (identifier, status, discordid, firstconnection) VALUES (?,?,?,?)", { data.identifier, false, data.discordid, true })
        return true
    end

    if entry.status and not entry.firstconnection then
        WhiteListedUsers[entry.id] = Whitelist:New({ id = entry.id, identifier = entry.identifier, status = data.status, discordid = entry.discordid, firstconnection = false })
        return true
    end

    MySQL.update('UPDATE whitelist SET status = @status, discordid = @discordid, firstconnection = @firstconnection where id = @id', { ['@status'] = data.status and 1 or 0, ['@discordid'] = entry.discordid, ['@firstconnection'] = false, ['@id'] = entry.id })
    WhiteListedUsers[entry.id] = Whitelist:New({ id = entry.id, identifier = entry.identifier, status = data.status, discordid = entry.discordid, firstconnection = false })
    return true
end
