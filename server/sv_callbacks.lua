ServerCallBacks = {}

RegisterNetEvent('vorp:addNewCallBack', function(name, ncb)
    ServerCallBacks[name] = ncb
end)

RegisterNetEvent('vorp:TriggerServerCallback', function(name, requestId, args)
    local source = source
    
    if ServerCallBacks[name] then
        ServerCallBacks[name](source, function(data)
            TriggerClientEvent("vorp:ServerCallback", source, requestId, data)
        end, args)
    else
        print('Callback ' .. name .. ' does not exist.')
    end
end)

