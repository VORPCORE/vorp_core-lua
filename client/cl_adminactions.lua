------------------------------------------------------------------------------------------------------------
--------------------------------------------- ADMIN ACTIONS ------------------------------------------------



function TeleportAndFoundGroundAsync(tpCoords)
    local groundZ = 0.0
    local foundGround = false
    local wayPoint = GetWaypointCoords()
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



function TeleportToWaypoint()
	local player = PlayerPedId()
	local wayPoint = GetWaypointCoords()

	if (wayPoint.x == 0 and wayPoint.y == 0) then
        TriggerEvent("vorp:TipRight", Config.Langs.wayPoint, 3000) 
	else

       
        local height = 1

        for height = 1, 1000 do
            SetEntityCoords(player, wayPoint.x, wayPoint.y, height + 0.0)
            local foundground, groundZ, normal = GetGroundZAndNormalFor_3dCoord(wayPoint.x, wayPoint.y, height + 0.0)
            if foundground then
                SetEntityCoords(player, wayPoint.x, wayPoint.y, height + 0.0)
                
                break
            end
            Wait(25)
        end

     
	end
end


local distanceToCheck = 5.0
local numRetries = 5

function DeleteGivenVehicle( wagon, timeoutMax )
    local timeout = 0 

    SetEntityAsMissionEntity( wagon, true, true )
    DeleteVehicle( wagon )

    if ( DoesEntityExist( wagon ) ) then
		TriggerEvent("vorp:TipRight", "VORP: Failed to delete wagon, trying again...", 4000)
        
        while ( DoesEntityExist( wagon ) and timeout < timeoutMax ) do 
            DeleteVehicle( wagon )
            if ( not DoesEntityExist( wagon ) ) then 
			TriggerEvent("vorp:TipRight", "VORP: Vehicle deleted.", 4000)
            end 

            timeout = timeout + 1 
            Citizen.Wait( 500 )

            if ( DoesEntityExist( wagon ) and ( timeout == timeoutMax - 1 ) ) then
				TriggerEvent("vorp:TipRight", "VORP: Failed to delete wagon after " .. timeoutMax .. " retries.", 4000)
            end 
        end 
   
    end 
end 


function GetVehicleInDirection( entFrom, coordFrom, coordTo )
	local rayHandle = StartShapeTestRay( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, -1, entFrom, 7 )
    local _, _, _, _, wagon = GetShapeTestResult( rayHandle )
    if ( IsEntityAVehicle( wagon) ) then 
        return wagon
    end 
end



RegisterNetEvent('vorp:delWagon')
AddEventHandler('vorp:delWagon', function()
    local player = PlayerPedId()
   

    if ( DoesEntityExist( player ) and not IsEntityDead( player ) ) then 
        local pos = GetEntityCoords( player )

        if ( IsPedSittingInAnyVehicle( player ) ) then 
            local wagon = GetVehiclePedIsIn( player, false )

            if ( GetPedInVehicleSeat( wagon, -1 ) == player ) then 
                DeleteGivenVehicle( wagon, numRetries )
            else 
				TriggerEvent("vorp:TipRight", Config.Langs.mustBeSeated, 4000) 
            end 
        else
            local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords( player, 0.0, distanceToCheck, 0.0 )
            local wagon = GetVehicleInDirection( player, pos, inFrontOfPlayer )
            if ( DoesEntityExist( wagon ) ) then 
                DeleteGivenVehicle( wagon, numRetries )
            else 
				TriggerEvent("vorp:TipRight", Config.Langs.wagonInFront, 4000) 
            end 
        end 
    end 
end)


RegisterNetEvent('vorp:delHorse')
AddEventHandler('vorp:delHorse', function()
	local player = PlayerPedId()
    local mount   = GetMount(player)
    if IsPedOnMount(player) then
        DeleteEntity(mount)
    
    end
end)


RegisterNetEvent('vorp:teleportWayPoint')
AddEventHandler('vorp:teleportWayPoint', function(WayPoint)
	TeleportToWaypoint()
end)