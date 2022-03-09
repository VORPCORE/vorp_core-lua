local LastCoordsInCache = {}
        
RegisterNetEvent('vorp:saveLastCoords', function(lastCoords, lastHeading)
    local source = source
    local identifier = GetSteamID(source)

    LastCoordsInCache[source] = {lastCoords, lastHeading}

    local xx = lastCoords.x
    local yy = lastCoords.y
    local zz = lastCoords.z
    local hh = lastHeading
    
    local characterCoords = json.encode({x = math.floor(xx)+0.0, y = math.floor(yy)+0.0, z = math.floor(zz)+0.0, heading = math.floor(hh)+0.0})

    _users[identifier].GetUsedCharacter().Coords(characterCoords)
end)

RegisterNetEvent('vorp:ImDead', function(isDead)
    local source = source
    local identifier = GetSteamID(source)

    if _users[identifier] then
        _users[identifier].GetUsedCharacter().setDead(isDead)
    end
end)
