-------------------------------------------------------------------------------------------------
--------------------------------------- VORP ADMIN COMMANDS -------------------------------------
-- TODO
-- MAKE COMMAND ONLY SHOWING FOR GROUP
-- ADD MORE ADMIN COMMANDS
-- WEBHOOK FOR EACH COMMAND


---------------------------------------------------------------------------------------------------
------------------------------------------ SETGROUP ------------------------------------------------
RegisterCommand("setgroup", function(source, args, rawCommand)
    local _source = source
    if _source > 0 then -- it's a player.
        TriggerEvent("vorp:getCharacter", _source, function(user)
            if user.group == Config.Group.Admin or user.group == Config.Group.Mod then
                local target, newgroup = args[1], args[2]
                local Identifier = GetPlayerIdentifier(_source)
                local discordIdentity = GetIdentity(_source, "discord")
                local discordId = string.sub(discordIdentity, 9)
                local ip = GetPlayerEndpoint(_source)
                local steamName = GetPlayerName(_source)
                local message = "**Steam name: **`" .. steamName .. "`**\nIdentifier**`" .. Identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n**PlayerID** `" .. target .. "` \n**Group given** `" .. newgroup .. "`"

                if newgroup == nil or newgroup == '' then
                    TriggerClientEvent("vorp:Tip", _source, "ERROR: Use Correct Sintaxis", 4000)
                    return
                end

                TriggerEvent("vorp:setgroupWebhook", "📋` /Group command` ", message, color)
                TriggerEvent("vorp:setGroup", target, newgroup)
                TriggerClientEvent("vorp:Tip", _source, string.format("Player %s have group %s", target, newgroup), 4000)

            else
                TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000)
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


---------------------------------------------------------------------------------------------------
------------------------------------------ SETJOB  ------------------------------------------------
RegisterCommand("setjob", function(source, args, rawCommand)
    local _source = source
    if _source > 0 then -- it's a player.
        TriggerEvent("vorp:getCharacter", _source, function(user)
            if user.group == Config.Group.Admin or user.group == Config.Group.Mod then
                local target, newjob, jobgrade = args[1], args[2], args[3]
                local Identifier = GetPlayerIdentifier(_source)
                local discordIdentity = GetIdentity(_source, "discord")
                local discordId = string.sub(discordIdentity, 9)
                local ip = GetPlayerEndpoint(_source)
                local steamName = GetPlayerName(_source)
                local message = "**Steam name: **`" .. steamName .. "`**\nIdentifier**`" .. Identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **PlayerID** `" .. target .. "` \n**Job given** `" .. newjob .. "`\n **Grade:** `" .. jobgrade .. "`"

                if newjob == nil or newjob == '' then
                    if jobgrade == nil or jobgrade == '' then
                        TriggerClientEvent("vorp:Tip", _source, "ERROR: Use Correct Sintaxis", 4000)
                        return
                    end
                end

                TriggerEvent("vorp:setJob", target, newjob, jobgrade)
                TriggerClientEvent("vorp:Tip", _source, string.format("Target %s have new job %s", target, newjob), 4000)
                TriggerEvent("vorp:setjobWebhook", "📋` /Job command` ", message, color)
            else
                TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000)
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



---------------------------------------------------------------------------------------------------
------------------------------------------ ADDCASH/GOLD ------------------------------------------------
RegisterCommand("addmoney", function(source, args, rawCommand)
    local _source = source
    if _source > 0 then -- it's a player.
        TriggerEvent("vorp:getCharacter", _source, function(user)
            if user.group == Config.Group.Admin or user.group == Config.Group.Mod then
                local target, montype, quantity = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
                local Identifier = GetPlayerIdentifier(_source)
                local discordIdentity = GetIdentity(_source, "discord")
                local discordId = string.sub(discordIdentity, 9)
                local ip = GetPlayerEndpoint(_source)
                local steamName = GetPlayerName(_source)
                local message = "**Steam name: **`" .. steamName .. "`**\nIdentifier**`" .. Identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n**PlayerId:** `" .. target .. "` \n **Type** `" .. montype .. "` \n**Quantity** `" .. quantity .. "`"

                TriggerEvent("vorp:addMoney", target, montype, quantity)
                TriggerClientEvent("vorp:Tip", _source, string.format("Added %s to %s", target, quantity), 4000)
                TriggerEvent("vorp:addmoneyWebhook", "📋` /Addmoney command` ", message, color)
            else
                TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000)
            end
        end)
    else
        local target, montype, quantity = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])

        TriggerEvent("vorp:addMoney", target, montype, quantity)
    end
end, false)


