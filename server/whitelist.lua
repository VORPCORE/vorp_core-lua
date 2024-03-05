local T = Translation[Lang].MessageOfSystem
WhiteListedUsers = {}

local function CheckWhitelistStatusOnConnect(identifier)
    local result = MySQL.single.await('SELECT status FROM whitelist WHERE identifier = ?', { identifier })
    if result and result.status ~= nil then
        return result.status and true or false
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
            Whitelist.Functions.InsertWhitelistedUser({ identifier = steamIdentifier, discordid = discordIdentifier, status = false })
            deferrals.done(T.NoInWhitelist .. " steam id: " .. steamIdentifier)
            setKickReason(T.NoInWhitelist .. " steam id: " .. steamIdentifier)
            return CancelEvent()
        else
            Whitelist.Functions.InsertWhitelistedUser({ identifier = steamIdentifier, discordid = discordIdentifier, status = true })
        end
    end

    deferrals.update(T.LoadingUser)

    LoadUser(_source, setKickReason, deferrals, steamIdentifier, GetLicenseID(_source))
    if playerName and Config.PrintPlayerInfoOnEnter then
        print("Player ^2" .. playerName .. " ^7steam: ^3" .. steamIdentifier .. "^7 Loading...")
    end

    --TODO  this can de added as default in class characters
    if Config.SaveDiscordId then
        MySQL.update('UPDATE characters SET `discordid` = ? WHERE `identifier` = ? ', { GetDiscordID(_source), steamIdentifier })
    end
end)

AddEventHandler('playerJoining', function()
    local _source = source

    if not Config.Whitelist then
        return
    end

    local identifier = GetSteamID(_source)
    local discordId = GetDiscordID(_source)
    local userid = Whitelist.Functions.GetUserId(identifier)

    if userid and WhiteListedUsers[userid] then
        if not Whitelist.Functions.GetFirstConnection(userid) then
            local steamName = GetPlayerName(_source) or ""
            local message = string.format(Translation[Lang].addWebhook.whitelistid, steamName, identifier, discordId, userid)
            TriggerEvent("vorp_core:addWebhook", Translation[Lang].addWebhook.whitelistid1, Config.NewPlayerWebhook, message)
            Whitelist.Functions.SetFirstConnection(userid, false)
        end
    end
end)
