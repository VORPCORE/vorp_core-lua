_usersLoading = {}
_users = {}
_healthData = {}

local T = Translation[Lang].MessageOfSystem

function LoadUser(source, setKickReason, deferrals, identifier, license)
    local resultList = MySQL.single.await('SELECT * FROM users WHERE identifier = ?', { identifier })
    _usersLoading[identifier] = true

    if resultList then
        local user = resultList
        if user.banned == true then
            local bannedUntilTime = user.banneduntil
            local currentTime = tonumber(os.time(os.date("!*t")))

            if bannedUntilTime == 0 then
                deferrals.done(T.permanentlyBan)
                setKickReason(T.permanentlyBan)
            elseif bannedUntilTime > currentTime then
                local bannedUntil = os.date(Config.DateTimeFormat, bannedUntilTime + Config.TimeZoneDifference * 3600)
                deferrals.done(T.BannedUser .. bannedUntil .. Config.TimeZone)
                setKickReason(T.BannedUser .. bannedUntil .. Config.TimeZone)
            else
                local getuser = GetUserId(identifier)
                TriggerEvent("vorpbans:addtodb", false, getuser, 0)
            end
        end

        if Config.UseCharPermission then
            _users[identifier] = User(source, identifier, user["group"], user["warnings"], license, user["char"])
        else
            _users[identifier] = User(source, identifier, user["group"], user["warnings"], license, false)
        end

        _users[identifier].LoadCharacters()

        deferrals.done()
    else
        --New User
        MySQL.insert("INSERT INTO users VALUES(?,?,?,?,?,?)", { identifier, "user", 0, 0, 0, "false" })
        _users[identifier] = User(source, identifier, "user", 0, license)
        deferrals.done()
    end
end

AddEventHandler('playerDropped', function()
    local _source = source
    local identifier = GetSteamID(_source)
    local steamName = GetPlayerName(_source)
    local pCoords, pHeading

    if Config.onesync then
        local ped = GetPlayerPed(_source)
        pCoords = GetEntityCoords(ped)
        pHeading = GetEntityHeading(ped)
    end

    if _users[identifier] and _users[identifier].GetUsedCharacter() then
        if Config.SavePlayersStatus then
            _users[identifier].GetUsedCharacter().HealthOuter(_healthData[identifier].hOuter)
            _users[identifier].GetUsedCharacter().HealthInner(_healthData[identifier].hInner)
            _users[identifier].GetUsedCharacter().StaminaOuter(_healthData[identifier].sOuter)
            _users[identifier].GetUsedCharacter().StaminaInner(_healthData[identifier].sInner)
        end
        _users[identifier].SaveUser(pCoords, pHeading)
        if Config.PrintPlayerInfoOnLeave then
            print('Player ^2' .. steamName .. ' ^7steam:^3 ' .. identifier .. '^7 saved')
        end
        _users[identifier] = nil
    end

    if Config.SaveSteamNameDB then
        MySQL.update('UPDATE characters SET `steamname` = ? WHERE `identifier` = ? ',
            { steamName, identifier })
    end
end)



AddEventHandler('playerJoining', function()
    local _source = source
    local identifier = GetSteamID(_source)
    local isWhiteListed = MySQL.single.await('SELECT * FROM whitelist WHERE identifier = ?', { identifier })

    if not Config.Whitelist and not isWhiteListed then
        MySQL.insert.await("INSERT INTO whitelist (identifier, status, firstconnection) VALUES (?,?,?)"
        , { identifier, false, true })

        isWhiteListed = MySQL.single.await('SELECT * FROM whitelist WHERE identifier = ?', { identifier })
    end

    local discordIdentity = GetPlayerIdentifierByType(_source, 'discord')
    local discordId = discordIdentity and discordIdentity:sub(9) or ""

    local userid = isWhiteListed and isWhiteListed.id
    if not _whitelist[userid] then
        _whitelist[userid] = Whitelist(userid, identifier, false, true)
    end

    local entry = _whitelist[userid].GetEntry()
    if entry.getFirstconnection() then
        local steamName = GetPlayerName(_source) or ""
        local message = string.format(Translation[Lang].addWebhook.whitelistid, steamName, identifier,
            discordId, userid)
        TriggerEvent("vorp_core:addWebhook", Translation[Lang].addWebhook.whitelistid1, Config.NewPlayerWebhook,
            message)

        entry.setFirstconnection(false)
    end
end)

