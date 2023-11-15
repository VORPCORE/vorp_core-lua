--============================ SAVE COORDS AND HOURS ===================================--

--SAVE COORDS
RegisterNetEvent('vorp:saveLastCoords', function(coord, lastHeading)
  local _source = source
  local identifier = GetSteamID(_source)
  local user = _users[identifier] or nil

  if not user then
    return
  end

  local used_char = user.GetUsedCharacter() or nil

  if not used_char then
    return
  end

  local characterCoords = json.encode({ x = coord.x, y = coord.y, z = coord.z, heading = lastHeading })
  used_char.Coords(characterCoords)
end)

--SAVE HOURS
RegisterNetEvent('vorp:SaveHours', function()
  local hoursupdate = tonumber(0.5) -- Just to be sure is giving numbers =D
  local _source = source
  local identifier = GetSteamID(_source)
  local user = _users[identifier] or nil

  if not user then
    return
  end
  local used_char = user.GetUsedCharacter() or nil

  if not used_char then
    return
  end
  used_char.UpdateHours(hoursupdate)
end)
--============================================================================--
