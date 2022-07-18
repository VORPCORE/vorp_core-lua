local characters = {}

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
            TriggerClientEvent("vorp:initPlayer", source, vector3(pos["x"], pos["y"], pos["z"]), pos["heading"], characters[sid].IsDead())
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
