-------------------------------------------------------------------------------------------------
--------------------------------------- VORP ADMIN COMMANDS -------------------------------------
-------------------------------------------------------------------------------------------------

local T = Translation[Lang].MessageOfSystem

local function CheckUser(target)
    if not CoreFunctions.getUser(tonumber(target)) then
        return false
    end
    return true
end

local function CheckArgs(args, requiered)
    if #args == requiered then
        return true
    end
    return false
end

local function CheckAce(ace, source)
    if not ace then
        return true
    end
    local all = 'vorpcore.showAllCommands'
    local aceAllowed = IsPlayerAceAllowed(source, all)

    if aceAllowed then
        return true
    end

    aceAllowed = IsPlayerAceAllowed(source, ace)

    if aceAllowed then
        return true
    end

    return false
end

local function LogMessage(_source)
    local Identifier = GetPlayerIdentifier(_source, 1) -- steam id
    local getDiscord = GetPlayerIdentifierByType(_source, 'discord')
    local discordId = getDiscord and string.sub(getDiscord, 9) or "No discord found"
    local ip = GetPlayerEndpoint(_source)    -- ip
    local steamName = GetPlayerName(_source) -- steam name
    local message = Translation[Lang].Commands.webHookMessage
    message = string.format(message, steamName, Identifier, discordId, ip)

    return message
end

local function CheckGroupAllowed(Table, Group)
    if not next(Table) then
        return true
    end

    for _, value in pairs(Table) do
        if value == Group then
            return true
        end
    end
    return false
end

local function CheckJobAllowed(Table, Job)
    if not Table or not next(Table) then
        return true
    end

    for _, value in pairs(Table) do
        if value == Job then
            return true
        end
    end

    return false
end