---------------------------------------------------------------------------------------------------
------------------------------------------ DELLMONEY ------------------------------------------------
RegisterCommand("delcurrency", function(source, args, rawCommand)
    local _source = source

    if _source > 0 then -- it's a player.
        TriggerEvent("vorp:getCharacter", _source, function(user)

            if user.group == Config.Group.Admin or user.group == Config.Group.Mod then
                local target, montype, quantity = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])

                local Identifier = GetPlayerIdentifier(_source)
                local discordIdentity = GetIdentity(_source, "discord")
                local discordId = string.sub(discordIdentity, 9)
                local ip = GetPlayerEndpoint(_source)
                local steamName = GetPlayerName(_source)
                local message = "**Steam name: **`" .. steamName .. "`**\nIdentifier**`" .. Identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n**PlayerId:** `" .. target .. "` \n **Type** `" .. montype .. "` \n**Quantity** `" .. quantity .. "`"

                print(message)
                TriggerEvent("vorp:removeMoney", target, montype, quantity)
                print("trigger")
                TriggerEvent("vorp:delMoneyWebhook", "📋` /delcurrency command` ", message, color)
                TriggerClientEvent("vorp:Tip", _source, string.format("Removed %s to %s", target, quantity), 4000)


            else
                TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000)
            end
        end)
    else
        local target, montype, quantity = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])

        TriggerEvent("vorp:removeMoney", target, montype, quantity)
    end
end, false)


---------------------------------------------------------------------------------------------------
------------------------------------------ ADDITEM ------------------------------------------------
RegisterCommand("additems", function(source, args, rawCommand)
    local _source = source
    TriggerEvent("vorp:getCharacter", _source, function(user)
        VORP = exports.vorp_inventory:vorp_inventoryApi()
        local id = args[1]
        local item = args[2]
        local count = args[3]
        local Identifier = GetPlayerIdentifier(_source)
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId = string.sub(discordIdentity, 9)
        local ip = GetPlayerEndpoint(_source)
        local steamName = GetPlayerName(_source)
        local message = "**Steam name: **`" .. steamName .. "`**\nIdentifier**`" .. Identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **PlayerId** `" .. id .. "` \n**Item given** `" .. item .. "` \n **Count**`" .. count .. "`"

        if args ~= nil then
            if user.group == Config.Group.Admin or user.group == Config.Group.Mod then
                VORP.addItem(id, item, count)
                TriggerEvent("vorp:addItemsWebhook", "📋` /additems command` ", message, color)
            else
                TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000)
            end
        end
    end)

end, false)

---------------------------------------------------------------------------------------------------
----------------------------------------- ADD WEAPON ----------------------------------------------

RegisterCommand("addweapons", function(source, args, rawCommand)
    local _source = source

    TriggerEvent("vorp:getCharacter", _source, function(user)
        VORP = exports.vorp_inventory:vorp_inventoryApi()
        local id = args[1]
        local weaponHash = tostring(args[2])

        local Identifier = GetPlayerIdentifier(_source)
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId = string.sub(discordIdentity, 9)
        local ip = GetPlayerEndpoint(_source)
        local steamName = GetPlayerName(_source)
        local message = "**Steam name: **`" .. steamName .. "`**\nIdentifier**`" .. Identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **PlayerId** `" .. id .. "` \n**Weapon given** `" .. weaponHash .. "`"

        if args ~= nil then
            TriggerEvent("vorpCore:canCarryWeapons", tonumber(id), 1, function(canCarry)
                if canCarry then
                    if user.group == Config.Group.Admin or user.group == Config.Group.Mod then
                        VORP.createWeapon(tonumber(id), weaponHash)
                        TriggerEvent("vorp:addWeaponsWebhook", "📋` /addweapons command` ", message, color)
                    else
                        TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000)
                    end
                else


                    TriggerClientEvent("vorp:Tip", _source, Config.Langs.cantCarry, 4000)
                end
            end)
        end
    end)

end, false)

------------------------------------------------------------------------------------------------------
---------------------------------------- REVIVE ------------------------------------------------------
RegisterCommand("reviveplayer", function(source, args)
    local _source = source

    TriggerEvent("vorp:getCharacter", _source, function(user)
        local id = args[1]

        local Identifier = GetPlayerIdentifier(_source)
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId = string.sub(discordIdentity, 9)
        local ip = GetPlayerEndpoint(_source)
        local steamName = GetPlayerName(_source)
        local text = "Was Revived"
        local message = "**Steam name: **`" .. steamName .. "`**\nIdentifier**`" .. Identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **PlayerId** `" .. id .. "`\n **Action:** `" .. text .. "`"

        if args ~= nil then
            if user.group == Config.Group.Admin or user.group == Config.Group.Mod then

                TriggerEvent("vorp:reviveWebhook", "📋` /revive command` ", message, color)
                TriggerClientEvent('vorp:resurrectPlayer', id)

            else
                TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000)
            end
        end
    end)