--* character selection
RegisterNetEvent('vorp:playerSpawn', function()
    local source = source
    local identifier = GetSteamID(source)

    if not identifier then
        return
    end

    _usersLoading[identifier] = false

    local user = _users[identifier]

    if not user then
        return
    end

    user.Source(source)

    local numCharacters = user.Numofcharacters()

    if numCharacters <= 0 then
        return TriggerEvent("vorp_CreateNewCharacter", source)
    else
        --* if chosen maxchars is more than 1 then allow to choose character
        if not Config.UseCharPermission then
            if Config.MaxCharacters > 1 then
                return TriggerEvent("vorp_GoToSelectionMenu", source)
            else
                return TriggerEvent("vorp_SpawnUniqueCharacter", source)
            end
        end

        if tostring(user._charperm) == "true" then
            TriggerEvent("vorp_GoToSelectionMenu", source)
        else
            TriggerEvent("vorp_SpawnUniqueCharacter", source)
        end
    end
end)


RegisterNetEvent('vorp:getUser', function(cb)
    --[[{
        string steam = "steam:" + Players[source].Identifiers["steam"];
        if (_users.ContainsKey(steam))
        {
            cb.Invoke(_users[steam].GetUser());
        }
    });]]
end)

RegisterNetEvent('vorp:SaveHealth')
AddEventHandler('vorp:SaveHealth', function(healthOuter, healthInner)
    local _source = source
    local identifier = GetSteamID(_source)

    if healthInner and healthOuter then
        local user = _users[identifier] or nil

        if user then
            local used_char = user.GetUsedCharacter() or nil

            if used_char then
                used_char.HealthOuter(healthOuter - healthInner)
                used_char.HealthInner(healthInner)
            end
        end
    end
end)

RegisterNetEvent('vorp:SaveStamina')
AddEventHandler('vorp:SaveStamina', function(staminaOuter, staminaInner)
    local _source = source
    local identifier = GetSteamID(_source)
    if staminaOuter and staminaInner then
        local user = _users[identifier] or nil
        if user then
            local used_char = user.GetUsedCharacter() or nil
            if used_char then
                used_char.StaminaOuter(staminaOuter)
                used_char.StaminaInner(staminaInner)
            end
        end
    end
end)

RegisterNetEvent('vorp:HealthCached')
AddEventHandler('vorp:HealthCached', function(healthOuter, healthInner, staminaOuter, staminaInner)
    local _source = source
    local identifier = GetSteamID(_source)

    if not _healthData[identifier] then
        _healthData[identifier] = {}
    end

    _healthData[identifier].hOuter = healthOuter
    _healthData[identifier].hInner = healthInner
    _healthData[identifier].sOuter = staminaOuter
    _healthData[identifier].sInner = staminaInner
end)

RegisterNetEvent("vorp:GetValues")
AddEventHandler("vorp:GetValues", function()
    local healthData = {}
    local _source = source
    local identifier = GetSteamID(_source)

    healthData.hOuter = _users[identifier].GetUsedCharacter().HealthOuter()
    healthData.hInner = _users[identifier].GetUsedCharacter().HealthInner()
    healthData.sOuter = _users[identifier].GetUsedCharacter().StaminaOuter()
    healthData.sInner = _users[identifier].GetUsedCharacter().StaminaInner()

    TriggerClientEvent("vorp:GetHealthFromCore", _source, healthData)
end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.savePlayersTimer * 60000)             -- this should be above 10 minutes
        for k, v in pairs(_users) do
            if v.usedCharacterId and v.usedCharacterId ~= -1 then -- save only when player has selected char and save only that char
                v.SaveUser()
            end
        end
    end
end)


AddEventHandler("vorpchar:addtodb", function(status, identifier)
    local resultList = MySQL.prepare.await("SELECT * FROM users WHERE identifier = ?", { identifier })
    local char
    if resultList then
        for _, player in ipairs(GetPlayers()) do
            if identifier == GetPlayerIdentifiers(player)[1] then
                if status == true then
                    TriggerClientEvent("vorp:Tip", player, T.AddChar, 10000)
                    char = "true"
                else
                    TriggerClientEvent("vorp:Tip", player, T.RemoveChar, 10000)
                    char = "false"
                end
                break
            end
        end
    end

    MySQL.update("UPDATE users SET `char` = ? WHERE `identifier` = ? ", { char, identifier })
end)