function RegisterCommands(value, key)
    RegisterCommand(value.commandName, function(source, args, rawCommand)
        local _source = source

        if _source == 0 then
            return print("you must be in game to use this command")
        end

        local group = CoreFunctions.getUser(_source).getGroup -- admin group

        if not CheckAce(value.aceAllowed, _source) and not CheckGroupAllowed(value.groupAllowed, group) then
            return CoreFunctions.NotifyObjective(_source, T.NoPermissions, 4000)
        end

        if value.userCheck then
            if not CheckUser(args[1]) then
                return CoreFunctions.NotifyObjective(_source, Translation[Lang].Notify.userNonExistent, 4000)
            end
        end

        if value.jobAllow and not CheckJobAllowed(value.jobAllow, _source) then
            return CoreFunctions.NotifyObjective(_source, T.NoPermissions, 4000)
        end

        if not CheckArgs(args, (key == "addJob" and #args == 5) and #value.suggestion + 1 or #value.suggestion) then
            return CoreFunctions.NotifyObjective(_source, Translation[Lang].Notify.ReadSuggestion, 4000)
        end

        local arguments = { source = _source, args = args, rawCommand = rawCommand, config = value }
        value.callFunction(arguments)
    end, false)
end

-- cor main commands
CreateThread(function()
    for key, value in pairs(Commands) do
        RegisterCommands(value, key)
    end
end)

--====================================== FUNCTIONS =========================================================--

local function SendDiscordLogs(link, data, arg1, arg2, arg3)
    if link then
        local message = LogMessage(data.source)
        local custom = data.config.custom
        local finaltext = message .. string.format(custom, arg1, arg2, arg3)
        local title = data.config.title
        CoreFunctions.AddWebhook(title, link, finaltext)
    end
end

--ADDGROUPS
function SetGroup(data)
    local target = tonumber(data.args[1])
    local newgroup = tostring(data.args[2])
    local Character = CoreFunctions.getUser(target).getUsedCharacter
    local User = CoreFunctions.getUser(target)

    if User and Config.SetBothDBadmin then
        Character.setGroup(newgroup)
        User.setGroup(newgroup)
    else
        if User and Config.SetUserDBadmin then
            User.setGroup(newgroup)
        else
            Character.setGroup(newgroup)
        end
    end

    SendDiscordLogs(data.config.webhook, data, data.source, newgroup, "")
    CoreFunctions.NotifyRightTip(data.source, string.format(Translation[Lang].Notify.SetGroup, target), 4000)
    CoreFunctions.NotifyRightTip(target, string.format(Translation[Lang].Notify.SetGroup1, newgroup), 4000)
end

--ADDJOBS
function AddJob(data)
    local target = tonumber(data.args[1])
    local newjob = tostring(data.args[2])
    local jobgrade = tonumber(data.args[3])
    local joblabel = tostring(data.args[4]) .. " " .. (data.args[5] and tostring(data.args[5]) or "")
    local Character = CoreFunctions.getUser(target).getUsedCharacter

    Character.setJob(newjob)
    Character.setJobGrade(jobgrade)
    Character.setJobLabel(joblabel)
    SendDiscordLogs(data.config.webhook, data, data.source, newjob, jobgrade)
    CoreFunctions.NotifyRightTip(data.source, string.format(Translation[Lang].Notify.AddJob, newjob, target, jobgrade), 4000)
    CoreFunctions.NotifyRightTip(target, string.format(Translation[Lang].Notify.AddJob1, newjob, jobgrade), 4000)
end

--ADDMONEY
function AddMoney(data)
    if type(tonumber(data.args[2])) ~= "number" then
        return CoreFunctions.NotifyObjective(data.source, Translation[Lang].Notify.error, 4000)
    end

    local target = tonumber(data.args[1])
    local montype = tonumber(data.args[2])
    local quantity = tonumber(data.args[3])
    local Character = CoreFunctions.getUser(target).getUsedCharacter

    Character.addCurrency(montype, quantity)

    SendDiscordLogs(data.config.webhook, data, data.source, montype, quantity)
    CoreFunctions.NotifyRightTip(data.source, string.format(Translation[Lang].Notify.AddMoney, quantity, target), 4000)
    CoreFunctions.NotifyRightTip(target, string.format(Translation[Lang].Notify.AddMoney1, quantity), 4000)
end

--ADDITEMS
function AddItems(data)
    local target = tonumber(data.args[1])
    local item = tostring(data.args[2])
    local count = tonumber(data.args[3])

    local VORPInv = exports.vorp_inventory
    local itemCheck = VORPInv:getItemDB(item)
    local canCarry = VORPInv:canCarryItems(target, count)       --can carry inv space
    local canCarry2 = VORPInv:canCarryItem(target, item, count) --cancarry item limit

    if not itemCheck then
        return print(item .. " < item dont exist in the database", 4000)
    end

    if not canCarry then
        return CoreFunctions.NotifyObjective(data.source, Translation[Lang].Notify.invfull, 4000)
    end

    if not canCarry2 then
        return CoreFunctions.NotifyObjective(data.source, Translation[Lang].Notify.cantcarry, 4000)
    end

    VORPInv:addItem(target, item, count)
    SendDiscordLogs(data.config.webhook, data, data.source, item, count)
    CoreFunctions.NotifyRightTip(target, string.format(Translation[Lang].Notify.AddItems, item, count), 4000)
end

--ADDWEAPONS
function AddWeapons(data)
    local target = tonumber(data.args[1])
    local weaponHash = tostring(data.args[2])
    local canCarry = exports.vorp_inventory:canCarryWeapons(target, 1, nil, weaponHash)
    if not canCarry then
        return CoreFunctions.NotifyObjective(data.source, T.cantCarry, 4000)
    end

    local result = exports.vorp_inventory:createWeapon(target, weaponHash, {})
    if not result then
        return CoreFunctions.NotifyRightTip(target, "weapon does not exist or is wrong name", 4000)
    end
    SendDiscordLogs(data.config.webhook, data, data.source, weaponHash, "")
    CoreFunctions.NotifyRightTip(target, Translation[Lang].Notify.AddWeapons, 4000)
end

--DELCURRENCY
function RemmoveCurrency(data)
    if type(tonumber(data.args[2])) ~= "number" then
        return CoreFunctions.NotifyObjective(data.source, Translation[Lang].Notify.error, 4000)
    end

    local target = tonumber(data.args[1])
    local montype = tonumber(data.args[2])
    local quantity = tonumber(data.args[3])
    local Character = CoreFunctions.getUser(target).getUsedCharacter

    Character.removeCurrency(montype, quantity)
    SendDiscordLogs(data.config.webhook, data, data.source, montype, quantity)
    CoreFunctions.NotifyRightTip(data.source, string.format(Translation[Lang].Notify.removedcurrency, quantity, target), 4000)
end

--REVIVEPLAYERS
function RevivePlayer(data)
    local target = tonumber(data.args[1])
    TriggerClientEvent('vorp:resurrectPlayer', target)
    SendDiscordLogs(data.config.webhook, data, target, "", "")
    CoreFunctions.NotifyRightTip(data.source, string.format(Translation[Lang].Notify.revived, target), 4000)
end

--TELPORTPLAYER
function TeleporPlayer(data)
    TriggerClientEvent('vorp:teleportWayPoint', data.source)
    SendDiscordLogs(data.config.webhook, data, data.source, "", "")
end

--DELETEHORSES
function DeleteHorse(data)
    TriggerClientEvent("vorp:delHorse", data.source)
    SendDiscordLogs(data.config.webhook, data, data.source, "", "")
end

--DELETEWAGONS
function DeleteWagons(data)
    local radius = tonumber(data.args[1])

    if radius < 1 then
        return CoreFunctions.NotifyRightTip(data.source, Translation[Lang].Notify.radius, 4000)
    end
    TriggerClientEvent("vorp:deleteVehicle", data.source, radius)
    SendDiscordLogs(data.config.webhook, data, data.source, "", "")
end

--HEALPLAYERS
function HealPlayers(data)
    local target = tonumber(data.args[1])
    TriggerClientEvent('vorp:heal', target)
    SendDiscordLogs(data.config.webhook, data, target, "", "")
    CoreFunctions.NotifyRightTip(data.source, string.format(Translation[Lang].Notify.healedPlayer, target), 4000)
end

--BANPLAYERS
function BanPlayers(data)
    local targetsteam = tonumber(data.args[1])
    local steamid = GetSteamID(data.source)
    if steamid and steamid == targetsteam then
        return CoreFunctions.NotifyRightTip(data.source, "Cant ban your self", 4000)
    end

    local banTime = tonumber(data.args[2]:match("%d+"))
    if not banTime then return end

    local unit = tostring(data.args[2]:match("%a+"))
    if unit == "d" then
        banTime = banTime * 24
    elseif unit == "w" then
        banTime = banTime * 168
    elseif unit == "m" then
        banTime = banTime * 720
    elseif unit == "y" then
        banTime = banTime * 8760
    end

    local datetime = os.time() + banTime * 3600
    TriggerEvent("vorpbans:addtodb", true, targetsteam, banTime)

    local text = banTime == 0 and Translation[Lang].Notify.banned or (Translation[Lang].Notify.banned2 .. os.date(Config.DateTimeFormat, datetime + Config.TimeZoneDifference * 3600) .. Config.TimeZone)
    SendDiscordLogs(data.config.webhook, data, data.source, text, "")
end

--UNBANPLAYERS
function UnBanPlayers(data)
    local targetsteam = tonumber(data.args[1])
    TriggerEvent("vorpbans:addtodb", false, targetsteam, 0)
    SendDiscordLogs(data.config.webhook, data, data.source, "", "")
end

--WHITELISTPLAYERS
function AddPlayerToWhitelist(data)
    local target = tostring(data.args[1])
    Whitelist.Functions.InsertWhitelistedUser({ identifier = target, status = true })
    SendDiscordLogs(data.config.webhook, data, data.source, "", "")
end

--UNWHITELISTPLAYERS
function RemovePlayerFromWhitelist(data)
    local target = tostring(data.args[1])
    local userid = Whitelist.Functions.GetUserId(target)
    Whitelist.Functions.WhitelistUser(userid, false)
    SendDiscordLogs(data.config.webhook, data, data.source, "", "")
end

--UNWARNPLAYERS
function UnWarnPlayer(data)
    local source = tonumber(data.source)
    local target = tonumber(data.args[1])
    TriggerEvent("vorpwarns:addtodb", false, target, source)
    SendDiscordLogs(data.config.webhook, data, data.source, "", "")
end

--WARN PLAYERS
function WarnPlayers(data)
    local source = tonumber(data.source)
    local target = tonumber(data.args[1])
    if data.source ~= target then -- dont warn yourself
        TriggerEvent("vorpwarns:addtodb", true, target, source)
        SendDiscordLogs(data.config.webhook, data, data.source, "", "")
    end
end

--ALLOW CHAR CREATION
function AddCharCanCreateMore(data)
    local target = data.args[1]
    local number = tonumber(data.args[2])
    local Character = CoreFunctions.getUser(target)
    Character.setCharperm(number)
    SendDiscordLogs(data.config.webhook, data, data.source, "", "")
    CoreFunctions.NotifyRightTip(data.source, T.AddChar .. target, 4000)
end

--MODIFY CHARACTER NAME
function ModifyCharName(data)
    local target = tonumber(data.args[1])
    local firstname = tostring(data.args[2])
    local lastname = tostring(data.args[3])

    local Character = CoreFunctions.getUser(target).getUsedCharacter
    Character.setFirstname(firstname)
    Character.setLastname(lastname)
    SendDiscordLogs(data.config.webhook, data, data.source, firstname, lastname)
    CoreFunctions.NotifyRightTip(target, string.format(Translation[Lang].Notify.namechange, firstname, lastname), 4000)
end

--MYJOB
function MyJob(data)
    local _source   = data.source
    local Character = CoreFunctions.getUser(_source).getUsedCharacter
    local job       = Character.job
    local grade     = Character.jobGrade
    CoreFunctions.NotifyRightTip(_source, T.myjob .. job .. T.mygrade .. grade, 4000)
end

--MY HOURS
function MyHours(data)
    local _source = data.source
    local User    = CoreFunctions.getUser(_source).getUsedCharacter
    local hours   = User.hours

    local function isInteger(num)
        if math.floor(num) == num then
            return true
        end
        return false
    end

    if isInteger(hours) then
        CoreFunctions.NotifyRightTip(_source, string.format(T.charhours, hours), 4000)
    else
        local newhour = math.floor(hours - 0.5)
        CoreFunctions.NotifyRightTip(_source, string.format(T.playhours, newhour, 30), 4000)
    end
end

--============================================ CHAT ADD SUGGESTION ========================================================--

function AddCommandSuggestions(_source, group, value)
    if CheckAce(value.aceAllowed, _source) or CheckGroupAllowed(value.groupAllowed, group) then
        return TriggerClientEvent("chat:addSuggestion", _source, "/" .. value.commandName, value.label, value.suggestion)
    end

    if value.jobAllow and CheckJobAllowed(value.jobAllow, _source) then
        return TriggerClientEvent("chat:addSuggestion", _source, "/" .. value.commandName, value.label, value.suggestion)
    end

    TriggerClientEvent("chat:removeSuggestion", _source, "/" .. value.commandName)
end

RegisterServerEvent("vorp:chatSuggestion", function()
    local _source = source
    local user    = CoreFunctions.getUser(_source)

    if not user then return end

    local group = user.getGroup
    for key, value in pairs(Commands) do
        AddCommandSuggestions(_source, group, value)
    end

    -- client commands
    TriggerClientEvent("chat:addSuggestion", _source, "/" .. Commands.myHours.commandName, Commands.myHours.label, {})
    TriggerClientEvent("chat:addSuggestion", _source, "/" .. Commands.myJob.commandName, Commands.myJob.label, {})
end)
--============================================================================================================================--
