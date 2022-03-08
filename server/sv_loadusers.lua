_usersLoading = {}
_users = {}

function CheckConnected(identifier)
    --Check if some player is connected with same steam
    return false
end

function LoadUser(source, setKickReason, deferrals, identifier, license)
    local resultList = exports.ghmattimysql:executeSync("SELECT * FROM users WHERE identifier = ?", {identifier})

    _usersLoading[identifier] = true
    
    print(string.format("Loading player %s.", GetPlayerName(source)))

    if #resultList > 0 then
        local user = resultList[1]
        if user["banned"] == 1 then
            deferrals.done(Config.Langs["BannedUser"])
            setKickReason(Config.Langs["BannedUser"])
        end

        _users[identifier] = User(source, identifier, user["group"], user["warnings"], license)

        _users[identifier].LoadCharacters()

        deferrals.done()
    else
        --New User
        exports.ghmattimysql:executeSync("INSERT INTO users VALUES(?,'user',0,0)", {identifier})

        _users[identifier] = User(source, identifier, "user", 0, license)
        deferrals.done()
    end
end



RegisterNetEvent('vorp:playerSpawn', function()
    local source = source
    local identifier = GetSteamID(source)

    _usersLoading[identifier] = false
    
    if _users[identifier] then
        --Debug.WriteLine("Characters loaded "+_users[identifier].Numofcharacters);
        _users[identifier].Source(source)
        if _users[identifier].Numofcharacters() <= 0 then
            TriggerEvent("vorp_CreateNewCharacter", source)
        else
            if Config["MaxCharacters"] == 1 and _users[identifier].Numofcharacters() <= 1 then
                TriggerEvent("vorp_SpawnUniqueCharacter", source)
            else
                TriggerEvent("vorp_GoToSelectionMenu", source)
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

--Loop to save all players
--each 5 minutes maybe add config for this? and toggle?


local lastSaveTime = GetGameTimer();
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if (GetGameTimer() - lastSaveTime > (1000 * 60) * 5) then
            for k,v in pairs(_users) do
                v.SaveUser()
            end
          lastSaveTime = GetGameTimer();
        end
    end
end)

AddEventHandler('playerDropped', function()
    local identifier = GetSteamID(source)
    --SaveCoordsDB.LastCoordsInCache.Remove(player);
    if _users[identifier] and not _usersLoading[identifier] then
        _users[identifier].SaveUser()
        _users[identifier] = nil
        print(string.format("Saved player %s.", GetPlayerName(source)))
    end
end)



AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if eventData.secondsRemaining == 60 then
        CreateThread(function()
            Wait(45000)
            for k,v in pairs(_users) do
                v.SaveUser()
            end
        end)
    end
end)

--[[ RegisterCommand('saveserver', function(source, args)
    if source == 0 then
        for k,v in pairs(_users) do
            v.SaveUser()
        end
    end
    print("Saving all users")
end)

RegisterCommand('saveme', function(source, args)
    local identifier = GetSteamID(source)
    if _users[identifier] and not _usersLoading[identifier] then
        _users[identifier].SaveUser()
        print(string.format("Saved player WITH COMMAND %s.", GetPlayerName(source)))
    end
end) ]]

--[[ AddEventHandler("onResourceStop",function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for k,v in pairs(_users) do
            v.SaveUser()
        end
    end
end) ]]