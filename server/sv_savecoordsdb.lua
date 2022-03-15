local LastCoordsInCache = {}
        
RegisterNetEvent('vorp:saveLastCoords', function(lastCoords, lastHeading)
    local source = source
    local identifier = GetSteamID(source)

    LastCoordsInCache[source] = {lastCoords, lastHeading}
    
    local characterCoords = json.encode({x = math.floor(lastCoords.x)+0.0, y = math.floor(lastCoords.y)+0.0, z = math.floor(lastCoords.z)+0.0, heading = math.floor(lastHeading)+0.0})

    _users[identifier].GetUsedCharacter().Coords(characterCoords)
end)

RegisterNetEvent('vorp:ImDead', function(isDead)
    local source = source
    local identifier = GetSteamID(source)

    if _users[identifier] then
        _users[identifier].GetUsedCharacter().setDead(isDead)
    end
end)
