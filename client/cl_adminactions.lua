function TeleportAndFoundGroundAsync(tpCoords)
    local groundZ = 0.0
    local normal =  vector3(1.0,1.0,1.0)
    local foundGround = false
    
    for i = 0, 1000 do
        SetEntityCoords(PlayerPedId(), tpCoords.x, tpCoords.y, i, true, true, true, false)
        foundGround = GetGroundZAndNormalFor_3dCoord(tpCoords.x, tpCoords.y, i, groundZ, normal)
        Citizen.Wait(1)
        if foundGround then
            SetEntityCoords(PlayerPedId(), tpCoords.x, tpCoords.y, i, true, true, true, false)
            break
        end
    end
end