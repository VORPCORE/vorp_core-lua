_usersLoading = {}
_users = {}
_healthData = {}

local T = Translation[Lang].MessageOfSystem

function LoadUser(source, setKickReason, deferrals, identifier, license)
    local resultList = MySQL.single.await('SELECT banned, banneduntil FROM users WHERE identifier = ?', { identifier })

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
                TriggerEvent("vorpbans:addtodb", false, identifier, 0)
            end
        end

        deferrals.done()
    else
        MySQL.insert("INSERT INTO users VALUES(?,?,?,?,?,?)", { identifier, "user", 0, 0, 0, Config.MaxCharacters })
        _users[identifier] = User(source, identifier, "user", 0, license, Config.MaxCharacters)
        deferrals.done()
    end
end

function GetMaxCharactersAllowed(source)
    local identifier = GetSteamID(source)
    local user = _users[identifier]
    if not user then
        return
    end
    return user._charperm
end

local function savePlayer(_source, reason, identifier)
    local discordId = GetDiscordID(_source)
    local steamName = GetPlayerName(_source)

    if _users[identifier] and _users[identifier].GetUsedCharacter() then
        if Config.SavePlayersStatus then
            _users[identifier].GetUsedCharacter().HealthOuter(_healthData[identifier].hOuter)
            _users[identifier].GetUsedCharacter().HealthInner(_healthData[identifier].hInner)
            _users[identifier].GetUsedCharacter().StaminaOuter(_healthData[identifier].sOuter)
            _users[identifier].GetUsedCharacter().StaminaInner(_healthData[identifier].sInner)
        end
        _users[identifier].SaveUser()
        Player(_source).state:set('Character', nil, true)
        Player(_source).state:set('IsInSession', nil, true)
    end

    if Config.PrintPlayerInfoOnLeave then
        print('Player ^2' .. steamName .. ' ^7steam:^3 ' .. identifier .. '^7 saved ' .. (reason and " reason: " .. reason or ""))
    end

    if Config.SaveDiscordId then --TODO this can de added as default
        MySQL.update('UPDATE characters SET `discordid` = ? WHERE `identifier` = ? ', { discordId, identifier })
    end
end

local function removePlayer(identifier)
    if not identifier then
        return
    end

    if _usersLoading[identifier] == false or _usersLoading[identifier] then
        _usersLoading[identifier] = nil
    end

    local userid = Whitelist.Functions.GetUserId(identifier)
    if userid and WhiteListedUsers[userid] then
        WhiteListedUsers[userid] = nil
    end

    SetTimeout(5000, function()
        if _users[identifier] then
            _users[identifier] = nil
        end
    end)
end

local function ReportCrash(reason, _source)
    local _, _, errorMessage = reason:find("RAGE error:%s(.+)")
    if not errorMessage then
        _, _, errorMessage = reason:find("Game crashed:%s(.+)")
    end

    if errorMessage then
        local ped = GetPlayerPed(_source)
        local pcoords = GetEntityCoords(ped)
        local coords = {
            x = pcoords.x,
            y = pcoords.y,
            z = pcoords.z
        }
        local crash_id = string.lower(errorMessage:gsub("%b()", ""))
        PerformHttpRequest("http://api.gtp-dev.com:8080/api/crashes", function()
        end, "POST", json.encode({
            apiKey = Config.API_KEY,
            crash_id = crash_id,
            server = GetConvar("sv_projectName", "Unknown"),
            coords = json.encode(coords)
        }), {
            ["Content-Type"] = "application/json"
        })
    end
end

AddEventHandler('playerDropped', function(reason)
    local _source = source
    local identifier = GetSteamID(_source)
    savePlayer(_source, reason, identifier)
    removePlayer(identifier)
    if Config.ReportCrashes and Config.API_KEY ~= "" then
        ReportCrash(reason, _source)
    end
end)

