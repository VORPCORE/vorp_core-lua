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
        local ace = IsPlayerAceAllowed(_source, 'vorpcore.setGroup.Command')

        TriggerEvent("vorp:getCharacter", _source, function(user)
            if ace or user.group == Config.Group.Admin or
                user.group == Config.Group.Mod then
                local target, newgroup = args[1], args[2]
                local Identifier = GetPlayerIdentifier(_source)
                local discordIdentity = GetIdentity(_source, "discord")
                local discordId = string.sub(discordIdentity, 9)
                local ip = GetPlayerEndpoint(_source)
                local steamName = GetPlayerName(_source)
                local message = "**Steam name: **`" ..
                    steamName ..
                    "`**\nIdentifier**`" ..
                    Identifier ..
                    "` \n**Discord:** <@" ..
                    discordId ..
                    ">**\nIP: **`" .. ip .. "`\n**PlayerID** `" .. target .. "` \n**Group given** `" .. newgroup .. "`"

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
        local ace = IsPlayerAceAllowed(_source, 'vorpcore.setJob.Command')
        TriggerEvent("vorp:getCharacter", _source, function(user)
            if ace or user.group == Config.Group.Admin or
                user.group == Config.Group.Mod then
                local target, newjob, jobgrade = args[1], args[2], args[3]
                local Identifier = GetPlayerIdentifier(_source)
                local discordIdentity = GetIdentity(_source, "discord")
                local discordId = string.sub(discordIdentity, 9)
                local ip = GetPlayerEndpoint(_source)
                local steamName = GetPlayerName(_source)
                local message = "**Steam name: **`" ..
                    steamName ..
                    "`**\nIdentifier**`" ..
                    Identifier ..
                    "` \n**Discord:** <@" ..
                    discordId ..
                    ">**\nIP: **`" ..
                    ip ..
                    "`\n **PlayerID** `" ..
                    target .. "` \n**Job given** `" .. newjob .. "`\n **Grade:** `" .. jobgrade .. "`"

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
        local ace = IsPlayerAceAllowed(_source, 'vorpcore.addMoney.Command')
        TriggerEvent("vorp:getCharacter", _source, function(user)
            if ace or user.group == Config.Group.Admin or
                user.group == Config.Group.Mod then
                local target, montype, quantity = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
                local Identifier = GetPlayerIdentifier(_source)
                local discordIdentity = GetIdentity(_source, "discord")
                local discordId = string.sub(discordIdentity, 9)
                local ip = GetPlayerEndpoint(_source)
                local steamName = GetPlayerName(_source)
                local message = "**Steam name: **`" ..
                    steamName ..
                    "`**\nIdentifier**`" ..
                    Identifier ..
                    "` \n**Discord:** <@" ..
                    discordId ..
                    ">**\nIP: **`" ..
                    ip ..
                    "`\n**PlayerId:** `" ..
                    target .. "` \n **Type** `" .. montype .. "` \n**Quantity** `" .. quantity .. "`"

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
        local ace = IsPlayerAceAllowed(_source, 'vorpcore.delCurrency.Command')
        TriggerEvent("vorp:getCharacter", _source, function(user)

            if ace or user.group == Config.Group.Admin or
                user.group == Config.Group.Mod then
                local target, montype, quantity = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
                local Identifier = GetPlayerIdentifier(_source)
                local discordIdentity = GetIdentity(_source, "discord")
                local discordId = string.sub(discordIdentity, 9)
                local ip = GetPlayerEndpoint(_source)
                local steamName = GetPlayerName(_source)
                local message = "**Steam name: **`" ..
                    steamName ..
                    "`**\nIdentifier**`" ..
                    Identifier ..
                    "` \n**Discord:** <@" ..
                    discordId ..
                    ">**\nIP: **`" ..
                    ip ..
                    "`\n**PlayerId:** `" ..
                    target .. "` \n **Type** `" .. montype .. "` \n**Quantity** `" .. quantity .. "`"

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
        local ace = IsPlayerAceAllowed(_source, 'vorpcore.additems.Command')
        local message = "**Steam name: **`" ..
            steamName ..
            "`**\nIdentifier**`" ..
            Identifier ..
            "` \n**Discord:** <@" ..
            discordId ..
            ">**\nIP: **`" ..
            ip .. "`\n **PlayerId** `" .. id .. "` \n**Item given** `" .. item .. "` \n **Count**`" .. count .. "`"

        if args then
            if ace or user.group == Config.Group.Admin or
                user.group == Config.Group.Mod then
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
        local ace = IsPlayerAceAllowed(_source, 'vorpcore.addweapons.Command')
        local message = "**Steam name: **`" ..
            steamName ..
            "`**\nIdentifier**`" ..
            Identifier ..
            "` \n**Discord:** <@" ..
            discordId ..
            ">**\nIP: **`" .. ip .. "`\n **PlayerId** `" .. id .. "` \n**Weapon given** `" .. weaponHash .. "`"

        if args then
            TriggerEvent("vorpCore:canCarryWeapons", tonumber(id), 1, function(canCarry)
                if canCarry then
                    if ace or user.group == Config.Group.Admin or
                        user.group == Config.Group.Mod then
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
        local ace = IsPlayerAceAllowed(_source, 'vorpcore.reviveplayer.Command')
        local message = "**Steam name: **`" ..
            steamName ..
            "`**\nIdentifier**`" ..
            Identifier ..
            "` \n**Discord:** <@" ..
            discordId .. ">**\nIP: **`" .. ip .. "`\n **PlayerId** `" .. id .. "`\n **Action:** `" .. text .. "`"

        if args then
            print("revive pass")
            if ace or user.group == Config.Group.Admin or
                user.group == Config.Group.Mod then

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
        local ace = IsPlayerAceAllowed(_source, 'vorpcore.tpm.Command')
        local message = "**Steam name: **`" ..
            steamName ..
            "`**\nIdentifier**`" ..
            Identifier ..
            "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `" .. text .. "`"

        if ace or user.group == Config.Group.Admin or
            user.group == Config.Group.Mod then
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
        local ace
        IsPlayerAceAllowed(_source, 'vorpcore.delwagons.Command')
        local message = "**Steam name: **`" ..
            steamName ..
            "`**\nIdentifier**`" ..
            Identifier ..
            "` \n**Discord:** <@" ..
            discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `" .. text .. "` \n **Radius:** `" .. radius .. "`"

        if radius then

            if ace or user.group == Config.Group.Admin or
                user.group == Config.Group.Mod then

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
        local ace = IsPlayerAceAllowed(_source, 'vorpcore.delhorse.Command')
        local message = "**Steam name: **`" ..
            steamName ..
            "`**\nIdentifier**`" ..
            Identifier ..
            "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip .. "`\n **Action:** `" .. text .. "`"
        if ace or user.group == Config.Group.Admin or
            user.group == Config.Group.Mod then
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
        local ace = IsPlayerAceAllowed(_source, 'vorpcore.healplayer.Command')
        local message = "**Steam name: **`" ..
            steamName ..
            "`**\nIdentifier**`" ..
            Identifier ..
            "` \n**Discord:** <@" ..
            discordId .. ">**\nIP: **`" .. ip .. "` \n **PlayerId:** `" .. playerId .. "`\n **Action:** `" .. text .. "`"
        if args then
            if ace or user.group == Config.Group.Admin or
                user.group == Config.Group.Mod then
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
            local ip = GetPlayerEndpoint(_source)
            local steamName = GetPlayerName(_source)
            local text = "Was whitelisted"
            local ace = IsPlayerAceAllowed(_source, 'vorpcore.wlplayer.Command')
            local message = "**Steam name: **`" ..
                steamName ..
                "`**\nIdentifier**`" ..
                Identifier ..
                "` \n**Discord:** <@" ..
                discordId ..
                ">**\nIP: **`" .. ip .. "` \n **User-Id:** `" .. target .. "`\n **Action:** `" .. text .. "`"
            if args then
                if ace or user.group == Config.Group.Admin or
                    user.group == Config.Group.Mod then
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
            local ip = GetPlayerEndpoint(_source)
            local text = "Was unwhitelisted"
            local ace = IsPlayerAceAllowed(_source, 'vorpcore.unwlplayer.Command')
            local message = "**Steam name: **`" ..
                steamName ..
                "`**\nIdentifier**`" ..
                Identifier ..
                "` \n**Discord:** <@" ..
                discordId ..
                ">**\nIP: **`" .. ip .. "` \n **User-Id:** `" .. target .. "`\n **Action:** `" .. text .. "`"
            if args then
                if ace or user.group == Config.Group.Admin or
                    user.group == Config.Group.Mod then
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
--------------------------------------- BANS - WARNS ----------------------------------------------------
RegisterCommand("ban", function(source, args, rawCommand)
    local _source = source
    TriggerEvent("vorp:getCharacter", _source, function(user)
        local target = tonumber(args[1])
        local datetime = os.time(os.date("!*t"))
        local banTime
        local text
        if args[2]:sub(-1) == 'd' then
            banTime = tonumber(args[2]:sub(1, -2))
            banTime = banTime * 24
        elseif args[2]:sub(-1) == 'w' then
            banTime = tonumber(args[2]:sub(1, -2))
            banTime = banTime * 168
        elseif args[2]:sub(-1) == 'm' then
            banTime = tonumber(args[2]:sub(1, -2))
            banTime = banTime * 720
        elseif args[2]:sub(-1) == 'y' then
            banTime = tonumber(args[2]:sub(1, -2))
            banTime = banTime * 8760
        else
            banTime = tonumber(args[2])
        end
        if banTime == 0 then
            datetime = 0
            text = "Was banned permanently"
        else
            datetime = datetime + banTime * 3600
            text = "Was banned until " ..
                os.date(Config.Langs["DateTimeFormat"], datetime + Config.TimeZoneDifference * 3600) ..
                Config.Langs["TimeZone"]
        end
        local Identifier = GetPlayerIdentifier(_source)
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId = string.sub(discordIdentity, 9)
        local ip = GetPlayerEndpoint(_source)
        local steamName = GetPlayerName(_source)
        local ace = IsPlayerAceAllowed(_source, 'vorpcore.ban.Command')
        local message = "**Steam name: **`" ..
            steamName ..
            "`**\nIdentifier**`" ..
            Identifier ..
            "` \n**Discord:** <@" ..
            discordId .. ">**\nIP: **`" .. ip .. "` \n **User-Id:** `" .. target .. "`\n **Action:** `" .. text .. "`"
        if args then
            if ace or user.group == Config.Group.Admin or user.group == Config.Group.Mod then
                TriggerEvent("vorp:banWarnWebhook", "📋` /ban command` ", message, color)
                TriggerClientEvent("vorp:ban", _source, target, datetime)
            else
                TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000)
            end
        end

    end)
end)

RegisterCommand("unban", function(source, args, rawCommand)
    local _source = source
    TriggerEvent("vorp:getCharacter", _source, function(user)
        local target = tonumber(args[1])
        local Identifier = GetPlayerIdentifier(_source)
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId = string.sub(discordIdentity, 9)
        local steamName = GetPlayerName(_source)
        local ip = GetPlayerEndpoint(_source)
        local text = "Was unbanned"
        local ace = IsPlayerAceAllowed(_source, 'vorpcore.unban.Command')
        local message = "**Steam name: **`" ..
            steamName ..
            "`**\nIdentifier**`" ..
            Identifier ..
            "` \n**Discord:** <@" ..
            discordId .. ">**\nIP: **`" .. ip .. "` \n **User-Id:** `" .. target .. "`\n **Action:** `" .. text .. "`"
        if args then
            if ace or user.group == Config.Group.Admin or user.group == Config.Group.Mod then
                TriggerEvent("vorp:banWarnWebhook", "📋` /unban command` ", message, color)
                TriggerClientEvent("vorp:unban", _source, target)
            else
                TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000)
            end
        end

    end)
end)

RegisterCommand("warn", function(source, args, rawCommand)
    local _source = source
    TriggerEvent("vorp:getCharacter", _source, function(user)
        local target = tonumber(args[1])
        local Identifier = GetPlayerIdentifier(_source)
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId = string.sub(discordIdentity, 9)
        local ip = GetPlayerEndpoint(_source)
        local steamName = GetPlayerName(_source)
        local text = "Was warned"
        local ace = IsPlayerAceAllowed(_source, 'vorpcore.warn.Command')
        local message = "**Steam name: **`" ..
            steamName ..
            "`**\nIdentifier**`" ..
            Identifier ..
            "` \n**Discord:** <@" ..
            discordId .. ">**\nIP: **`" .. ip .. "` \n **User-Id:** `" .. target .. "`\n **Action:** `" .. text .. "`"
        if args then
            if ace or user.group == Config.Group.Admin or user.group == Config.Group.Mod then
                TriggerEvent("vorp:banWarnWebhook", "📋` /warn command` ", message, color)
                TriggerClientEvent("vorp:warn", _source, target)
            else
                TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000)
            end
        end

    end)
end)

RegisterCommand("unwarn", function(source, args, rawCommand)
    local _source = source
    TriggerEvent("vorp:getCharacter", _source, function(user)
        local target = tonumber(args[1])
        local Identifier = GetPlayerIdentifier(_source)
        local discordIdentity = GetIdentity(_source, "discord")
        local discordId = string.sub(discordIdentity, 9)
        local steamName = GetPlayerName(_source)
        local ip = GetPlayerEndpoint(_source)
        local text = "Was unwarned"
        local ace = IsPlayerAceAllowed(_source, 'vorpcore.unwarn.Command')
        local message = "**Steam name: **`" ..
            steamName ..
            "`**\nIdentifier**`" ..
            Identifier ..
            "` \n**Discord:** <@" ..
            discordId .. ">**\nIP: **`" .. ip .. "` \n **User-Id:** `" .. target .. "`\n **Action:** `" .. text .. "`"
        if args then
            if ace or user.group == Config.Group.Admin or user.group == Config.Group.Mod then
                TriggerEvent("vorp:banWarnWebhook", "📋` /unwarn command` ", message, color)
                TriggerClientEvent("vorp:unwarn", _source, target)
            else
                TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000)
            end
        end

    end)
end)


---------------------------------------------------------------------------------------------------------
----------------------------------- CHAT ADD SUGGESTION --------------------------------------------------

-- TRANSLATE HERE
-- TODO ADD TO CONFIG


RegisterServerEvent("vorp:chatSuggestion")
AddEventHandler("vorp:chatSuggestion", function()
    local _source = source

    TriggerEvent("vorp:getCharacter", _source, function(user)

        if user.group == Config.Group.Admin or user.group == Config.Group.Mod then
            TriggerClientEvent("chat:addSuggestion", _source, "/setgroup", "VORPcore command set group to user.", {
                { name = "Id", help = 'player ID' },
                { name = "Group", help = 'Group Name' },

            })

            TriggerClientEvent("chat:addSuggestion", _source, "/setjob", "VORPcore command set job to user.", {
                { name = "Id", help = 'player ID' },
                { name = "Job", help = 'Job Name' },
                { name = "Rank", help = ' player Rank' },
            })

            TriggerClientEvent("chat:addSuggestion", _source, "/addmoney", "VORPcore command add money/gold to user",
                {
                    { name = "Id", help = 'player ID' },
                    { name = "Type", help = 'Money 0 Gold 1' },
                    { name = "Quantity", help = 'Quantity to give' },
                })

            TriggerClientEvent("chat:addSuggestion", _source, "/delcurrency",
                "VORPcore command remove money/gold from user", {
                { name = "Id", help = 'player ID' },
                { name = "Type", help = 'Money 0 Gold 1' },
                { name = "Quantity", help = 'Quantity to remove from User' },
            })

            TriggerClientEvent("chat:addSuggestion", _source, "/addwhitelist",
                "VORPcore command Example: /addwhitelist 11000010c8aa16e", {
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

            TriggerClientEvent("chat:addSuggestion", _source, "/tpm",
                " VORPcore command  teleport to marker set on the map.", {
            })

            TriggerClientEvent("chat:addSuggestion", _source, "/delwagons",
                " VORPcore command to delete wagons within radius.", {
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

            TriggerClientEvent("chat:addSuggestion", _source, "/wlplayer",
                " VORPcore command to add players to whitelist.", {
                { name = "Id", help = 'player ID from Discord user-id' },
            })

            TriggerClientEvent("chat:addSuggestion", _source, "/unwlplayer",
                " VORPcore command to remove players from whitelist.", {
                { name = "Id", help = 'player ID from Discord user-id' },
            })

            TriggerClientEvent("chat:addSuggestion", _source, "/ban", " VORPcore command to ban players.", {
                { name = "Id", help = 'player ID from Discord user-id' },
                { name = "Time", help = 'Time of ban' },
            })

            TriggerClientEvent("chat:addSuggestion", _source, "/unban", " VORPcore command to unban players.", {
                { name = "Id", help = 'player ID from Discord user-id' },
            })

            TriggerClientEvent("chat:addSuggestion", _source, "/warn", " VORPcore command to warn players.", {
                { name = "Id", help = 'player ID from Discord user-id' },
            })

            TriggerClientEvent("chat:addSuggestion", _source, "/unwarn", " VORPcore command to unwarn players.", {
                { name = "Id", help = 'player ID from Discord user-id' },
            })
        else
            TriggerClientEvent("chat:removeSuggestion", _source, "/setgroup")

            TriggerClientEvent("chat:removeSuggestion", _source, "/setjob")

            TriggerClientEvent("chat:removeSuggestion", _source, "/addmoney")

            TriggerClientEvent("chat:removeSuggestion", _source, "/delcurrency")

            TriggerClientEvent("chat:removeSuggestion", _source, "/addwhitelist")

            TriggerClientEvent("chat:removeSuggestion", _source, "/additems")

            TriggerClientEvent("chat:removeSuggestion", _source, "/reviveplayer")

            TriggerClientEvent("chat:removeSuggestion", _source, "/tpm")

            TriggerClientEvent("chat:removeSuggestion", _source, "/delwagons")

            TriggerClientEvent("chat:removeSuggestion", _source, "/delhorse")

            TriggerClientEvent("chat:removeSuggestion", _source, "/addweapons")

            TriggerClientEvent("chat:removeSuggestion", _source, "/healplayer")

            TriggerClientEvent("chat:removeSuggestion", _source, "/wlplayer")

            TriggerClientEvent("chat:removeSuggestion", _source, "/unwlplayer")

            TriggerClientEvent("chat:removeSuggestion", _source, "/ban")

            TriggerClientEvent("chat:removeSuggestion", _source, "/unban")

            TriggerClientEvent("chat:removeSuggestion", _source, "/warn")

            TriggerClientEvent("chat:removeSuggestion", _source, "/unwarn")
        end
    end)

end)
