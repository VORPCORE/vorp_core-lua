--TX ADMIN HEAL EVENT
AddEventHandler('txAdmin:events:healedPlayer', function(eventData)
    if GetInvokingResource() ~= "monitor" or type(eventData) ~= "table" or type(eventData.id) ~= "number" then
        return
    end

    local Player = eventData.id
    if Player ~= -1 then
        local identifier = GetPlayerIdentifierByType(Player, 'steam')
        if not identifier or not _users[identifier] then return end

        local Character = _users[identifier].GetUsedCharacter()
        if Character and Character.isdead then
            CoreFunctions.NotifyRightTip(Player, Translation[Lang].Notify.healself, 4000)
            CoreFunctions.Player.Revive(Player)
        end
    else
        CoreFunctions.NotifyRightTip(-1, Translation[Lang].Notify.healall, 4000)
        CoreFunctions.Player.Revive(-1)
    end
end)


RegisterNetEvent('vorp:ImDead', function(isDead)
    local _source = source

    local identifier = GetPlayerIdentifierByType(_source, 'steam')
    if identifier and _users[identifier] then
        local Character = _users[identifier].GetUsedCharacter()
        if Character then
            Character.setDead(isDead)
        end
    end
end)


RegisterServerEvent('vorp:SaveDate', function()
    local _source = source
    local identifier = GetPlayerIdentifierByType(_source, 'steam')
    local Character = _users[identifier].GetUsedCharacter()
    local charid = Character.charIdentifier
    MySQL.update("UPDATE characters SET LastLogin =NOW() WHERE charidentifier =@charidentifier", { charidentifier = charid })
end)


RegisterNetEvent("vorp_core:PlayerRespawnInternal", function(param)
    local _source = source
    CoreFunctions.Player.Respawn(_source, param)
end)


RegisterServerEvent('vorp_core:Server:OnPlayerDeath')
AddEventHandler('vorp_core:Server:OnPlayerDeath', function(killerServerId)
    local _source = source
    local identifier = GetPlayerIdentifierByType(_source, 'steam')
    local victimSteamName = GetPlayerName(_source)

    if not _users[identifier] then
        return
    end

    local title = Translation[Lang].addWebhook.deathLogTitle
    local webhook = Logs.DeathWebhookURL
    local description = Translation[Lang].addWebhook.PlayerDied .. "\n"
        .. Translation[Lang].addWebhook.victimSteamName .. victimSteamName .. "\n"
        .. Translation[Lang].addWebhook.victimSteamId .. identifier .. "\n"
        .. Translation[Lang].addWebhook.victimServerId .. _source .. "\n"

    if killerServerId ~= 0 then
        local killerIdentifier = GetPlayerIdentifierByType(killerServerId, 'steam')
        local killerSteamName = GetPlayerName(killerServerId)
        description = description
            .. Translation[Lang].addWebhook.killerSteamName .. killerSteamName .. "\n"
            .. Translation[Lang].addWebhook.killerSteamId .. killerIdentifier .. "\n"
            .. Translation[Lang].addWebhook.killerServerId .. killerServerId
    end

    CoreFunctions.AddWebhook(title, webhook, description)
end)
