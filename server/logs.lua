--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------- DISCORD --------------------------------------------------------

RegisterServerEvent('vorp_core:addWebhook')
AddEventHandler('vorp_core:addWebhook', function(title, webhook, description, color, name, logo, footerlogo, avatar)
    PerformHttpRequest(webhook, function(err, text, headers)
    end, 'POST', json.encode({
        embeds = {
            {
                ["color"] = (not color or color == "") and Config.webhookColor or color,
                ["author"] = {
                    ["name"] = (not name or name == "") and Config.webhookName or name,
                    ["icon_url"] = (not logo or logo == "") and Config.webhookLogo or logo,
                },
                ["title"] = title,
                ["description"] = description,
                ["footer"] = {
                    ["text"] = "VORPcore" .. " • " .. os.date("%x %X %p"),
                    ["icon_url"] = (not footerlogo or footerlogo == "") and Config.webhookFooter or footerlogo,

                },
            },

        },
        avatar_url = avatar or Config.Avatar
    }), {
        ['Content-Type'] = 'application/json'
    })
end)
