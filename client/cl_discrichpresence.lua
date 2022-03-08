-- Rich Presence Discord for RedM
-- read the readme.txt for instructions
local playercount
Citizen.CreateThread(function()
	while true do
       
		SetDiscordAppId(Config.appid)

        
		SetDiscordRichPresenceAsset(Config.biglogo)


        SetDiscordRichPresenceAssetText(Config.biglogodesc)
       
        
        SetDiscordRichPresenceAssetSmall(Config.smalllogo)

        -- hover text for the "small" icon.(OPTIONAL)
        SetDiscordRichPresenceAssetSmallText(Config.smalllogodesc)

        SetDiscordRichPresenceAction(0, "Join Discord", Config.discordlink)
        
        TriggerServerEvent("syn_rich:getplayers")
        while playercount == nil do 
            Wait(500)
        end
        if Config.shownameandid then
            local pId = GetPlayerServerId(PlayerId())
            local pName = GetPlayerName(PlayerId())    
            SetRichPresence(playercount.."/"..Config.maxplayers.." - ID: "..pId.." | "..pName)
        else
            SetRichPresence(playercount.."/"..Config.maxplayers)
        end
		Citizen.Wait(60000) -- 1 min update
        playercount = nil
	end
end)


RegisterNetEvent("syn_rich:update")
AddEventHandler("syn_rich:update", function(x)
	playercount = x
end)