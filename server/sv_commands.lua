
------------------------------------------------------------------------
--------                  VORP ADMIN COMMANDS                   --------
------------------------------------------------------------------------


RegisterCommand("setgroup", function(source, args, rawCommand)
    if source > 0 then -- it's a player.
        TriggerEvent("vorp:getCharacter", source, function(user)
            if user.group == Config.Group.Admin  then
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


RegisterCommand("setjob", function(source, args, rawCommand)
    if source > 0 then -- it's a player.
        TriggerEvent("vorp:getCharacter", source, function(user)
            if user.group == Config.Group.Admin then
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


RegisterCommand("addmoney", function(source, args, rawCommand)
    if source > 0 then -- it's a player.
        TriggerEvent("vorp:getCharacter", source, function(user)
            if user.group == Config.Group.Admin then
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
    
        
RegisterCommand("delmoney", function(source, args, rawCommand)
    if source > 0 then -- it's a player.
        TriggerEvent("vorp:getCharacter", source, function(user)
            if user.group == Config.Group.Admin then
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
        
        
RegisterCommand("addwhitelist", function(source, args, rawCommand)
    if source > 0 then -- it's a player.
        TriggerEvent("vorp:getCharacter", source, function(user)
            if user.group == Config.Group.Admin or user.group == Config.Group.Mod then
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



-----------------------------------------------------------------------------------
----------                        CHAT ADD SUGGESTION                --------------
-----------------------------------------------------------------------------------
-- TRANSLATE HERE
-- TODO ADD TO CONFIG

RegisterServerEvent("vorp:chatSuggestion")  
AddEventHandler("vorp:chatSuggestion",function()
    local _source = source

    TriggerClientEvent("chat:addSuggestion",_source, "/setgroup", "set group to user.",{
        {name = "ID", help='player ID'},
        {name = "Group", help='Group Name'},
        
    })

    TriggerClientEvent("chat:addSuggestion",_source, "/setjob", "set job to user.",{
        {name = "ID", help='player ID'},
        {name = "Job", help='Job Name'},
        {name = "Rank", help=' player Rank'},
    })

    TriggerClientEvent("chat:addSuggestion",_source, "/addmoney", "add money to user",{
        {name = "ID", help='player ID'},
        {name = "type", help='Money 0 Gold 1'},
        {name = "Quantity", help='Quantity to give'},
    })

    TriggerClientEvent("chat:addSuggestion", _source, "/delmoney", "remove money from user",{
        {name = "ID", help='player ID'},
        {name = "type", help='Money 0 Gold 1'},
        {name = "Quantity", help='Quantity to remove from User'},    
    })

    TriggerClientEvent("chat:addSuggestion",_source, "/addwhitelist", "Example: /addwhitelist 11000010c8aa16e",{
        {name = "AddWhiteList", help=' steam ID like this > 11000010c8aa16e'},               
    })
             

end)
