
RegisterServerEvent("vorprich:getplayers")
AddEventHandler("vorprich:getplayers", function()
local playerCount = #GetPlayers()
TriggerClientEvent("vorprich:update",source,playerCount)
end)
