-------------------------------------------------------------------------------------------------        
--------------------------------------- VORP ADMIN COMMANDS -------------------------------------
-- TODO 
-- MAKE COMMAND ONLY SHOWING FOR GROUP
-- ADD MORE ADMIN COMMANDS
-- WEBHOOK FOR EACH COMMAND 

------------------------------------- START ---------------------------------------

RegisterCommand("setgroup", function(source, args, rawCommand)
    if source > 0 then -- it's a player.
        TriggerEvent("vorp:getCharacter", source, function(user)
            if user.group == Config.Group.Admin or user.group == Config.Group.Mod then
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
             if user.group == Config.Group.Admin or user.group == Config.Group.Mod then
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
           -- print("ERROR: Use Correct Sintaxis")
            return
        end

        TriggerEvent("vorp:setJob", target, newjob)
    end
end, false)


RegisterCommand("addmoney", function(source, args, rawCommand)
    if source > 0 then -- it's a player.
        TriggerEvent("vorp:getCharacter", source, function(user)
             if user.group == Config.Group.Admin or user.group == Config.Group.Mod then
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
             if user.group == Config.Group.Admin or user.group == Config.Group.Mod then
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

---------------------------------------------------------------------------------------------------
------------------------------------------ ADDITEM ------------------------------------------------
RegisterCommand("additem", function(source, args)
  
    if args ~= nil then
        TriggerEvent("vorp:getCharacter", source, function(user)
            VORP = exports.vorp_inventory:vorp_inventoryApi()
            local id =  args[1]
            local item =  args[2]
            local count =  args[3]

            if user.group == Config.Group.Admin or user.group == Config.Group.Mod then
                VORP.addItem(source, item, count)
            else
                TriggerClientEvent("vorp:Tip", source, Config.Langs["NoPermissions"], 4000)
            end
        end)
    end
end)

---------------------------------------------------------------------------------------------------
----------------------------------------- ADD WEAPON ----------------------------------------------

RegisterCommand("addweapon", function(source, args)

    if args ~= nil then
        TriggerEvent("vorp:getCharacter", source, function(user)
            local _source = source 
            VORP = exports.vorp_inventory:vorp_inventoryApi()
            local id = args[1]
            local weaponHash = tostring(args[2])

            TriggerEvent("vorpCore:canCarryWeapons", tonumber(id), 1, function(canCarry)
                if canCarry then
                    if user.group == Config.Group.Admin or user.group == Config.Group.Mod then
                        VORP.createWeapon(tonumber(id), weaponHash)
                        TriggerClientEvent("vorp:TipRight", _source, "You gave a "..weaponHash, 3000)
                    else 
                        TriggerClientEvent("vorp:Tip", source, Config.Langs["NoPermissions"], 4000)
                    end
                else
                  
                   
                    TriggerClientEvent("vorp:Tip", source, Config.Langs.cantCarry, 4000)
                end
            end)
        end)
    end
end)

------------------------------------------------------------------------------------------------------
---------------------------------------- REVIVE ------------------------------------------------------
RegisterCommand("revive", function(source, args)
    if args ~= nil then
        TriggerEvent("vorp:getCharacter", source, function(user)
            local id =  args[1]
            local _source = source 

            if user.group == Config.Group.Admin or user.group == Config.Group.Mod then 
                TriggerClientEvent('vorp:resurrectPlayer', id)
            else 
                TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000) 
            end
        end)
    end
end)

------------------------------------------------------------------------------------------------------
------------------------------------ TP TO MARKER ----------------------------------------------------
RegisterCommand("tpm", function(source, args)
    TriggerEvent("vorp:getCharacter", source, function(user)
        local _source = source
     
        if user.group == Config.Group.Admin or user.group == Config.Group.Mod then 
            TriggerClientEvent('vorp:teleportWayPoint', _source)
        else 
            TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000)
        end
    end)
end)


------------------------------------------------------------------------------------------------------
-------------------------------------- DELETE WAGONS -------------------------------------------------

RegisterCommand("delwagon", function(source )
    TriggerEvent("vorp:getCharacter", source, function(user)
        local _source = source

        if user.group == Config.Group.Admin or user.group == Config.Group.Mod then 
            TriggerClientEvent("vorp:delWagon",_source)
        else
            TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000)
        end
    end)
end)


RegisterCommand("delhorse", function(source)
    TriggerEvent("vorp:getCharacter", source, function(user)
        local _source = source

        if user.group == Config.Group.Admin or user.group == Config.Group.Mod then 
            TriggerClientEvent("vorp:delHorse",_source)
        else
            TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000)
        end
    end)

end)


 
---------------------------------------------------------------------------------------------------------
----------------------------------- CHAT ADD SUGGESTION --------------------------------------------------

-- TRANSLATE HERE
-- TODO ADD TO CONFIG


RegisterServerEvent("vorp:chatSuggestion")  
AddEventHandler("vorp:chatSuggestion",function()
    local _source = source

    TriggerClientEvent("chat:addSuggestion",_source, "/setgroup", "VORPcore command set group to user.",{
        {name = "Id", help='player ID'},
        {name = "Group", help='Group Name'},
        
    })

    TriggerClientEvent("chat:addSuggestion",_source, "/setjob", "VORPcore command set job to user.",{
        {name = "Id", help='player ID'},
        {name = "Job", help='Job Name'},
        {name = "Rank", help=' player Rank'},
    })

    TriggerClientEvent("chat:addSuggestion",_source, "/addmoney", "VORPcore command add money/gold to user",{
        {name = "Id", help='player ID'},
        {name = "Type", help='Money 0 Gold 1'},
        {name = "Quantity", help='Quantity to give'},
    })

    TriggerClientEvent("chat:addSuggestion", _source, "/delmoney", "VORPcore command remove money/gold from user",{
        {name = "Id", help='player ID'},
        {name = "Type", help='Money 0 Gold 1'},
        {name = "Quantity", help='Quantity to remove from User'},    
    })

    TriggerClientEvent("chat:addSuggestion",_source, "/addwhitelist", "VORPcore command Example: /addwhitelist 11000010c8aa16e",{
        {name = "AddWhiteList", help=' steam ID like this > 11000010c8aa16e'},               
    })
          
    TriggerClientEvent("chat:addSuggestion",_source, "/additem", " VORPcore command to give items.",{
        {name = "Id", help='player ID'},
        {name = "Item", help='item name'},
        {name = "Quantity", help='amount of items to give'},
    })

    TriggerClientEvent("chat:addSuggestion",_source, "/revive", " VORPcore command to revive.",{
        {name = "Id", help='player ID'},
    })

    TriggerClientEvent("chat:addSuggestion",_source, "/tpm", " VORPcore command  teleport to marker set on the map.",{
    })

    TriggerClientEvent("chat:addSuggestion",_source, "/delwagon", " VORPcore command to delete wagons.",{
    })

    TriggerClientEvent("chat:addSuggestion",_source, "/delhorse", " VORPcore command to delete horses.",{
    })

    TriggerClientEvent("chat:addSuggestion",_source, "/addweapon", " VORPcore command to give weapons.",{
        {name = "Id", help='player ID'},
        {name = "Weapon", help='Weapon hash name'},
        
    })


end)
