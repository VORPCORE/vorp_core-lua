local T = Translation[Lang].MessageOfSystem
WhiteListedUsers = {}

local function CheckWhitelistStatusOnConnect(identifier)
    local result = MySQL.single.await('SELECT status FROM whitelist WHERE identifier = ?', { identifier })
    if result and result.status ~= nil then
        return result.status and true or false
    end
    return false
end

function GetDiscordID(src)
    local discordId = GetPlayerIdentifierByType(src, 'discord')
    local discordIdentifier = discordId and discordId:sub(9) or ""
    return discordIdentifier
end

AddEventHandler("playerConnecting", function(playerName, setKickReason, deferrals)
    local _source = source
    deferrals.defer()

    local steamIdentifier = GetPlayerIdentifierByType(_source, 'steam')

    Wait(1)
    if not steamIdentifier then
        deferrals.done(T.NoSteam)
        setKickReason(T.NoSteam)
        return CancelEvent()
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
    local license = GetPlayerIdentifierByType(_source, 'license')
    LoadUser(_source, setKickReason, deferrals, steamIdentifier, license)

    if Config.EnableWebhookJoinleave then
        local finaltext = string.format(T.PlayerJoinLeave.Join, playerName, steamIdentifier)
        TriggerEvent("vorp_core:addWebhook", T.JoinTitle, Config.JoinleaveWebhookURL, finaltext)
    end

    --TODO  this can de added as default in class characters
    if Config.SaveDiscordId then
        MySQL.update('UPDATE characters SET `discordid` = ? WHERE `identifier` = ? ', { GetDiscordID(_source), steamIdentifier })
    end
end)

AddEventHandler('playerJoining', function()
    local _source = source

    if not Config.Whitelist then return end

    local identifier = GetPlayerIdentifierByType(_source, 'steam')
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
