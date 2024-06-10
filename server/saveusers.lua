CreateThread(function()
    if not Config.SavePlayersHours then return end
    while true do
        for _, v in pairs(_users) do
            if v.usedCharacterId and v.usedCharacterId ~= -1 then
                if Player(v.source).state.IsInSession then
                    local user = v.GetUsedCharacter()
                    user.UpdateHours(0.5)
                end
            end
        end
        Wait(60000 * 5) -- every 5 minutes
    end
end)

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
