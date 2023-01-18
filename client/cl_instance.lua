--DEPRECATED WILL BE REMOVE
RegisterNetEvent('vorp:setInstancePlayer', function(instance)
    print("DONT USE THIS 1^DEPRECATED")
    if instance then
        NetworkStartSoloTutorialSession()
    else
        NetworkEndTutorialSession()
    end
end)