---@todo allow to save player when they are still in the server  example of usage is  not have to relog to select another character
--[[ AddEventHandler("vorp_core:playerRemove", function(source)
    local _source = source
    local identifier = GetSteamID(_source)
    savePlayer(_source, nil, identifier)
end)

AddEventHandler("vorp:Server:playerLeave", function(source)     -- trigger this event when you have logic to remove player
    local _source = source
    TriggerEvent("vorp_core:playerRemove", _source)             -- save player
    TriggerClientEvent("vorp_core:Client:playerLeave", _source) -- let client know character left
end) ]]

AddEventHandler("playerJoining", function()
    local _source = source
    local identifier = GetSteamID(_source)
    local license = GetLicenseID(_source)
    Player(_source).state:set('IsInSession', false, true)

    if not identifier then
        return print("user cant load no identifier steam found make sure steam web API key is set up")
    end
    _usersLoading[identifier] = true

    local user = MySQL.single.await('SELECT `group`, `warnings`, `char` FROM users WHERE identifier = ?', { identifier })
    if user then
        _users[identifier] = User(_source, identifier, user.group, user.warnings, license, user.char)
        _users[identifier].LoadCharacters()
    else
        MySQL.insert("INSERT INTO users VALUES(?,?,?,?,?,?)", { identifier, "user", 0, 0, 0, Config.MaxCharacters })
        _users[identifier] = User(_source, identifier, "user", 0, license, Config.MaxCharacters)
    end
end)


RegisterNetEvent('vorp:playerSpawn', function()
    local _source = source
    local identifier = GetSteamID(_source)

    if not identifier then
        return print("user cant load no identifier steam found")
    end
    _usersLoading[identifier] = false

    local user = _users[identifier]
    if not user then
        return
    end

    user.Source(_source)

    local numCharacters = user.Numofcharacters()

    if numCharacters <= 0 then
        return TriggerEvent("vorp_CreateNewCharacter", _source)
    else
        if tonumber(user._charperm) > 1 then
            return TriggerEvent("vorp_character:server:GoToSelectionMenu", _source)
        else
            return TriggerEvent("vorp_character:server:SpawnUniqueCharacter", _source)
        end
    end
end)


RegisterNetEvent('vorp:SaveHealth', function(healthOuter, healthInner)
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

RegisterNetEvent('vorp:SaveStamina', function(staminaOuter, staminaInner)
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

RegisterNetEvent('vorp:HealthCached', function(healthOuter, healthInner, staminaOuter, staminaInner)
    local _source = source
    local identifier = GetSteamID(_source)

    if not identifier then
        return
    end

    if not _healthData[identifier] then
        _healthData[identifier] = {}
    end

    _healthData[identifier].hOuter = healthOuter
    _healthData[identifier].hInner = healthInner
    _healthData[identifier].sOuter = staminaOuter
    _healthData[identifier].sInner = staminaInner
end)

RegisterNetEvent("vorp:GetValues", function()
    local _source = source
    local healthData = { hOuter = 10, hInner = 10, sOuter = 10, sInner = 10 }
    local identifier = GetSteamID(_source)
    local user = _users[identifier] or nil

    -- Only if the player exists in online table...
    if user and user.GetUsedCharacter then
        local used_char = user.GetUsedCharacter() or nil

        -- Only there is an character...
        if used_char then
            healthData.hOuter = used_char.HealthOuter() or 10
            healthData.hInner = used_char.HealthInner() or 10
            healthData.sOuter = used_char.StaminaOuter() or 10
            healthData.sInner = used_char.StaminaInner() or 10
        end
    end

    TriggerClientEvent("vorp:GetHealthFromCore", _source, healthData)
end)

if Config.DeleteFromUsersTable and not Config.Whitelist then
    MySQL.ready(function()
        local query = "DELETE FROM users WHERE NOT EXISTS (SELECT 1 FROM characters WHERE characters.identifier = users.identifier);"
        MySQL.query(query, {})
    end)
end
