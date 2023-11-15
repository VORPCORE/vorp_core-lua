--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------- DISCORD --------------------------------------------------------


function GetIdentity(source, identity)
    local num = 0
    if not source then return end
    
    local num2 = GetNumPlayerIdentifiers(source)

    if GetNumPlayerIdentifiers(source) > 0 then
        local ident = nil
        while num < num2 and not ident do
            local a = GetPlayerIdentifier(source, num)
            if string.find(a, identity) then ident = a end
            num = num + 1
        end
        --return ident;
        if ident == nil then
            return ""
        end
        return string.sub(ident, 9)
    end
end

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
