local T = Translation[Lang].MessageOfSystem

AddEventHandler("vorpbans:addtodb", function(status, steamid, datetime)
    local user = _users[steamid]

    if user then
        local source = user.GetUser().source
        if status == true then
            if datetime == 0 then
                DropPlayer(source, Translation[Lang].Notify.banned3)
            else
                local bannedUntil = os.date(Config.DateTimeFormat, datetime + Config.TimeZoneDifference * 3600)
                DropPlayer(source, T.DropReasonBanned .. bannedUntil .. Config.TimeZone)
            end
        end
    end

    MySQL.update("UPDATE users SET banned = @banned, banneduntil=@time WHERE identifier = @identifier", { ['@banned'] = status, ['@time'] = datetime, ['@identifier'] = steamid })
end)


AddEventHandler("vorpwarns:addtodb", function(status, target, source)
    local sid = GetPlayerIdentifierByType(target, 'steam')

    if sid and _users[sid] then
        local user = _users[sid].GetUser()
        local warnings = user.getPlayerwarnings()
        warnings = status and warnings + 1 or warnings - 1
        local notifyMsg = status and T.Warned or T.Unwarned
        TriggerClientEvent("vorp:Tip", target, notifyMsg, 10000)
        user.setPlayerWarnings(warnings)

        MySQL.update("UPDATE users SET warnings = @warnings WHERE identifier = @identifier", { ['@warnings'] = warnings, ['@identifier'] = sid })
        return
    end

    TriggerClientEvent("vorp:Tip", source, "User Is not in game to be warned or id is wrong", 10000)
end)
