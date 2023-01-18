--=============================== CALBACKS =====================================--
local ServerCallBacks = {}
local RequestId = 0

RegisterNetEvent('vorp:ExecuteServerCallBack')

---comment
---@param name string
---@param ncb table
---@param args any
AddEventHandler('vorp:ExecuteServerCallBack', function(name, ncb, args)

    ServerCallBacks[RequestId] = ncb
    TriggerServerEvent("vorp:TriggerServerCallback", name, RequestId, args)

    if RequestId < 65565 then
        RequestId = RequestId + 1
    else
        RequestId = 0
        ServerCallBacks = {}
    end
end)

---comment
---@param requestId number
---@param args any
RegisterNetEvent('vorp:ServerCallback', function(requestId, args)

    if ServerCallBacks[requestId] then
        ServerCallBacks[requestId](args)
        ServerCallBacks[requestId] = nil
    end
end)

--===========================================================================--
