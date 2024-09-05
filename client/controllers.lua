RegisterNetEvent('vorp:deleteVehicle')
RegisterNetEvent('vorp:delHorse')
AddEventHandler('vorp:deleteVehicle', CoreAction.Admin.DeleteVehicleInRadius)
AddEventHandler('vorp:delHorse', CoreAction.Admin.DeleteHorse)
RegisterNetEvent('vorp:teleportWayPoint', CoreAction.Admin.TeleportToWayPoint)
RegisterNetEvent('vorp_core:Client:OnPlayerHeal', CoreAction.Admin.HealPlayer)
RegisterNetEvent('vorp_core:Client:OnPlayerRespawn', function(param)
    CoreAction.Player.RespawnPlayer(param)
end)
RegisterNetEvent('vorp_core:Client:OnPlayerRevive', function(bool)
    bool = bool or true
    CoreAction.Player.ResurrectPlayer(false, nil, bool)
end)


---@deprecated
RegisterNetEvent("vorp:Heal", function()
    print("^3 vorp:Heal is deprecated, use vorp_core:Client:OnPlayerHeal instead^7")
end)

RegisterNetEvent("vorp_core:respawnPlayer", function()
    print("^3 vorp_core:respawnPlayer is deprecated, use vorp_core:Client:OnPlayerRespawn instead^7")
end)

RegisterNetEvent('vorp:resurrectPlayer', function(just)
    print("^3 vorp:resurrectPlayer is deprecated, use vorp_core:Client:OnPlayerRevive instead^7")
end)
