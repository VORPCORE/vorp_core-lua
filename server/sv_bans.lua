RegisterNetEvent("vorpbans:addtodb")
AddEventHandler("vorpbans:addtodb", function (status, id, datetime)
    local sid = _whitelist[id].GetEntry().getIdentifier() --IdsToIdentifiers[id]

    if status == true then
        for _, player in ipairs(GetPlayers()) do
            if sid == GetPlayerIdentifiers(player)[1] then
                if datetime == 0 then
                    DropPlayer(player, "You were banned permanently!")
                else
                    local bannedUntil = os.date(Config.Langs["DateTimeFormat"], datetime+Config.TimeZoneDifference*3600)
                    DropPlayer(player, Config.Langs["DropReasonBanned"]..bannedUntil..Config.Langs["TimeZone"])
                end
                break
            end
        end
    end

    exports.ghmattimysql:execute("UPDATE users SET banned = @banned, banneduntil=@time WHERE identifier = @identifier", {['@banned'] = status, ['@time'] = datetime, ['@identifier'] = sid}, function(result) end)
end)

RegisterNetEvent("vorpwarns:addtodb")
AddEventHandler("vorpwarns:addtodb", function (status, id)
    local sid = _whitelist[id].GetEntry().getIdentifier() --IdsToIdentifiers[id]

    local resultList = exports.ghmattimysql:executeSync("SELECT * FROM users WHERE identifier = ?", { sid })

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
        local user = resultList[1]
        warnings = user["warnings"]
        if status == true then
            warnings = warnings + 1
        else
            warnings = warnings - 1
        end
    end
    

    exports.ghmattimysql:execute("UPDATE users SET warnings = @warnings WHERE identifier = @identifier", {['@warnings'] = warnings, ['@identifier'] = sid}, function(result) end)
end)