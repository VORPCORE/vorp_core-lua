-------------------------------------------------------------------------------------------------
--------------------------------------- VORP ADMIN COMMANDS -------------------------------------
-------------------------------------------------------------------------------------------------



---comment
---@param Table table
---@param Group string
---@return boolean
local CheckGroupAllowed = function(Table, Group)
    for _, value in pairs(Table) do
        if value == Group then
            return true
        end
    end
    return false
end

---check if player is ace allowed
---@param Table table
---@param _source any
---@return boolean
local CheckAceAllowed = function(Table, _source)
    for _, value in pairs(Table) do
        local aceAllowed = IsPlayerAceAllowed(_source, value)
        if aceAllowed then
            return true
        end
    end
    return false
end
local WhitelistCommands = { "delwagons", "delhorse", "tpm", }
--- check if player exists
---@param target number
---@param _source number
---@param command string
---@return boolean
local CheckUser = function(target, _source, command)
    for _, value in pairs(WhitelistCommands) do
        if value == command then
            return true
        end
    end

    if VorpCore.getUser(tonumber(target)) then
        return true
    else
        VorpCore.NotifyObjective(_source, "ID is wrong user doesnt exist", 4000)
        return false
    end

end

---comment
---@param args table
---@param _source number
---@param requiered number
local CheckArgs = function(args, _source, requiered)
    if #args == requiered then
        return false
    end
    VorpCore.NotifyObjective(_source, "Please read the suggestions on how to use the command", 4000)
    return true
end


Config.AcePerms = { 'vorpcore.setGroup.Command', 'vorpcore.setJob.Command', 'vorpcore.delCurrency.Command',
    'vorpcore.addweapons.Command', 'vorpcore.additems.Command', 'vorpcore.reviveplayer.Command', 'vorpcore.tpm.Command',
    'vorpcore.delwagons.Command', 'vorpcore.delhorse.Command', 'vorpcore.healplayer.Command', 'vorpcore.wlplayer.Command',
    'vorpcore.unwlplayer.Command', 'vorpcore.ban.Command', 'vorpcore.unban.Command', 'vorpcore.warn.Command',
    'vorpcore.unwarn.Command', 'vorpcore.addchar.Command', 'vorpcore.removechar.Command', 'vorpcore.showAllCommands',
    'vorpcore.changeCharName' }

