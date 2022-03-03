local LastCoordsInCache = {}
        
RegisterNetEvent('vorp:saveLastCoords', function(lastCoords, lastHeading)
    local source = source
    local identifier = GetSteamID(source)

    LastCoordsInCache[source] = {lastCoords, lastHeading}
    
    local characterCoords = json.encode({x = math.floor(lastCoords.x), y = math.floor(lastCoords.y), z = math.floor(lastCoords.z), heading = math.floor(lastHeading)})

    _users[identifier].GetUsedCharacter().Coords(characterCoords)
end)

RegisterNetEvent('vorp:ImDead', function(isDead)
    local source = source
    local identifier = GetSteamID(source)

    if _users[identifier] then
        _users[identifier].GetUsedCharacter().setDead(isDead)
    end
end)