end, false)

------------------------------------------------------------------------------------------------------
------------------------------------ TP TO MARKER ----------------------------------------------------
RegisterCommand("tpm", function(source)
    local _source = source

    TriggerEvent("vorp:getCharacter", _source, function(user)
        local Identifier = GetPlayerIdentifier(_source)
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId = string.sub(discordIdentity, 9)
        local ip = GetPlayerEndpoint(_source)
        local steamName = GetPlayerName(_source)
        local text = "Used TPM"
        local message = "**Steam name: **`" .. steamName .. "`**\nIdentifier**`" .. Identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `" .. text .. "`"

        if user.group == Config.Group.Admin or user.group == Config.Group.Mod then
            TriggerClientEvent('vorp:teleportWayPoint', _source)
            TriggerEvent("vorp:tpmWebhook", "📋` /Tpm command` ", message, color)
        else
            TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000)
        end
    end)
end, false)


------------------------------------------------------------------------------------------------------
-------------------------------------- DELETE WAGONS -------------------------------------------------

RegisterCommand("delwagons", function(source, args)
    local _source = source

    TriggerEvent("vorp:getCharacter", _source, function(user)
        local radius = tonumber(args[1])

        local Identifier = GetPlayerIdentifier(_source)
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId = string.sub(discordIdentity, 9)
        local ip = GetPlayerEndpoint(_source)
        local steamName = GetPlayerName(_source)
        local text = "Used delwagons"
        local message = "**Steam name: **`" .. steamName .. "`**\nIdentifier**`" .. Identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `" .. text .. "` \n **Radius:** `" .. radius .. "`"

        if radius ~= nil then

            if user.group == Config.Group.Admin or user.group == Config.Group.Mod then

                if radius >= 1 then
                    TriggerClientEvent("vorp:deleteVehicle", _source, radius)
                    TriggerEvent("vorp:delWagonWebhook", "📋` /delwagons command` ", message, color)
                end

            else
                TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000)
            end
        end
    end)
end, false)

-------------------------------------------------------------------------------------------------------
-------------------------------------- DELETE HORSE ---------------------------------------------------
RegisterCommand("delhorse", function(source)
    local _source = source

    TriggerEvent("vorp:getCharacter", _source, function(user)
        local Identifier = GetPlayerIdentifier(_source)
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId = string.sub(discordIdentity, 9)
        local ip = GetPlayerEndpoint(_source)
        local steamName = GetPlayerName(_source)
        local text = "Used delhorse"
        local message = "**Steam name: **`" .. steamName .. "`**\nIdentifier**`" .. Identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `" .. text .. "`"
        if user.group == Config.Group.Admin or user.group == Config.Group.Mod then
            TriggerClientEvent("vorp:delHorse", _source)
            TriggerEvent("vorp:delHorseWebhook", "📋` /delhorse command` ", message, color)
        else
            TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000)
        end
    end)

end, false)



RegisterCommand("healplayer", function(source, args, rawCommand)
    local _source = source

    TriggerEvent("vorp:getCharacter", _source, function(user)
        local playerId = tonumber(args[1])
        local Identifier = GetPlayerIdentifier(_source)
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId = string.sub(discordIdentity, 9)
        local ip = GetPlayerEndpoint(_source)
        local steamName = GetPlayerName(_source)
        local text = "Was healed"
        local message = "**Steam name: **`" .. steamName .. "`**\nIdentifier**`" .. Identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "` \n **PlayerId:** `" .. playerId .. "`\n **Action:** `" .. text .. "`"
        if args ~= nil then
            if user.group == Config.Group.Admin or user.group == Config.Group.Mod then
                TriggerClientEvent('vorp:heal', _source, playerId)
                TriggerEvent("vorp:healPlayerWebhook", "📋` /healplayer command` ", message, color)
            else
                TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000)
            end
        end
    end)

end, false)

---------------------------------------------------------------------------------------------------------
----------------------------------- WHITELIST ACTIONS =--------------------------------------------------

RegisterCommand("wlplayer", function(source, args, rawCommand)
    local _source = source
    if _source > 0 then -- it's a player.
        TriggerEvent("vorp:getCharacter", _source, function(user)
            local target = tonumber(args[1])
            local Identifier = GetPlayerIdentifier(_source)
            local discordIdentity = GetIdentity(_source, "discord")
            local discordId = string.sub(discordIdentity, 9)
            local steamName = GetPlayerName(_source)
            local text = "Was whitelisted"
            local message = "**Steam name: **`" .. steamName .. "`**\nIdentifier**`" .. Identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. target .. "`\n **Action:** `" .. text .. "`"
            if args then
                if user.group == Config.Group.Admin or user.group == Config.Group.Mod then
                    TriggerEvent("vorp:whitelistWebhook", "📋` /wlplayer command` ", message, color)
                    TriggerEvent("vorp:whitelistPlayer", target)
                else
                    TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000)
                end
            end
            
        end)
    else
        local target = tonumber(args[1])

        TriggerEvent("vorp:whitelistPlayer", target)
    end
