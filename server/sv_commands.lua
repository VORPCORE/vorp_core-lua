TriggerEvent("vorp:addSuggestion", "/setgroup", "set group to user\n Example: /setgroup playerid mod")
RegisterCommand("setgroup", function(source, args, rawCommand)
    if source > 0 then -- it's a player.
        TriggerEvent("vorp:getCharacter", source, function(user)
            if user.group == "admin" then
                local target, newgroup = args[1], args[2]

                if newgroup == nil or newgroup == '' then
                    TriggerClientEvent("vorp:Tip", source, "ERROR: Use Correct Sintaxis", 4000)
                    return
                end

                TriggerEvent("vorp:setGroup", target, newgroup)
                TriggerClientEvent("vorp:Tip", source, string.format("Target %s have group %s", target, newgroup), 4000)
            else
                TriggerClientEvent("vorp:Tip", source, Config.Langs["NoPermissions"], 4000)
            end
        end)
    else
        local target, newgroup = args[1], args[2]

        if newgroup == nil or newgroup == '' then
            print("ERROR: Use Correct Sintaxis")
            return
        end

        TriggerEvent("vorp:setGroup", target, newgroup)
    end
end, false)

TriggerEvent("vorp:addSuggestion", "/setjob", "set job to user\n Example: /setjob playerid medic");
RegisterCommand("setjob", function(source, args, rawCommand)
    if source > 0 then -- it's a player.
        TriggerEvent("vorp:getCharacter", source, function(user)
            if user.group == "admin" then
                local target, newjob = args[1], args[2]

                if newjob == nil or newjob == '' then
                    TriggerClientEvent("vorp:Tip", source, "ERROR: Use Correct Sintaxis", 4000)
                    return
                end

                TriggerEvent("vorp:setJob", target, newjob)
                TriggerClientEvent("vorp:Tip", source, string.format("Target %s have new job %s", target, newjob), 4000)
            else
                TriggerClientEvent("vorp:Tip", source, Config.Langs["NoPermissions"], 4000)
            end
        end)
    else
        local target, newjob = args[1], args[2]

        if newjob == nil or newjob == '' then
            print("ERROR: Use Correct Sintaxis")
            return
        end

        TriggerEvent("vorp:setJob", target, newjob)
    end
end, false)

TriggerEvent("vorp:addSuggestion", "/addmoney", "add money to user\n Example: /addmoney playerid moneytype quantity");
RegisterCommand("addmoney", function(source, args, rawCommand)
    if source > 0 then -- it's a player.
        TriggerEvent("vorp:getCharacter", source, function(user)
            if user.group == "admin" then
                local target, montype, quantity = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])

                TriggerEvent("vorp:addMoney", target, montype, quantity)
                TriggerClientEvent("vorp:Tip", source, string.format("Added %s to %s", target, quantity), 4000)
            else
                TriggerClientEvent("vorp:Tip", source, Config.Langs["NoPermissions"], 4000)
            end
        end)
    else
        local target, montype, quantity = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])

        TriggerEvent("vorp:addMoney", target, montype, quantity)
    end
end, false)

TriggerEvent("vorp:addSuggestion", "/delmoney", "remove money to user\n Example: /delmoney playerid moneytype quantity");
RegisterCommand("delmoney", function(source, args, rawCommand)
    if source > 0 then -- it's a player.
        TriggerEvent("vorp:getCharacter", source, function(user)
            if user.group == "admin" then
                local target, montype, quantity = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])

                TriggerEvent("vorp:removeMoney", target, montype, quantity)
                TriggerClientEvent("vorp:Tip", source, string.format("Removed %s to %s", target, quantity), 4000)
            else
                TriggerClientEvent("vorp:Tip", source, Config.Langs["NoPermissions"], 4000)
            end
        end)
    else
        local target, montype, quantity = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])

        TriggerEvent("vorp:removeMoney", target, montype, quantity)
    end
end, false)

TriggerEvent("vorp:addSuggestion", "/addwhitelist", "Example: /addwhitelist 11000010c8aa16e");
RegisterCommand("addwhitelist", function(source, args, rawCommand)
    if source > 0 then -- it's a player.
        TriggerEvent("vorp:getCharacter", source, function(user)
            if user.group == "admin" or user.group == "mod" then
                local steamId = args[1]
                exports.ghmattimysql:execute("SELECT * FROM whitelist WHERE identifier = ?", {steamId}, function(result)
                    if #result == 0 then
                        exports.ghmattimysql:execute("INSERT INTO whitelist (`identifier`) VALUES (?)", {steamId})
                        AddUserToWhitelist(steamId)
                        TriggerClientEvent("vorp:Tip", source, string.format("Added %s to whitelist", steamId), 4000);
                    else
                        TriggerClientEvent("vorp:Tip", source, string.format("%s Is Whitelisted %s", steamId, steamId), 4000);
                    end
                end)
            else
                TriggerClientEvent("vorp:Tip", source, Config.Langs["NoPermissions"], 4000)
            end
        end)
    else
        local steamId = args[1]
        exports.ghmattimysql:execute("SELECT * FROM whitelist WHERE identifier = ?", {steamId}, function(result)
            if #result == 0 then
                exports.ghmattimysql:execute("INSERT INTO whitelist (`identifier`) VALUES (?)", {steamId})
                AddUserToWhitelist(steamId)
                print(string.format("Added %s to whitelist", steamId))
            else
                print(string.format("%s Is Whitelisted %s", steamId, steamId))
            end
        end)
    end
end, false)
