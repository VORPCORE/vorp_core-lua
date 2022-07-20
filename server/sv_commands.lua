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
            if Config.Logs.SetgroupWebhook then
                local title = "📋` /Group command` "
                TriggerEvent("vorp_core:addWebhook", title, Config.Logs.SetgroupWebhook, message)
            end
            TriggerEvent("vorp:setGroup", target, newgroup)
            TriggerClientEvent("vorp:Tip", _source, string.format("Player %s have group %s", target, newgroup), 4000)

        else
            TriggerClientEvent("vorp:Tip", _source, Config.Langs.NoPermissions, 4000)
        end
    end)

end, false)


---------------------------------------------------------------------------------------------------
------------------------------------------ SETJOB  ------------------------------------------------
RegisterCommand("setjob", function(source, args, rawCommand)

    local _source = source
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
            if Config.Logs.SetjobWebhook then
                local title = "📋` /Job command` "
                TriggerEvent("vorp_core:addWebhook", title, Config.Logs.SetjobWebhook, message)
            end
        else
            TriggerClientEvent("vorp:Tip", _source, Config.Langs.NoPermissions, 4000)
        end
    end)
end, false)



---------------------------------------------------------------------------------------------------
------------------------------------------ ADDCASH/GOLD ------------------------------------------------
RegisterCommand("addmoney", function(source, args, rawCommand)
    local _source = source
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
            if Config.Logs.AddmoneyWebhook then
                local title = "📋` /Addmoney command` "
                TriggerEvent("vorp_core:addWebhook", title, Config.Logs.AddmoneyWebhook, message)
            end
        else
            TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000)
        end
    end)

end, false)


---------------------------------------------------------------------------------------------------
------------------------------------------ DELLMONEY ------------------------------------------------
RegisterCommand("delcurrency", function(source, args, rawCommand)
    local _source = source
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
            TriggerEvent("vorp:removeMoney", target, montype, quantity)

            TriggerClientEvent("vorp:Tip", _source, string.format("Removed %s to %s", target, quantity), 4000)

            if Config.Logs.DelMoneyWebhook then
                local title = "📋` /delcurrency command` "
                TriggerEvent("vorp_core:addWebhook", title, Config.Logs.DelMoneyWebhook, message)
            end

        else
            TriggerClientEvent("vorp:Tip", _source, Config.Langs.NoPermissions, 4000)
        end
    end)


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

            local itemCheck = VORP.getDBItem(id, item) --check items exist in DB
            if itemCheck then
                local canCarry = VORP.canCarryItems(id, count) --can carry inv space
                local canCarry2 = VORP.canCarryItem(id, item, count) --cancarry item limit
                --local itemLabel = itemCheck.label
                if canCarry then
                    if canCarry2 then
                        if ace or user.group == Config.Group.Admin or user.group == Config.Group.Mod then

                            VORP.addItem(id, item, count)
                            if Config.Logs.AddItemsWebhook then
                                local title = "📋` /additems command` "
                                TriggerEvent("vorp_core:addWebhook", title, Config.Logs.AddItemsWebhook, message)
                            end
                        else
                            TriggerClientEvent("vorp:Tip", _source, Config.Langs.NoPermissions, 4000)
                        end
                    else
                        TriggerClientEvent("vorp:Tip", _source, "cant carry more items", 4000)
                    end
                else
                    TriggerClientEvent("vorp:Tip", _source, "inventory is full", 4000)
                end
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
            VORP.canCarryWeapons(id, 1, function(cb) --can carry weapons
                local canCarry = cb
                if canCarry then
                    if ace or user.group == Config.Group.Admin or user.group == Config.Group.Mod then
                        VORP.createWeapon(tonumber(id), weaponHash)

                        if Config.Logs.AddWeaponsWebhook then
                            local title = "📋` /addweapons command` "
                            TriggerEvent("vorp_core:addWebhook", title, Config.Logs.AddWeaponsWebhook, message)
                        end
                    else
                        TriggerClientEvent("vorp:Tip", _source, Config.Langs.NoPermissions, 4000)
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
            if ace or user.group == Config.Group.Admin or user.group == Config.Group.Mod then


                TriggerClientEvent('vorp:resurrectPlayer', id)

                if Config.Logs.ReviveWebhook then
                    local title = "📋` /revive command` "
                    TriggerEvent("vorp_core:addWebhook", title, Config.Logs.ReviveWebhook, message)
                end

            else
                TriggerClientEvent("vorp:Tip", _source, Config.Langs.NoPermissions, 4000)
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

        if ace or user.group == Config.Group.Admin or user.group == Config.Group.Mod then
            TriggerClientEvent('vorp:teleportWayPoint', _source)

            if Config.Logs.TpmWebhook then
                local title = "📋` /Tpm command` "
                TriggerEvent("vorp_core:addWebhook", title, Config.Logs.TpmWebhook, message)
            end
        else
            TriggerClientEvent("vorp:Tip", _source, Config.Langs.NoPermissions, 4000)
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

            if ace or user.group == Config.Group.Admin or user.group == Config.Group.Mod then

                if radius >= 1 then
                    TriggerClientEvent("vorp:deleteVehicle", _source, radius)

                    if Config.Logs.DelWagonsWebhook then
                        local title = "📋` /delwagons command` "
                        TriggerEvent("vorp_core:addWebhook", title, Config.Logs.DelWagonsWebhook, message)
                    end
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

        if ace or user.group == Config.Group.Admin or user.group == Config.Group.Mod then
            TriggerClientEvent("vorp:delHorse", _source)


            if Config.Logs.DelHorseWebhook then
                local title = "📋` /delhorse command` "
                TriggerEvent("vorp_core:addWebhook", title, Config.Logs.DelHorseWebhook, message)
            end

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

                if Config.Logs.DelHorseWebhook then
                    local title = "📋` /healplayer command` "
                    TriggerEvent("vorp_core:addWebhook", title, Config.Logs.DelHorseWebhook, message)
                end

            else
                TriggerClientEvent("vorp:Tip", _source, Config.Langs.NoPermissions, 4000)
            end
        end
    end)

