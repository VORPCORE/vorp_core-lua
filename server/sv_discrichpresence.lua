
RegisterServerEvent("syn_rich:getplayers")
AddEventHandler("syn_rich:getplayers", function()
local playerCount = #GetPlayers()
TriggerClientEvent("syn_rich:update",source,playerCount)
end)