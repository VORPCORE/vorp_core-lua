LastCoordsInCache = {}

RegisterNetEvent('vorp:saveLastCoords', function(lastCoords, lastHeading)
    local source = source
    local identifier = GetSteamID(source)

    LastCoordsInCache[source] = { lastCoords, lastHeading }

    local characterCoords = json.encode({ x = math.floor(lastCoords.x) + 0.0, y = math.floor(lastCoords.y) + 0.0, z = math.floor(lastCoords.z) + 0.0, heading = math.floor(lastHeading) + 0.0 })
    if _users[identifier] then
        _users[identifier].GetUsedCharacter().Coords(characterCoords)
    end
end)

RegisterNetEvent('vorp:ImDead', function(isDead)
    local source = source
    local identifier = GetSteamID(source)

    if _users[identifier] then
        _users[identifier].GetUsedCharacter().setDead(isDead)
    end
end)

RegisterNetEvent('vorp:SaveHours', function()
    local hoursupdate = tonumber(0.5)  -- Just to be sure is giving numbers =D
    local source = source
    local identifier = GetSteamID(source)
    if _users[identifier] then
        _users[identifier].GetUsedCharacter().UpdateHours(hoursupdate)
    end
end)
