CreateThread(function()
    local maxplayers = GetConvarInt('sv_maxClients', 48)
    SetDiscordAppId(Config.appid)
    SetDiscordRichPresenceAsset(Config.biglogo)
    SetDiscordRichPresenceAssetText(Config.biglogodesc)
    SetDiscordRichPresenceAssetSmall(Config.smalllogo)
    SetDiscordRichPresenceAssetSmallText(Config.smalllogodesc)
    if Config.Buttons and type(Config.Buttons) == "table" then
        for k, v in pairs(Config.Buttons) do
            SetDiscordRichPresenceAction(k - 1, v.text, v.url)
        end
    end

    while true do
        local playercount = ClientRPC.Callback.TriggerAwait("vorp:richpresence:callback:getplayers", {})
        if Config.shownameandid then
            local pId = GetPlayerServerId(PlayerId())
            local pName = GetPlayerName(PlayerId())
            SetRichPresence(playercount .. "/" .. maxplayers .. " - ID: " .. pId .. " | " .. pName)
        else
            SetRichPresence(playercount .. "/" .. maxplayers)
        end
        Wait(60000) -- 1 min update
    end
end)
