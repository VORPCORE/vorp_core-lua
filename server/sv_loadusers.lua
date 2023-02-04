_usersLoading = {}
_users = {}
_healthData = {}




function LoadUser(source, setKickReason, deferrals, identifier, license)

    local resultList = MySQL.single.await('SELECT 1 FROM users WHERE identifier = ?', { identifier })
    _usersLoading[identifier] = true

    if resultList then
        local user = resultList
        if user.banned == true then
            local bannedUntilTime = user.banneduntil
            local currentTime = tonumber(os.time(os.date("!*t")))

            if bannedUntilTime == 0 then
                deferrals.done("You are banned permanently!")
                setKickReason("You are banned permanently!")
            elseif bannedUntilTime > currentTime then
                local bannedUntil = os.date(Config.Langs.DateTimeFormat,
                    bannedUntilTime + Config.TimeZoneDifference * 3600)
                deferrals.done(Config.Langs.BannedUser .. bannedUntil .. Config.Langs.TimeZone)
                setKickReason(Config.Langs.BannedUser .. bannedUntil .. Config.Langs.TimeZone)
            else
                local getuser = GetUserId(identifier)
                TriggerEvent("vorpbans:addtodb", false, getuser, 0)
            end
        end

        if Config.UseCharPermission then
            _users[identifier] = User(source, identifier, user["group"], user["warnings"], license, user["char"])
        else
            _users[identifier] = User(source, identifier, user["group"], user["warnings"], license)
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

    if _users[identifier] and not _usersLoading[identifier] then
        if _users[identifier].GetUsedCharacter() then
            if Config.SavePlayersStatus then
                _users[identifier].GetUsedCharacter().HealthOuter(_healthData[identifier].hOuter)
                _users[identifier].GetUsedCharacter().HealthInner(_healthData[identifier].hInner)
                _users[identifier].GetUsedCharacter().StaminaOuter(_healthData[identifier].sOuter)
                _users[identifier].GetUsedCharacter().StaminaInner(_healthData[identifier].sInner)
            end
            _users[identifier].SaveUser()
            if Config.PrintPlayerInfoOnLeave then
                print("Player ^2", GetPlayerName(_source) .. " ^7steam:^3 " .. identifier .. "^7 saved")
            end
            Wait(10000)
            _users[identifier] = nil
        end
    end

    if Config.SaveSteamNameDB then
        MySQL.update("UPDATE characters SET `steamname` = ? WHERE `identifier` = ? ",
            { steamName, identifier })
    end

end)


AddEventHandler('playerJoining', function()
    local _source = source
    local identifier = GetSteamID(_source)
    local isWhiteListed = MySQL.single.await('SELECT * FROM whitelist WHERE identifier = ?', { identifier })

    if not Config.Whitelist then
        if not isWhiteListed then
            MySQL.insert.await("INSERT INTO whitelist (identifier, status, firstconnection) VALUES (?,?,?)"
                , { identifier, false, true })

            isWhiteListed = MySQL.single.await('SELECT 1 FROM whitelist WHERE identifier = ?', { identifier })
        end
    end
    -- Wait(30000) -- why do we wait here 30 seconds ?
    local discordIdentity = GetIdentity(_source, "discord")
    local discordId
    if discordIdentity then
        discordId = discordIdentity:sub(9)
    else
        discordId = ""
    end

    local userid
    if isWhiteListed then
        local entry = isWhiteListed
        userid = entry.id
    end
    if not _whitelist[userid] then
        _whitelist[userid] = Whitelist(userid, identifier, false, true)
    end


    if _whitelist[userid].GetEntry().getFirstconnection() then
        local steamName = GetPlayerName(_source)
        if steamName == nil then

            local message = "`**\nIdentifier:** `" ..
                identifier .. "` \n**Discord:** <@" .. discordId .. ">\n **User-Id:** `" .. userid .. "`"
            TriggerEvent("vorp_core:addWebhook", "📋` New player joined server` ", Config.Logs.NewPlayerWebhook,
                message)
        else

            local message = "**Steam name: **`" .. steamName .. "`**\nIdentifier:** `" ..
                identifier .. "` \n**Discord:** <@" .. discordId .. ">\n **User-Id:** `" .. userid .. "`"

            TriggerEvent("vorp_core:addWebhook", "📋` New player joined server` ", Config.Logs.NewPlayerWebhook,
                message)

        end
        _whitelist[userid].GetEntry().setFirstconnection(false)
    end
end)

RegisterNetEvent('vorp:playerSpawn', function()
    local source = source
    local identifier = GetSteamID(source)
    if identifier then
        _usersLoading[identifier] = false

        if _users[identifier] then
            _users[identifier].Source(source)
            if _users[identifier].Numofcharacters() <= 0 then
                TriggerEvent("vorp_CreateNewCharacter", source)
                Wait(7000)
                TriggerClientEvent('vorp:NotifyLeft', source, "~e~IMPORTANT!", Config.Langs.NotifyChar, "minigames_hud",
                    "five_finger_burnout", 6000, "COLOR_RED")
            else
                if Config.UseCharPermission then
                    if _users[identifier]._charperm == "false" and _users[identifier].Numofcharacters() <= 1 then
                        TriggerEvent("vorp_SpawnUniqueCharacter", source)
                    elseif _users[identifier]._charperm == "true" then
                        TriggerEvent("vorp_GoToSelectionMenu", source)
                        Wait(14000)
                        TriggerClientEvent('vorp:NotifyLeft', source, "~e~IMPORTANT!", Config.Langs.NotifyCharSelect,
                            "minigames_hud", "five_finger_burnout", 6000, "COLOR_RED")
                    end
                else
                    if Config["MaxCharacters"] == 1 and _users[identifier].Numofcharacters() <= 1 then
                        TriggerEvent("vorp_SpawnUniqueCharacter", source)
                    else
                        TriggerEvent("vorp_GoToSelectionMenu", source)
                        Wait(14000)
                        TriggerClientEvent('vorp:NotifyLeft', source, "~e~IMPORTANT!", Config.Langs.NotifyCharSelect,
                            "minigames_hud", "five_finger_burnout", 6000, "COLOR_RED")
                    end
                end
            end
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
        Citizen.Wait(Config.savePlayersTimer * 60000) -- this should be above 10 minutes
        for k, v in pairs(_users) do
            if v.usedCharacterId and v.usedCharacterId ~= -1 then -- save only when player has selected char and save only that char
                v.SaveUser()
            end
        end
    end
end)

RegisterNetEvent("vorpchar:addtodb")
AddEventHandler("vorpchar:addtodb", function(status, identifier)

    local resultList = MySQL.prepare.await("SELECT 1 FROM users WHERE identifier = ?", { identifier })
    local char
    if resultList then
        for _, player in ipairs(GetPlayers()) do
            if identifier == GetPlayerIdentifiers(player)[1] then
                if status == true then
                    TriggerClientEvent("vorp:Tip", player, Config.Langs.AddChar, 10000)
                    char = "true"
                else
                    TriggerClientEvent("vorp:Tip", player, Config.Langs.RemoveChar, 10000)
                    char = "false"
                end
                break
            end
        end

    end

    MySQL.update("UPDATE users SET `char` = ? WHERE `identifier` = ? ", { char, identifier })
end)