end)

RegisterCommand("unwlplayer", function(source, args, rawCommand)
    local _source = source
    if _source > 0 then -- it's a player.
        TriggerEvent("vorp:getCharacter", _source, function(user)
            local target = tonumber(args[1])
            local Identifier = GetPlayerIdentifier(_source)
            local discordIdentity = GetIdentity(_source, "discord")
            local discordId = string.sub(discordIdentity, 9)
            local steamName = GetPlayerName(_source)
            local text = "was unwhitelisted"
            local message = "**Steam name: **`" .. steamName .. "`**\nIdentifier**`" .. Identifier .. "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. target .. "`\n **Action:** `" .. text .. "`"
            if args then
                if user.group == Config.Group.Admin or user.group == Config.Group.Mod then
                    TriggerEvent("vorp:whitelistWebhook", "📋` /unwlplayer command` ", message, color)
                    TriggerEvent("vorp:unwhitelistPlayer", target)
                else
                    TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000)
                end
            end
            
        end)
    else
        local target = tonumber(args[1])

        TriggerEvent("vorp:unwhitelistPlayer", target)
    end
end)

---------------------------------------------------------------------------------------------------------
----------------------------------- CHAT ADD SUGGESTION --------------------------------------------------

-- TRANSLATE HERE
-- TODO ADD TO CONFIG


RegisterServerEvent("vorp:chatSuggestion")
AddEventHandler("vorp:chatSuggestion", function()
    local _source = source


    TriggerClientEvent("chat:addSuggestion", _source, "/setgroup", "VORPcore command set group to user.", {
        { name = "Id", help = 'player ID' },
        { name = "Group", help = 'Group Name' },

    })

    TriggerClientEvent("chat:addSuggestion", _source, "/setjob", "VORPcore command set job to user.", {
        { name = "Id", help = 'player ID' },
        { name = "Job", help = 'Job Name' },
        { name = "Rank", help = ' player Rank' },
    })

    TriggerClientEvent("chat:addSuggestion", _source, "/addmoney", "VORPcore command add money/gold to user", {
        { name = "Id", help = 'player ID' },
        { name = "Type", help = 'Money 0 Gold 1' },
        { name = "Quantity", help = 'Quantity to give' },
    })

    TriggerClientEvent("chat:addSuggestion", _source, "/delcurrency", "VORPcore command remove money/gold from user", {
        { name = "Id", help = 'player ID' },
        { name = "Type", help = 'Money 0 Gold 1' },
        { name = "Quantity", help = 'Quantity to remove from User' },
    })

    TriggerClientEvent("chat:addSuggestion", _source, "/addwhitelist", "VORPcore command Example: /addwhitelist 11000010c8aa16e", {
        { name = "AddWhiteList", help = ' steam ID like this > 11000010c8aa16e' },
    })

    TriggerClientEvent("chat:addSuggestion", _source, "/additems", " VORPcore command to give items.", {
        { name = "Id", help = 'player ID' },
        { name = "Item", help = 'item name' },
        { name = "Quantity", help = 'amount of items to give' },
    })

    TriggerClientEvent("chat:addSuggestion", _source, "/reviveplayer", " VORPcore command to revive.", {
        { name = "Id", help = 'player ID' },
    })

    TriggerClientEvent("chat:addSuggestion", _source, "/tpm", " VORPcore command  teleport to marker set on the map.", {
    })

    TriggerClientEvent("chat:addSuggestion", _source, "/delwagons", " VORPcore command to delete wagons within radius.", {
        { name = "radius", help = 'add a number from 1 to any' },
    })

    TriggerClientEvent("chat:addSuggestion", _source, "/delhorse", " VORPcore command to delete horses.", {
    })

    TriggerClientEvent("chat:addSuggestion", _source, "/addweapons", " VORPcore command to give weapons.", {
        { name = "Id", help = 'player ID' },
        { name = "Weapon", help = 'Weapon hash name' },

    })

    TriggerClientEvent("chat:addSuggestion", _source, "/healplayer", " VORPcore command to heal players.", {
        { name = "Id", help = 'player ID' },
    })

    TriggerClientEvent("chat:addSuggestion", _source, "/wlplayer", " VORPcore command to add players to whitelist.", {
        { name = "Id", help = 'player ID from Discord user-id' },
    })

    TriggerClientEvent("chat:addSuggestion", _source, "/unwlplayer", " VORPcore command to remove players from whitelist.", {
        { name = "Id", help = 'player ID from Discord user-id' },
    })



end)
