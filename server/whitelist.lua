_whitelist = {}

local T = Translation[Lang].MessageOfSystem

function AddUserToWhitelistById(id)
    _whitelist[id].GetEntry().setStatus(true)
end

function RemoveUserFromWhitelistById(id)
    _whitelist[id].GetEntry().setStatus(false)
end

local function LoadWhitelist()
    Wait(5000)
    MySQL.query('SELECT * FROM whitelist', {}, function(result)
        if #result > 0 then
            for _, v in ipairs(result) do
                _whitelist[v.id] = Whitelist(v.id, v.identifier, v.status, v.discordid, v.firstconnection)
            end
        end
    end)
end

local function SetUpdateWhitelistPolicy() -- this needs a source to only get these values if player is joining
    while Config.AllowWhitelistAutoUpdate do
        Wait(Config.AllowWhitelistAutoUpdateTimer * 60000)                        -- this needs to be changed and saved on players drop
        _whitelist = {}
        MySQL.query("SELECT * FROM whitelist", {},
            function(result) -- why are we loading all the entries into memmory ? so we are adding to a table even players that are not playing or have been banned or whatever.
                if #result > 0 then
                    for _, v in ipairs(result) do
                        _whitelist[v.id] = Whitelist(v.id, v.identifier, v.status, v.discordid, v.firstconnection)
                    end
                end
            end)
    end
end

local function CheckWhitelistStatusOnConnect(identifier)
    local result = MySQL.single.await('SELECT status FROM whitelist WHERE identifier = ?', { identifier })
    if result and result.status ~= nil then
        return result.status
    else
        return false
    end
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
    for k, v in pairs(_whitelist) do
        if v.GetEntry().getIdentifier() == identifier then
            return v.GetEntry().getId()
        end
    end
end

local function InsertIntoWhitelist(identifier, discordid)
    if GetUserId(identifier) then
        return GetUserId(identifier)
    end

    MySQL.prepare.await("INSERT INTO whitelist (identifier, status, discordid, firstconnection) VALUES (?,?,?,?)", { identifier, false, discordid, true })
    local entryList = MySQL.single.await('SELECT * FROM whitelist WHERE identifier = ?', { identifier })
    _whitelist[entryList.id] = Whitelist(entryList.id, identifier, false, discordid, true)

    return entryList.id
end

CreateThread(function()
    if not Config.Whitelist then return end
    LoadWhitelist()
    SetUpdateWhitelistPolicy()
end)

AddEventHandler("playerConnecting", function(playerName, setKickReason, deferrals)
    local _source = source
    deferrals.defer()

    local steamIdentifier = GetSteamID(_source)
    local discordIdentifier = GetDiscordID(_source)
    local checkStatusWhitelist = CheckWhitelistStatusOnConnect(steamIdentifier)

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
        local playerWlId = GetUserId(steamIdentifier)
        if _whitelist[playerWlId] and checkStatusWhitelist then
            deferrals.done()
        else
            playerWlId = InsertIntoWhitelist(steamIdentifier, discordIdentifier)
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
