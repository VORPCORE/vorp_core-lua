--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------- DISCORD --------------------------------------------------------


function GetIdentity(source, identity)

    for k, v in pairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1, string.len(identity .. ":")) == identity .. ":" then
            return v
        end
    end
end

RegisterServerEvent('vorp_core:addWebhook')
AddEventHandler('vorp_core:addWebhook', function(title, webhook, description, color, name, logo, footerlogo, avatar)


    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        embeds = {
            {
                ["color"] = Config.webhookColor or color,
                ["author"] = {
                    ["name"] = Config.name or name,
                    ["icon_url"] = Config.logo or logo,
                },
                ["title"] = title,
                ["description"] = description,
                ["footer"] = {
                    ["text"] = "VORPcore" .. " • " .. os.date("%x %X %p"),
                    ["icon_url"] = Config.footerLogo or footerlogo,

                },
            },

        },
        avatar_url = Config.Avatar or avatar
    }), {
        ['Content-Type'] = 'application/json'
    })


end)

-----------------------------------------------------------------------------------------------------------------------
------------------------------------------------ RICH PRESENCE --------------------------------------------------------
RegisterServerEvent("vorprich:getplayers")
AddEventHandler("vorprich:getplayers", function()
    local playerCount = #GetPlayers()
    TriggerClientEvent("vorprich:update", source, playerCount)
end)
