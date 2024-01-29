--============================ SAVE  HOURS ===================================--

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