CreateThread(function()

    for _, CurrentCommand in pairs(Config.Commands) do
        RegisterCommand(CurrentCommand, function(source, args, rawCommand)

            local _source = source
            local User = VorpCore.getUser(_source)
            local Character = User.getUsedCharacter
            local group = User.group -- User DB table group
            local Identifier = GetPlayerIdentifier(_source)
            local discordIdentity = GetIdentity(_source, "discord")
            local discordId = string.sub(discordIdentity, 9)
            local ip = GetPlayerEndpoint(_source)
            local steamName = GetPlayerName(_source)
            local message = "**Steam name: **`" .. steamName .. "`**\nIdentifier**`" .. Identifier ..
                "` \n**Discord:** <@" .. discordId .. ">**\nIP: **`" .. ip

            if _source ~= 0 then -- its a player
                if CurrentCommand ~= "reviveplayer" and CurrentCommand ~= "healplayer" then
                    if not CheckUser(args[1], _source, CurrentCommand) then -- if user dont exist
                        return
                    end
                end

                if CheckAceAllowed(Config.AcePerms, _source) or CheckGroupAllowed(Config.GroupAllowed, group) then -- check ace first then group
                    if CurrentCommand == "addGroup" then
                        local target, newgroup = tonumber(args[1]), tostring(args[2])
                        local UserT = VorpCore.getUser(target)
                        local CharacterT = UserT.getUsedCharacter

                        if CheckArgs(args, _source, 2) then -- if requiered argsuments are not met
                            return
                        end
                        if Config.SetUserDBadmin then
                            UserT.setGroup(newgroup)
                        else
                            CharacterT.setGroup(newgroup)
                        end
                        VorpCore.NotifyRightTip(_source, "You gave Group to ID: " .. target, 4000)
                        VorpCore.NotifyRightTip(_source, "Admin gave you Group of " .. newgroup, 4000)

                        if Config.Logs.SetgroupWebhook then
                            local Message = "`\n**PlayerID** `" .. _source .. "` \n**Group given** `" .. newgroup .. "`"
                            local title = "📋` /Group command` "
                            VorpCore.AddWebhook(title, Config.Logs.SetgroupWebhook, message .. Message)
                        end
                    elseif CurrentCommand == "addJob" then
                        local target, newjob, jobgrade = tonumber(args[1]), tostring(args[2]), tonumber(args[3])
                        local UserT = VorpCore.getUser(target)
                        local CharacterT = UserT.getUsedCharacter

                        if CheckArgs(args, _source, 3) then
                            return
                        end

                        CharacterT.setJob(newjob)
                        CharacterT.setJobGrade(jobgrade)
                        VorpCore.NotifyRightTip(_source,
                            "you gave  Job " .. newjob .. " to ID " .. target .. " Grade" .. jobgrade, 4000)
                        VorpCore.NotifyRightTip(target, "staff gave you job " .. newjob .. " Grade " .. jobgrade, 4000)

                        if Config.Logs.SetjobWebhook then
                            local Message = "`\n**PlayerID** `" ..
                                _source .. "` \n**Job given** `" .. newjob .. "`\n **Grade:** `" .. jobgrade .. "`"
                            local title = "📋` /Job command` "
                            VorpCore.AddWebhook(title, Config.Logs.SetjobWebhook, message .. Message)
                        end

                    elseif CurrentCommand == "addMoney" then
                        local target, montype, quantity = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
                        local UserT = VorpCore.getUser(target)
                        local CharacterT = UserT.getUsedCharacter
                        if CheckArgs(args, _source, 3) then
                            return
                        end

                        CharacterT.addCurrency(montype, quantity)
                        VorpCore.NotifyRightTip(_source, "You gave currency " .. quantity .. " to ID " .. target, 4000)
                        VorpCore.NotifyRightTip(target, "Received from admin an Amount of" .. quantity, 4000)

                        if Config.Logs.AddmoneyWebhook then
                            local Message = "`\n**PlayerID** `" ..
                                _source .. "` \n **Type** `" .. montype .. "` \n**Quantity** `" .. quantity .. "`"
                            local title = "📋` /Addmoney command` "
                            VorpCore.AddWebhook(title, Config.Logs.AddmoneyWebhook, message .. Message)
                        end

                    elseif CurrentCommand == "addItems" then
                        local target, item, count = tonumber(args[1]), tostring(args[2]), tonumber(args[3])

                        local VORPInv = exports.vorp_inventory:vorp_inventoryApi()
                        local itemCheck = VORPInv.getDBItem(target, item)
                        local canCarry = VORPInv.canCarryItems(target, count) --can carry inv space
                        local canCarry2 = VORPInv.canCarryItem(target, item, count) --cancarry item limit

                        if CheckArgs(args, _source, 3) then
                            return
                        end

                        if itemCheck then
                            if canCarry then
                                if canCarry2 then
                                    VORPInv.addItem(target, item, count)
                                    if Config.Logs.AddItemsWebhook then
                                        local Message = "`\n**PlayerID** `" ..
                                            _source ..
                                            "` \n**Item given** `" .. item .. "` \n **Count**`" .. count .. "`"
                                        local title = "📋` /additems command` "
                                        VorpCore.AddWebhook(title, Config.Logs.AddItemsWebhook,
                                            message .. Message)
                                    end
                                else
                                    VorpCore.NotifyObjective(_source, "cant carry more of this item", 4000)
                                end
                            else
                                VorpCore.NotifyObjective(_source, "inventory is full", 4000)
                            end
                        end

                    elseif CurrentCommand == "addWeapons" then
                        local target = tonumber(args[1])
                        local weaponHash = tostring(args[2])
                        local VORPInv = exports.vorp_inventory:vorp_inventoryApi()
                        if CheckArgs(args, _source, 2) then
                            return
                        end

                        VORPInv.canCarryWeapons(target, 1, function(cb) --can carry weapons
                            local canCarry = cb


                            if canCarry then
                                VORPInv.createWeapon(target, weaponHash)
                                if Config.Logs.AddWeaponsWebhook then
                                    local Message = "`\n**PlayerID** `" ..
                                        _source .. "` \n**Weapon given** `" .. weaponHash .. "`"
                                    local title = "📋` /addweapons command` "
                                    VorpCore.AddWebhook(title, Config.Logs.AddWeaponsWebhook, message, Message)
                                end
                            else
                                VorpCore.NotifyObjective(_source, Config.Langs.cantCarry, 4000)
                            end
                        end)

                    elseif CurrentCommand == "delMoney" then
                        local target, montype, quantity = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
                        local UserT = VorpCore.getUser(target)
                        local CharacterT = UserT.getUsedCharacter
                        if CheckArgs(args, _source, 3) then
                            return
                        end

                        CharacterT.removeCurrency(montype, quantity)
                        VorpCore.NotifyRightTip(_source, "You have removed " .. quantity .. " from ID " .. target, 4000)

                        if Config.Logs.DelMoneyWebhook then
                            local Message = "`\n**PlayerID** `" ..
                                _source .. "` \n **Type** `" .. montype .. "` \n**Quantity** `" .. quantity .. "`"
                            local title = "📋` /delcurrency command` "
                            VorpCore.AddWebhook(title, Config.Logs.DelMoneyWebhook, message .. Message)
                        end
                    elseif CurrentCommand == "reviveplayer" then
                        local target = tonumber(args[1])

                        if #args == 0 or target == _source then
                            TriggerClientEvent('vorp:resurrectPlayer', _source) -- heal staff
                        else
                            if VorpCore.getUser(target) then
                                TriggerClientEvent('vorp:resurrectPlayer', target) -- heal target
                            else
                                VorpCore.NotifyObjective(_source, "ID is wrong user doesnt exist", 4000)
                            end
                        end
                        if Config.Logs.ReviveWebhook then
                            local Message = "`\n**PlayerID** `" .. _source .. "`\n **Action:** `Was Revived `"
                            local title = "📋` /revive command` "
                            VorpCore.AddWebhook(title, Config.Logs.ReviveWebhook, message .. Message)
                        end

                    elseif CurrentCommand == "tpm" then
                        if CheckArgs(args, _source, 0) then
                            return
                        end
                        TriggerClientEvent('vorp:teleportWayPoint', _source)

                        if Config.Logs.TpmWebhook then
                            local Message = "`\n**PlayerID** `" .. _source .. "`\n **Action:** `Used TPM`"
                            local title = "📋` /Tpm command` "
                            VorpCore.AddWebhook(title, Config.Logs.TpmWebhook, message .. Message)
                        end

                    elseif CurrentCommand == "delhorse" then
                        if CheckArgs(args, _source, 0) then
                            return
                        end
                        TriggerClientEvent("vorp:delHorse", _source)

                        if Config.Logs.DelHorseWebhook then
                            local Message = "`\n**PlayerID** `" .. _source .. "`\n **Action:** `Used Delhorse`"
                            local title = "📋` /delhorse command` "
                            VorpCore.AddWebhook(title, Config.Logs.DelHorseWebhook, message .. Message)
                        end

                    elseif CurrentCommand == "delwagons" then
                        local radius = tonumber(args[1])

                        if CheckArgs(args, _source, 1) then
                            return
                        end

                        if radius > 1 then
                            TriggerClientEvent("vorp:deleteVehicle", _source, radius)

                            if Config.Logs.DelWagonsWebhook then
                                local Message = "`\n**PlayerID** `" ..
                                    _source .. "`\n **Action:** `Used delwagons` \n **Radius:** `" .. radius .. "`"
                                local title = "📋` /delwagons command` "
                                VorpCore.AddWebhook(title, Config.Logs.DelWagonsWebhook, message .. Message)
                            end
                        end

                    elseif CurrentCommand == "healplayer" then

                        local target = tonumber(args[1])
                        if #args == 0 or target == _source then
                            TriggerClientEvent('vorp:heal', _source)
                        else
                            if VorpCore.getUser(target) then
                                TriggerClientEvent('vorp:heal', target)
                            else
                                VorpCore.NotifyObjective(_source, "ID is wrong user doesnt exist", 4000)
                            end
                        end

                        if Config.Logs.HealPlayerWebhook then
                            local Message = "`\n**PlayerID** `" .. _source .. "`\n **Action:** `Was healed`"
                            local title = "📋` /healplayer command` "
                            VorpCore.AddWebhook(title, Config.Logs.HealPlayerWebhook, message .. Message)
                        end

                    elseif CurrentCommand == "banplayer" then
                        local target = tonumber(args[1])
                        if _source ~= target then -- cant ban yourself
                            local user = VorpCore.getUser(target)
                            local Group = user.group -- User DB table group
                            if not CheckGroupAllowed(Config.GroupAllowed, Group) then -- bann only non staff players

                                if CheckArgs(args, _source, 2) then --has  met the requirements
                                    return
                                end

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
                                end

                                TriggerClientEvent("vorp:ban", _source, target, datetime)

                                if Config.Logs.BanWarnWebhook then
                                    text = "banned someone until " ..
                                        os.date(Config.Langs.DateTimeFormat,
                                            datetime + Config.TimeZoneDifference * 3600) ..
                                        Config.Langs.TimeZone
                                    local Message = "`\n**PlayerID** `" .. _source .. "`\n **Action:** `" .. text .. "`"
                                    local title = "📋` /ban command` "
                                    VorpCore.AddWebhook(title, Config.Logs.BanWarnWebhook, message .. Message)
                                end
                            end
                        end

                    elseif CurrentCommand == "unban" then
                        local target = tonumber(args[1])

                        if CheckArgs(args, _source, 1) then
                            return
                        end

                        TriggerClientEvent("vorp:unban", _source, target)

                        if Config.Logs.BanWarnWebhook then
                            local Message = "`\n**PlayerID** `" .. _source .. "`\n **Action:** `has used unbanned`"
                            local title = "📋` /unban command` "
                            VorpCore.AddWebhook(title, Config.Logs.BanWarnWebhook, message .. Message)
                        end

                    elseif CurrentCommand == "wlplayer" then
                        local target = tonumber(args[1])
                        if CheckArgs(args, _source, 1) then
                            return
                        end

                        TriggerEvent("vorp:whitelistPlayer", target)

                        if Config.Logs.WhitelistWebhook then
                            local Message = "`\n**PlayerID** `" .. _source .. "`\n **Action:** `has used whitelist`"
                            local title = "📋` /wlplayer command` "
                            VorpCore.AddWebhook(title, Config.Logs.WhitelistWebhook, message .. Message)
                        end
                    elseif CurrentCommand == "unwlplayer" then
                        local target = tonumber(args[1])

                        if CheckArgs(args, _source, 1) then
                            return
                        end
                        TriggerEvent("vorp:unwhitelistPlayer", target)
                        if Config.Logs.WhitelistWebhook then
                            local Message = "`\n**PlayerID** `" .. _source .. "`\n **Action:** `has used unwhitelist`"
                            local title = "📋` /unwlplayer command` "
                            VorpCore.AddWebhook(title, Config.Logs.WhitelistWebhook, message .. Message)
                        end
                    elseif CurrentCommand == "unwarn" then
                        local target = tonumber(args[1])

                        if CheckArgs(args, _source, 1) then
                            return
                        end

                        TriggerClientEvent("vorp:unwarn", _source, target)

                        if Config.Logs.BanWarnWebhook then
                            local Message = "`\n**PlayerID** `" .. _source .. "`\n **Action:** `has used unwarned`"
                            local title = "📋` /unwarn command` "
                            VorpCore.AddWebhook(title, Config.Logs.BanWarnWebhook, message .. Message)
                        end

                    elseif CurrentCommand == "warn" then
                        local target = tonumber(args[1])

                        if CheckArgs(args, _source, 1) then
                            return
                        end
                        if _source ~= target then -- dont warn yourself
                            TriggerClientEvent("vorp:warn", _source, target)
                            if Config.Logs.BanWarnWebhook then
                                local Message = "`\n**PlayerID** `" .. _source .. "`\n **Action:** `has used warned`"
                                local title = "📋` /warn command` "
                                VorpCore.AddWebhook(title, Config.Logs.BanWarnWebhook, message .. Message)
                            end
                        end
                    elseif CurrentCommand == "addchar" then
                        if Config.UseCharPermission then
                            local target = tonumber(args[1])

                            if CheckArgs(args, _source, 1) then
                                return
                            end

                            TriggerClientEvent("vorp:addchar", _source, target)
                            VorpCore.NotifyRightTip(_source, Config.Langs.AddChar .. target, 4000)

                            if Config.Logs.CharPermWebhook then
                                local Message = "`\n**PlayerID** `" ..
                                    _source .. "`\n **Action:** `has used multicharacter`"
                                local title = "📋` /addchar command` "
                                VorpCore.AddWebhook(title, Config.Logs.CharPermWebhook, message .. Message)
                            end
                        end
                    elseif CurrentCommand == "removechar" then
                        if Config.UseCharPermission then
                            local target = tonumber(args[1])

                            if CheckArgs(args, _source, 1) then
                                return
                            end

                            TriggerClientEvent("vorp:removechar", _source, target)
                            VorpCore.NotifyRightTip(_source, Config.Langs.RemoveChar .. target, 4000)

                            if Config.Logs.CharPermWebhook then
                                local Message = "`\n**PlayerID** `" ..
                                    _source .. "`\n **Action:** `Has used remove multicharacter`"
                                local title = "📋` /removechar command` "
                                VorpCore.AddWebhook(title, Config.Logs.CharPermWebhook, message .. Message)
                            end
                        end
                    elseif CurrentCommand == "changeCharName" then
                        local target = tonumber(args[1])
                        local firstname = args[2]
                        local lastname = args[3]

                        if CheckArgs(args, _source, 3) then
                            return
                        end

                        local CharacterT = VorpCore.getUser(target).getUsedCharacter -- get old name
                        CharacterT.setFirstname(firstname)
                        CharacterT.setLastname(lastname)

                        if Config.Logs.ChangeNameWebhook then
                            local Message = "`\n**PlayerID** `" ..
                                _source .. "`\n **Action:** `Has used changename`"
                            local title = "📋` /changename command` "
                            VorpCore.AddWebhook(title, Config.Logs.ChangeNameWebhook, message .. Message)
                        end

                    end
                else
                    VorpCore.NotifyObjective(_source, Config.Langs.NoPermissions, 4000)
                end
            end
        end)
    end
end)



