local characters = {}
VorpCore = {}

TriggerEvent("getCore", function(core)
    VorpCore = core
end)

function LoadCharacter(identifier, character)
    characters[identifier] = character
end

RegisterNetEvent('vorp:playerSpawn', function()
    local source = source
    local sid = GetSteamID(source)

    if characters[sid] == nil then
        characters[sid] = Character(source, sid, nil, "user", "unemployed", nil, nil, nil, "{}")

        TriggerClientEvent("vorpcharacter:createPlayer", source)
    else
        local pos = json.decode(characters[sid].Coords())

        if pos ~= nil and pos['x'] ~= nil then
            TriggerClientEvent("vorp:initPlayer", source, vector3(pos["x"], pos["y"], pos["z"]), pos["heading"],
                characters[sid].IsDead())
        end

        characters[sid].source = source

        -- Send Nui Update UI all
        characters[sid].updateCharUi()
    end
end)

RegisterNetEvent('vorp:UpdateCharacter', function(steamId, firstname, lastname)
    characters[steamId].Firstname(firstname)
    characters[steamId].Lastname(lastname)
end)

AddEventHandler('txAdmin:events:healedPlayer', function(eventData)
    if GetInvokingResource() ~= "monitor" or type(eventData) ~= "table" or type(eventData.id) ~= "number" then
        return
    end
    local Player = eventData.id
    if Player ~= -1 then
        local identifier = GetSteamID(Player)
        local xCharacter = _users[identifier].GetUsedCharacter()
        if xCharacter and xCharacter.isdead then

            TriggerClientEvent("vorp:ShowBasicTopNotification", Player, "You Revived Yourself.", 4000)
            TriggerClientEvent('vorp:resurrectPlayer', Player)
            TriggerClientEvent('vorp:heal', Player)
        end
    else
        TriggerClientEvent("vorp:ShowBasicTopNotification", -1, "You Have Been Healed.", 4000)
        TriggerClientEvent('vorp:resurrectPlayer', -1)
        TriggerClientEvent('vorp:heal', -1)
    end
end)

RegisterNetEvent('vorp:ImDead', function(isDead)
    local source = source
    local identifier = GetSteamID(source)

    if _users[identifier] then
        _users[identifier].GetUsedCharacter().setDead(isDead)
    end
end)

RegisterServerEvent('vorp:SaveDate')
AddEventHandler('vorp:SaveDate', function()
    local _source = source
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local charid = Character.charIdentifier
    MySQL.update("UPDATE characters SET LastLogin =NOW() WHERE charidentifier =@charidentifier",
        { charidentifier = charid })
end)
