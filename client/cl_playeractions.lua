function TeleportToCoords(x, y, z, heading)
    local playerPedId = PlayerPedId()
    SetEntityCoords(playerPedId, x, y, z, true, true, true, false)
    if heading ~= nil then SetEntityHeading(playerPedId, heading) end
end