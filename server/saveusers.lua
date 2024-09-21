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