-- doesnt require Permissions
RegisterCommand("myjob", function(source, args, rawCommand)
    local _source   = source
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local job       = Character.job
    local grade     = Character.jobGrade
    VorpCore.NotifyRightTip(_source, Config.Langs.myjob .. job .. Config.Langs.mygrade .. grade, 4000)
end)

RegisterCommand("myhours", function(source, args, rawCommand)
    local _source = source
    local User    = VorpCore.getUser(_source)
    local hours   = User.hours

    local function isInteger(num)
        if math.floor(num) == num then
            return true
        end
        return false
    end

    if isInteger(hours) then
        VorpCore.NotifyRightTip(_source, Config.Langs.charhours .. hours, 4000)
    else
        local newhour = math.floor(hours - 0.5)
        VorpCore.NotifyRightTip(_source, Config.Langs.playhours .. newhour .. ":30", 4000)
    end

end)
---------------------------------------------------------------------------------------------------------
----------------------------------- CHAT ADD SUGGESTION --------------------------------------------------
-- TRANSLATE ONLY
RegisterServerEvent("vorp:chatSuggestion")
AddEventHandler("vorp:chatSuggestion", function()
    local _source = source
    local user    = VorpCore.getUser(_source)
    local group   = user.group

    if CheckAceAllowed(Config.AcePerms, _source) or CheckGroupAllowed(Config.GroupAllowed, group) then

        TriggerClientEvent("chat:addSuggestion", _source, "/addGroup", "VORPcore command set group to user.", {
            { name = "Id", help = 'player ID' }, { name = "Group", help = 'Group Name' },
        })

        TriggerClientEvent("chat:addSuggestion", _source, "/addJob", "VORPcore command set job to user.", {
            { name = "Id", help = 'player ID' }, { name = "Job", help = 'Job Name' },
            { name = "Rank", help = ' player Rank' },
        })

        TriggerClientEvent("chat:addSuggestion", _source, "/addMoney", "VORPcore command add money/gold to user", {
            { name = "Id", help = 'player ID' }, { name = "Type", help = 'Money 0 Gold 1' },
            { name = "Quantity", help = 'Quantity to give' },
        })

        TriggerClientEvent("chat:addSuggestion", _source, "/delMoney",
            "VORPcore command remove money/gold from user", {
            { name = "Id", help = 'player ID' }, { name = "Type", help = 'Money 0 Gold 1' },
            { name = "Quantity", help = 'Quantity to remove from User' },
        })

        TriggerClientEvent("chat:addSuggestion", _source, "/addwhitelist",
            "VORPcore command Example: /addwhitelist 11000010c8aa16e", {
            { name = "AddWhiteList", help = ' steam ID like this > 11000010c8aa16e' },
        })

        TriggerClientEvent("chat:addSuggestion", _source, "/addItems", " VORPcore command to give items.", {
            { name = "Id", help = 'player ID' }, { name = "Item", help = 'item name' },
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
            { name = "Id", help = 'player ID' }, { name = "Weapon", help = 'Weapon hash name' },

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
        TriggerClientEvent("chat:addSuggestion", _source, "/changeCharName",
            " VORPcore command to change characters name.", {
            { name = "Id", help = 'player ID ' },
            { name = "first name", help = 'new player first name' },
            { name = "last name", help = 'new player last  name' },
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
        for _, value in pairs(Config.Commands) do
            TriggerClientEvent("chat:removeSuggestion", _source, "/" .. value)
        end

    end
    TriggerClientEvent("chat:addSuggestion", _source, "/myhours", " VORPcore command to see ur hours.", {})
    TriggerClientEvent("chat:addSuggestion", _source, "/myjob", " VORPcore command to see ur job.", {})

end)
