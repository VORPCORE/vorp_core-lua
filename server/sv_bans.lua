RegisterNetEvent("vorpbans:addtodb")
AddEventHandler("vorpbans:addtodb", function(status, id, datetime)
    local sid = _whitelist[id].GetEntry().getIdentifier() --IdsToIdentifiers[id]

    if status == true then
        for _, player in ipairs(GetPlayers()) do
            if sid == GetPlayerIdentifiers(player)[1] then
                if datetime == 0 then
                    DropPlayer(player, "You were banned permanently!")
                else
                    local bannedUntil = os.date(Config.Langs["DateTimeFormat"], datetime + Config.TimeZoneDifference *
                        3600)
                    DropPlayer(player, Config.Langs["DropReasonBanned"] .. bannedUntil .. Config.Langs["TimeZone"])
                end
                break
            end
        end
    end

    MySQL.update("UPDATE users SET banned = @banned, banneduntil=@time WHERE identifier = @identifier",
        { ['@banned'] = status, ['@time'] = datetime, ['@identifier'] = sid }, function(result) end)
end)

RegisterNetEvent("vorpwarns:addtodb")
AddEventHandler("vorpwarns:addtodb", function(status, id)
    local sid = _whitelist[id].GetEntry().getIdentifier() --IdsToIdentifiers[id]

    local resultList = MySQL.prepare.await("SELECT 1 FROM users WHERE identifier = ?", { sid })

    local warnings

    if _users[sid] then
        local user = _users[sid].GetUser()
        warnings = user.getPlayerwarnings()

        for _, player in ipairs(GetPlayers()) do
            if sid == GetPlayerIdentifiers(player)[1] then
                if status == true then
                    TriggerClientEvent("vorp:Tip", player, Config.Langs["Warned"], 10000)
                    warnings = warnings + 1
                else
                    TriggerClientEvent("vorp:Tip", player, Config.Langs["Unwarned"], 10000)
                    warnings = warnings - 1
                end
                break
            end
        end

        user.setPlayerWarnings(warnings)
    else
        local user = resultList
        warnings = user.warnings
        if status == true then
            warnings = warnings + 1
        else
            warnings = warnings - 1
        end
    end


    MySQL.update("UPDATE users SET warnings = @warnings WHERE identifier = @identifier",
        { ['@warnings'] = warnings, ['@identifier'] = sid }, function(result) end)
end)

--CHECK IF PLAYER HAS DISCONNECTED INTERNET

local LagCheck = {}

local function RunCheck(source, isNew)
    local _isNew = isNew
    local players = GetPlayers()
    for k, v in ipairs(players) do
        local token = GetPlayerToken(v, 0)
        if token == GetPlayerToken(source, 0) then
            if not _isNew then
                LagCheck[source] = false
            end
            TriggerClientEvent("vorp_antilag:verify", source)
            Wait(1500)
            if not LagCheck[source] then
                print("Attempting Lag switch" .. " " .. GetPlayerName(source) .. " HardwareID" .. token)
                if Config.Kick then
                    DropPlayer(source, 'You got kicked by our Anti Lag Switch!')
                end
            else
                Wait(1000)
                RunCheck(source, false)
            end
        end
    end
end

RegisterNetEvent('vorp_antilag:initialize', function()
    local _source = source
    RunCheck(_source, true)
end)

RegisterNetEvent('vorp_antilag:setLagCheck', function()
    local _source = source
    LagCheck[_source] = true
end)
