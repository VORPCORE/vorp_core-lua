--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------- DISCORD --------------------------------------------------------

function Discord(webhook, title, description, text, color)
    if Config.Logs then

        PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
            embeds = {
                {
                    ["color"] = Config.webhookColor,
                    ["author"] = {
                        ["name"] = Config.name,
                        ["icon_url"] = Config.logo
                    },
                    ["title"] = title,
                    ["description"] = description,
                    ["footer"] = {
                        ["text"] = "VORPcore" .. " • " .. os.date("%x %X %p"),
                        ["icon_url"] = Config.footerLogo,

                    },
                },

            },
            avatar_url = Config.Avatar
        }), {
            ['Content-Type'] = 'application/json'
        })
    end
end

function GetIdentity(source, identity)
    local num = 0
    local num2 = GetNumPlayerIdentifiers(source)

    if GetNumPlayerIdentifiers(source) > 0 then
        local ident = nil
        while num < num2 and not ident do
            local a = GetPlayerIdentifier(source, num)
            if string.find(a, identity) then ident = a end
            num = num + 1
        end
        return ident;
    end
end

RegisterServerEvent('vorp:setgroupWebhook')
AddEventHandler('vorp:setgroupWebhook', function(title, description, text, color)
    Discord(Config.SetgroupWebhook, title, description, text, color)
end)

RegisterServerEvent('vorp:addmoneyWebhook')
AddEventHandler('vorp:addmoneyWebhook', function(title, description, text, color)
    Discord(Config.AddmoneyWebhook, title, description, text, color)
end)

RegisterServerEvent('vorp:setjobWebhook')
AddEventHandler('vorp:setjobWebhook', function(title, description, text, color)
    Discord(Config.SetjobWebhook, title, description, text, color)
end)

RegisterServerEvent('vorp:delMoneyWebhook')
AddEventHandler('vorp:delMoneyWebhook', function(title, description, text, color)
    print("advent")
    Discord(Config.DelMoneyWebhook, title, description, text, color)
end)


RegisterServerEvent('vorp:addItemsWebhook')
AddEventHandler('vorp:addItemsWebhook', function(title, description, text, color)
    Discord(Config.AddItemsWebhook, title, description, text, color)
end)

RegisterServerEvent('vorp:addWeaponsWebhook')
AddEventHandler('vorp:addWeaponsWebhook', function(title, description, text, color)
    Discord(Config.AddWeaponsWebhook, title, description, text, color)
end)

RegisterServerEvent('vorp:reviveWebhook')
AddEventHandler('vorp:reviveWebhook', function(title, description, text, color)
    Discord(Config.ReviveWebhook, title, description, text, color)
end)

RegisterServerEvent('vorp:tpmWebhook')
AddEventHandler('vorp:tpmWebhook', function(title, description, text, color)
    Discord(Config.TpmWebhook, title, description, text, color)
end)

RegisterServerEvent('vorp:delWagonWebhook')
AddEventHandler('vorp:delWagonWebhook', function(title, description, text, color)
    Discord(Config.DelWagonsWebhook, title, description, text, color)
end)

RegisterServerEvent('vorp:delHorseWebhook')
AddEventHandler('vorp:delHorseWebhook', function(title, description, text, color)
    Discord(Config.DelHorseWebhook, title, description, text, color)
end)

RegisterServerEvent('vorp:healPlayerWebhook')
AddEventHandler('vorp:healPlayerWebhook', function(title, description, text, color)
    Discord(Config.HealPlayerWebhook, title, description, text, color)
end)
-----------------------------------------------------------------------------------------------------------------------
------------------------------------------------ RICH PRESENCE --------------------------------------------------------
RegisterServerEvent("vorprich:getplayers")
AddEventHandler("vorprich:getplayers", function()
    local playerCount = #GetPlayers()
    TriggerClientEvent("vorprich:update", source, playerCount)
end)
