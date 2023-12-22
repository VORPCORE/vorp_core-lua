--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------- DISCORD --------------------------------------------------------

RegisterServerEvent('vorp_core:addWebhook')
AddEventHandler('vorp_core:addWebhook', function(title, webhook, description, color, name, logo, footerlogo, avatar)
    PerformHttpRequest(webhook, function(err, text, headers)
    end, 'POST', json.encode({
        embeds = {
            {
                ["color"] = color or Config.webhookColor,
                ["author"] = {
                    ["name"] = name or Config.name,
                    ["icon_url"] = logo or Config.logo,
                },
                ["title"] = title,
                ["description"] = description,
                ["footer"] = {
                    ["text"] = "VORPcore" .. " • " .. os.date("%x %X %p"),
                    ["icon_url"] = footerlogo or Config.footerLogo,

                },
            },

        },
        avatar_url = avatar or Config.Avatar
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
