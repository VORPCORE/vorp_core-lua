LastCoordsInCache = {}

RegisterNetEvent('vorp:saveLastCoords', function(lastCoords, lastHeading)
    local source = source
    local identifier = GetSteamID(source)
    local user = _users[identifier] or nil

    LastCoordsInCache[source] = { lastCoords, lastHeading }

    local characterCoords = json.encode({ x = math.floor(lastCoords.x) + 0.0, y = math.floor(lastCoords.y) + 0.0, z = math.floor(lastCoords.z) + 0.0, heading = math.floor(lastHeading) + 0.0 })
    if user then

      local used_char = user.GetUsedCharacter() or nil

      if used_char then
        used_char.Coords(characterCoords)
      end
    end
end)

RegisterNetEvent('vorp:SaveHours', function()
    local hoursupdate = tonumber(0.5)  -- Just to be sure is giving numbers =D
    local source = source
    local identifier = GetSteamID(source)
    local user = _users[identifier] or nil
    if user then

      local used_char = user.GetUsedCharacter() or nil

      if used_char then
        used_char.UpdateHours(hoursupdate)
      end
    end
end)