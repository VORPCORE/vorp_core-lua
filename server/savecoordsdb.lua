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


CreateThread(function()
    while true do
        for k, v in pairs(_users) do
            if v.usedCharacterId and v.usedCharacterId ~= -1 then
                if Player(v.source).state.IsInSession then
                    v.SaveUser()
                end
            end
        end
        Wait(Config.savePlayersTimer * 60000)
    end
end)
