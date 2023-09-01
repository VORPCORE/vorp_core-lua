CreateThread(function()
    while true do
        SetDiscordAppId(Config.appid)
        SetDiscordRichPresenceAsset(Config.biglogo)
        SetDiscordRichPresenceAssetText(Config.biglogodesc)
        SetDiscordRichPresenceAssetSmall(Config.smalllogo)
        SetDiscordRichPresenceAssetSmallText(Config.smalllogodesc)
        SetDiscordRichPresenceAction(0, Config.richpresencebutton, Config.discordlink)
        local playercount = ClientRPC.Callback.TriggerAwait("vorp:richpresence:callback:getplayers", {})

        if Config.shownameandid then
            local pId = GetPlayerServerId(PlayerId())
            local pName = GetPlayerName(PlayerId())
            SetRichPresence(playercount .. "/" .. Config.maxplayers .. " - ID: " .. pId .. " | " .. pName)
        else
            SetRichPresence(playercount .. "/" .. Config.maxplayers)
        end
        Wait(60000) -- 1 min update
    end
end)