end, false)

---------------------------------------------------------------------------------------------------------
----------------------------------- WHITELIST ACTIONS =--------------------------------------------------

RegisterCommand("wlplayer", function(source, args, rawCommand)
    local _source = source

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
            if ace or user.group == Config.Group.Admin or user.group == Config.Group.Mod then

                TriggerEvent("vorp:whitelistPlayer", target)

                if Config.Logs.WhitelistWebhook then
                    local title = "📋` /wlplayer command` "
                    TriggerEvent("vorp_core:addWebhook", title, Config.Logs.WhitelistWebhook, message)
                end
            else
                TriggerClientEvent("vorp:Tip", _source, Config.Langs.NoPermissions, 4000)
            end
        end

    end)
end)


RegisterCommand("unwlplayer", function(source, args, rawCommand)
    local _source = source

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
            if ace or user.group == Config.Group.Admin or user.group == Config.Group.Mod then

                TriggerEvent("vorp:unwhitelistPlayer", target)
                if Config.Logs.WhitelistWebhook then
                    local title = "📋` /unwlplayer command` "
                    TriggerEvent("vorp_core:addWebhook", title, Config.Logs.WhitelistWebhook, message)
                end
            else
                TriggerClientEvent("vorp:Tip", _source, Config.Langs.NoPermissions, 4000)
            end
        end

    end)

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
        elseif args[2]:sub(-1) == 'h' then
            banTime = tonumber(args[2]:sub(1, -2))
        elseif tonumber(args[2]) then
            banTime = tonumber(args[2])
        else
            banTime = nil
        end
        if banTime == 0 then
            datetime = 0
            text = "Was banned permanently"
        elseif banTime then
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
        if args and banTime then
            if ace or user.group == Config.Group.Admin or user.group == Config.Group.Mod then

                TriggerClientEvent("vorp:ban", _source, target, datetime)

                if Config.Logs.BanWarnWebhook then
                    local title = "📋` /ban command` "
                    TriggerEvent("vorp_core:addWebhook", title, Config.Logs.BanWarnWebhook, message)
                end
            else
                TriggerClientEvent("vorp:Tip", _source, Config.Langs.NoPermissions, 4000)
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

                if Config.Logs.BanWarnWebhook then
                    local title = "📋` /unban command` "
                    TriggerEvent("vorp_core:addWebhook", title, Config.Logs.BanWarnWebhook, message)
                end
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

                TriggerClientEvent("vorp:warn", _source, target)
                if Config.Logs.BanWarnWebhook then
                    local title = "📋` /warn command` "
                    TriggerEvent("vorp_core:addWebhook", title, Config.Logs.BanWarnWebhook, message)
                end
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

                TriggerClientEvent("vorp:unwarn", _source, target)
                if Config.Logs.BanWarnWebhook then
                    local title = "📋` /unwarn command` "
                    TriggerEvent("vorp_core:addWebhook", title, Config.Logs.BanWarnWebhook, message)
                end
            else
                TriggerClientEvent("vorp:Tip", _source, Config.Langs["NoPermissions"], 4000)
            end
        end

    end)
end)

