-- events for admin actions
RegisterNetEvent('vorp:deleteVehicle')
AddEventHandler('vorp:deleteVehicle', CoreAction.Admin.DeleteVehicleInRadius)

RegisterNetEvent('vorp:delHorse')
AddEventHandler('vorp:delHorse', CoreAction.Admin.DeleteHorse)

RegisterNetEvent('vorp:teleportWayPoint', CoreAction.Admin.TeleportToWayPoint)
RegisterNetEvent('vorp:heal', CoreAction.Admin.HealPlayer)
