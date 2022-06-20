_usersLoading = {}
_users = {}

function CheckConnected(identifier)
    --Check if some player is connected with same steam
    return false
end

function LoadUser(source, setKickReason, deferrals, identifier, license)
    local resultList = exports.ghmattimysql:executeSync("SELECT * FROM users WHERE identifier = ?", { identifier })

    _usersLoading[identifier] = true

    print(string.format("Loading player %s.", GetPlayerName(source)))

    if #resultList > 0 then
        local user = resultList[1]
        if user["banned"] == true then
            local bannedUntilTime = user["banneduntil"]
            local currentTime = tonumber(os.time(os.date("!*t")))

            if bannedUntilTime == 0 then
                deferrals.done("You are banned permanently!")
                setKickReason("You are banned permanently!")
            elseif bannedUntilTime > currentTime then
                local bannedUntil = os.date(Config.Langs["DateTimeFormat"], bannedUntilTime+Config.TimeZoneDifference*3600)
                deferrals.done(Config.Langs["BannedUser"]..bannedUntil..Config.Langs["TimeZone"])
                setKickReason(Config.Langs["BannedUser"]..bannedUntil..Config.Langs["TimeZone"])
            else
                TriggerEvent("vorpbans:addtodb", false, GetUserId(identifier), 0)
            end
        end

        _users[identifier] = User(source, identifier, user["group"], user["warnings"], license)

        _users[identifier].LoadCharacters()

        deferrals.done()
    else
        --New User
        exports.ghmattimysql:executeSync("INSERT INTO users VALUES(?,'user',0,0,0)", { identifier })
        _users[identifier] = User(source, identifier, "user", 0, license)
        deferrals.done()
    end
end

AddEventHandler('playerDropped', function()
    local identifier = GetSteamID(source)

    --SaveCoordsDB.LastCoordsInCache.Remove(player);
    if _users[identifier] and not _usersLoading[identifier] then
        _users[identifier].SaveUser()
        _users[identifier] = nil
        print(string.format("Saved player %s.", GetPlayerName(source)))
    end
end)

AddEventHandler('playerJoining', function()
    local _source = source
    local identifier = GetSteamID(_source)
    local retvalList = exports.ghmattimysql:executeSync('SELECT * FROM whitelist WHERE identifier = ?', { identifier })
    if not Config.Whitelist then
        if #retvalList == 0 then
            exports.ghmattimysql:executeSync("INSERT INTO whitelist (identifier, status, firstconnection) VALUES (@identifier, @status, @firstcon)",
                                            {['@identifier'] = identifier, ['@status']=false, ['@firstcon'] = true})
            retvalList = exports.ghmattimysql:executeSync('SELECT * FROM whitelist WHERE identifier = ?', { identifier })
        end
    end
    Wait(30000)
    local discordIdentity = GetIdentity(_source, "discord")
    local discordId
    if discordIdentity then
        discordId = discordIdentity:sub(9)
    else
        discordId = ""
    end
    local steamName = GetPlayerName(_source)
    local userid
    if #retvalList > 0 then
        local entry = retvalList[1]
        userid = entry["id"]
    end
    if not _whitelist[userid] then
        _whitelist[userid] = Whitelist(userid, identifier, false, true)
    end
    local message = "**Steam name: **`" .. steamName .. "`**\nIdentifier:** `" .. identifier .. "` \n**Discord:** <@" .. discordId .. ">\n **User-Id:** `" .. userid .."`"
    if _whitelist[userid].GetEntry().getFirstconnection() then
        TriggerEvent("vorp:newPlayerWebhook", "📋` New player joined server` ", message, color)
        _whitelist[userid].GetEntry().setFirstconnection(false)
    end
end)

RegisterNetEvent('vorp:playerSpawn', function()
    local source = source
    local identifier = GetSteamID(source)

    _usersLoading[identifier] = false

    if _users[identifier] then
        --Debug.WriteLine("Characters loaded "+_users[identifier].Numofcharacters);
        _users[identifier].Source(source)
        if _users[identifier].Numofcharacters() <= 0 then
            TriggerEvent("vorp_CreateNewCharacter", source)
            Wait(7000)
            TriggerClientEvent('vorp:NotifyLeft', source, "~e~IMPORTANT!",Config.Langs.NotifyChar,"minigames_hud", "five_finger_burnout", 6000,"COLOR_RED")
        else
            if Config["MaxCharacters"] == 1 and _users[identifier].Numofcharacters() <= 1 then
                TriggerEvent("vorp_SpawnUniqueCharacter", source)
            else
                TriggerEvent("vorp_GoToSelectionMenu", source)
                Wait(14000)
                TriggerClientEvent('vorp:NotifyLeft', source, "~e~IMPORTANT!",Config.Langs.NotifyCharSelect, "minigames_hud", "five_finger_burnout",6000, "COLOR_RED")
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


Citizen.CreateThread(function()
    --Loop to save all players
    --each 5 minutes maybe add config for this? and toggle?
    while true do
        Citizen.Wait(180000)

        for k, v in pairs(_users) do
            v.SaveUser()
        end

        -- print('Saved all players')
    end
end)