if Config.UseCharPermission then
    RegisterCommand("addchar", function(source, args, rawCommand)
        local _source = source
        TriggerEvent("vorp:getCharacter", _source, function(user)
            local target = args[1]
            local Identifier = GetPlayerIdentifier(_source)
            local discordIdentity = GetIdentity(_source, "discord")
            local discordId = string.sub(discordIdentity, 9)
            local steamName = GetPlayerName(_source)
            local ip = GetPlayerEndpoint(_source)
            local text = "Had the multicharacter"
            local ace = IsPlayerAceAllowed(_source, 'vorpcore.addchar.Command')
            local message = "**Steam name: **`" ..
                steamName ..
                "`**\nIdentifier**`" ..
                Identifier ..
                "` \n**Discord:** <@" ..
                discordId ..
                ">**\nIP: **`" .. ip .. "` \n **User-Id:** `" .. target .. "`\n **Action:** `" .. text .. "`"
            if args then
                if ace or user.group == Config.Group.Admin or user.group == Config.Group.Mod then

                    TriggerClientEvent("vorp:addchar", _source, target)
                    TriggerClientEvent("vorp:Tip", _source, Config.Langs.AddChar .. target, 4000)

                    if Config.Logs.CharPermWebhook then
                        local title = "📋` /addchar command` "
                        TriggerEvent("vorp_core:addWebhook", title, Config.Logs.CharPermWebhook, message)
                    end
                else
                    TriggerClientEvent("vorp:Tip", _source, Config.Langs.NoPermissions, 4000)
                end
            end
        end)
    end)

    RegisterCommand("removechar", function(source, args, rawCommand)
        local _source = source
        TriggerEvent("vorp:getCharacter", _source, function(user)
            local target = args[1]
            local Identifier = GetPlayerIdentifier(_source)
            local discordIdentity = GetIdentity(_source, "discord")
            local discordId = string.sub(discordIdentity, 9)
            local steamName = GetPlayerName(_source)
            local ip = GetPlayerEndpoint(_source)
            local text = "Has lost the multicharacter"
            local ace = IsPlayerAceAllowed(_source, 'vorpcore.removechar.Command')
            local message = "**Steam name: **`" ..
                steamName ..
                "`**\nIdentifier**`" ..
                Identifier ..
                "` \n**Discord:** <@" ..
                discordId ..
                ">**\nIP: **`" .. ip .. "` \n **User-Id:** `" .. target .. "`\n **Action:** `" .. text .. "`"
            if args then
                if ace or user.group == Config.Group.Admin or user.group == Config.Group.Mod then

                    TriggerClientEvent("vorp:removechar", _source, target)
                    TriggerClientEvent("vorp:Tip", _source, Config.Langs.RemoveChar .. target, 4000)

                    if Config.Logs.CharPermWebhook then
                        local title = "📋` /removechar command` "
                        TriggerEvent("vorp_core:addWebhook", title, Config.Logs.CharPermWebhook, message)
                    end
                else
                    TriggerClientEvent("vorp:Tip", _source, Config.Langs.NoPermissions, 4000)
                end
            end
        end)
    end)
end


RegisterCommand("myjob", function(source, args, rawCommand)
      local _source = source
      TriggerEvent("vorp:getCharacter", _source, function(user)
          local job = user.job
          local grade  = user.jobGrade 
          TriggerClientEvent("vorp:TipRight", _source, "your job is: ~o~" .. job .. " ~q~grade: ~o~" .. grade, 4000, 2000)
      end)
  
end)


RegisterCommand("myhours", function(source, args, rawCommand)
    local _source = source
    local function isInteger(num)
        if math.floor(num) == num then
            return true
        end
        return false
    end
    TriggerEvent("vorp:getCharacter", _source, function(user)
        local hours = user.hours
         if isInteger(hours) then
        TriggerClientEvent("vorp:TipRight", _source, "your character hours is: ~o~" .. hours, 4000, 2000)
         else
            local newhour = math.floor(hours-0.5)
            TriggerClientEvent("vorp:TipRight", _source, "hours played is: ~o~" .. newhour ..":30", 4000, 2000)
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
    local ace = IsPlayerAceAllowed(_source, 'vorpcore.showAllCommands')
    TriggerEvent("vorp:getCharacter", _source, function(user)

        if ace or user.group == Config.Group.Admin or user.group == Config.Group.Mod then
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
                { name = "Time", help = 'Time of ban: <length>[h/d/w/m/y]' },
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

            if Config.UseCharPermission then
                TriggerClientEvent("chat:addSuggestion", _source, "/addchar",
                    " VORPcore command to add multicharacter to players.", {
                    { name = "Steam Hex", help = 'steam:110000101010010' },
                })

                TriggerClientEvent("chat:addSuggestion", _source, "/removechar",
                    " VORPcore command to remove multicharacter to players.", {
                    { name = "Steam Hex", help = 'steam:110000101010010' },
                })
            end
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

            TriggerClientEvent("chat:removeSuggestion", _source, "/addchar")

            TriggerClientEvent("chat:removeSuggestion", _source, "/removechar")


        end
        TriggerClientEvent("chat:addSuggestion", _source, "/myhours", " VORPcore command to see ur hours.", {})
        TriggerClientEvent("chat:addSuggestion", _source, "/myjob", " VORPcore command to see ur job.", {})
    end)

end)
