local T = Translation[Lang].MessageOfSystem

AddEventHandler("vorpbans:addtodb", function(status, id, datetime)
    local sid = _whitelist[id].GetEntry().getIdentifier() --IdsToIdentifiers[id]

    if status == true then
        for _, player in ipairs(GetPlayers()) do
            if sid == GetPlayerIdentifiers(player)[1] then
                if datetime == 0 then
                    DropPlayer(player, Translation[Lang].Notify.banned3)
                else
                    local bannedUntil = os.date(Config.DateTimeFormat, datetime + Config.TimeZoneDifference * 3600)
                    DropPlayer(player, T.DropReasonBanned .. bannedUntil .. Config.TimeZone)
                end
                break
            end
        end
    end

    MySQL.update("UPDATE users SET banned = @banned, banneduntil=@time WHERE identifier = @identifier",
        { ['@banned'] = status, ['@time'] = datetime, ['@identifier'] = sid }, function(result)
        end)
end)


AddEventHandler("vorpwarns:addtodb", function(status, id)
    local sid = _whitelist[id].GetEntry().getIdentifier() --IdsToIdentifiers[id]

    local resultList = MySQL.prepare.await("SELECT * FROM users WHERE identifier = ?", { sid })

    local warnings

    if _users[sid] then
        local user = _users[sid].GetUser()
        warnings = user.getPlayerwarnings()

        for _, player in ipairs(GetPlayers()) do
            if sid == GetPlayerIdentifiers(player)[1] then
                if status == true then
                    TriggerClientEvent("vorp:Tip", tonumber(player), T["Warned"], 10000)
                    warnings = warnings + 1
                else
                    TriggerClientEvent("vorp:Tip", tonumber(player), T["Unwarned"], 10000)
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
        { ['@warnings'] = warnings, ['@identifier'] = sid }, function(result)
        end)
end)
