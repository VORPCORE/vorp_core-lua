WhiteListedUsers = {}
local T = Translation[Lang].MessageOfSystem

function AddUserToWhitelistById(id)
    WhiteListedUsers[id].GetEntry().setStatus(true)
end

function RemoveUserFromWhitelistById(id)
    WhiteListedUsers[id].GetEntry().setStatus(false)
end

local function SetUpdateWhitelistPolicy()
    while Config.AllowWhitelistAutoUpdate do
        Wait(Config.AllowWhitelistAutoUpdateTimer * 60000)
        WhiteListedUsers = {}
        -- only update users that have loaded
        for key, value in pairs(_users) do
            MySQL.query("SELECT * FROM whitelist WHERE identifier = ?", { value.identifier },
                function(result)
                    if #result > 0 then
                        for _, v in ipairs(result) do
                            WhiteListedUsers[v.id] = Whitelist(v.id, v.identifier, v.status, v.discordid,
                                v.firstconnection)
                        end
                    end
                end)
        end
    end
end

local function CheckWhitelistStatusOnConnect(identifier)
    local result = MySQL.single.await('SELECT status FROM whitelist WHERE identifier = ?', { identifier })
    if result and result.status ~= nil then
        return result.status
    end

    return false
end

function GetSteamID(src)
    local steamId = GetPlayerIdentifierByType(src, 'steam')
    return steamId
end

function GetDiscordID(src)
    local discordId = GetPlayerIdentifierByType(src, 'discord')
    local discordIdentifier = discordId and discordId:sub(9) or ""
    return discordIdentifier
end

function GetLicenseID(src)
    local sid = GetPlayerIdentifiers(src)[2] or false
    if (sid == false or sid:sub(1, 5) ~= "license") then
        return false
    end
    return sid
end

function GetUserId(identifier)
    for k, v in pairs(WhiteListedUsers) do
        if v.GetEntry().getIdentifier() == identifier then
            return v.GetEntry().getId()
        end
    end
end

local function InsertIntoWhitelist(identifier, discordid)
    local entryList = MySQL.single.await('SELECT * FROM whitelist WHERE identifier = ?', { identifier })
    if entryList then
        return entryList.id
    end

    MySQL.prepare.await("INSERT INTO whitelist (identifier, status, discordid, firstconnection) VALUES (?,?,?,?)",
        { identifier, false, discordid, true })
    local entry = MySQL.single.await('SELECT * FROM whitelist WHERE identifier = ?', { identifier })
    WhiteListedUsers[entry.id] = Whitelist(entry.id, identifier, false, discordid, true)

    return entry.id
end

CreateThread(function()
    if not Config.Whitelist then return end
    SetUpdateWhitelistPolicy()
end)

AddEventHandler("playerConnecting", function(playerName, setKickReason, deferrals)
    local _source = source
    deferrals.defer()
    local steamIdentifier = GetSteamID(_source)

    if not steamIdentifier then
        deferrals.done(T.NoSteam)
        setKickReason(T.NoSteam)
        return CancelEvent()
    end

    if Config.CheckDoubleAccounts then
        if _users[steamIdentifier] then
            deferrals.done(T.TwoAccounts)
            setKickReason(T.TwoAccounts2)
            return CancelEvent()
        end

        if _usersLoading[steamIdentifier] then
            deferrals.done(T.AccountEarlyLoad)
            setKickReason(T.AccountEarlyLoad2)
            return CancelEvent()
        end
    end

    if Config.Whitelist then
        local discordIdentifier = GetDiscordID(_source)
        local isPlayerWhiteListed = CheckWhitelistStatusOnConnect(steamIdentifier)

        if not isPlayerWhiteListed then
            local playerWlId = InsertIntoWhitelist(steamIdentifier, discordIdentifier)
            deferrals.done(T.NoInWhitelist .. playerWlId)
            setKickReason(T.NoInWhitelist .. playerWlId)
            return CancelEvent()
        end
    end

    deferrals.update(T.LoadingUser)

    LoadUser(_source, setKickReason, deferrals, steamIdentifier, GetLicenseID(_source))
    if playerName and Config.PrintPlayerInfoOnEnter then
        print("Player ^2" .. playerName .. " ^7steam: ^3" .. steamIdentifier .. "^7 Loading...")
    end
end)
