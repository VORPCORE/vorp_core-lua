---@class ClientRPC @Callback class
---@field name string callback name
---@field _callback fun(any) | fun(cb: fun(data: any), ...) trigger or register
---@field uniqueId string callback unique id
ClientRPC = {}
ClientRPC.__index = ClientRPC
ClientRPC.__call = function()
    return "ClientRPC"
end

local TriggeredCalls = {}
local callBackId = 0

ClientRPC.Callback = {}

function ClientRPC:New(name, callback)
    local self = setmetatable({}, ClientRPC)
    self.name = name
    self._callback = callback
    self.uniqueId = ""
    return self
end

function ClientRPC:TriggerRpcAsync(...)
    if not self.name and type(self.name) ~= "string" then
        return error("Callback name must be a string!", 1)
    end

    callBackId = callBackId + 1
    if callBackId >= 65565 then
        callBackId = 0
        TriggeredCalls = {}
    end

    self.uniqueId = self.name .. tostring(callBackId)

    TriggerServerEvent("vorp:TriggerServerCallback", self.name, self.uniqueId, false, ...)

    TriggeredCalls[self.uniqueId] = self._callback
end

function ClientRPC:TriggerRpcAwait(...)
    if not self.name and type(self.name) ~= "string" then
        return error("Callback name must be a string!", 1)
    end

    callBackId = callBackId + 1
    if callBackId >= 65565 then
        callBackId = 0
        TriggeredCalls = {}
    end

    self.uniqueId = self.name .. tostring(callBackId)

    TriggerServerEvent("vorp:TriggerServerCallback", self.name, self.uniqueId, true, ...)

    local promise = promise.new()
    TriggeredCalls[self.uniqueId] = promise

    local result = Citizen.Await(promise)
    return result
end

function ClientRPC.ExecuteRpc(uniqueId, isSync, name, ...)
    if not TriggeredCalls[uniqueId] then
        return error("ERROR: No callback with this id found! callback name: " .. name, 1)
    end
    if not isSync then
        TriggeredCalls[uniqueId](...)
    else
        TriggeredCalls[uniqueId]:resolve(...)
    end

    TriggeredCalls[uniqueId] = nil
end

RegisterNetEvent('vorp:ServerCallback', ClientRPC.ExecuteRpc)


--- * Trigger a callback Asynchronously
---@param name string callback name
---@param callback fun(any) callback function
---@param ... any callback parameters tables strings numbers etc
function ClientRPC.Callback.TriggerAsync(name, callback, ...)
    local trigger = ClientRPC:New(name, callback)
    trigger:TriggerRpcAsync(...)
end

--- * Trigger a callback Synchronously
---@param name string callback name
---@param ... any callback parameters tables strings numbers etc
---@return any callback return
function ClientRPC.Callback.TriggerAwait(name, ...)
    local trigger = ClientRPC:New(name, nil)
    return trigger:TriggerRpcAwait(...)
end

AddEventHandler('vorp:ExecuteServerCallBack', ClientRPC.Callback.TriggerAsync)


--* REGISTER CLIENT CALLBACKS

local RegisteredCalls = {}

function ClientRPC:Trigger(uniqueId, isSync, ...)
    if not self._callback then
        return error("Callback " .. self.name .. " does not exist. Make sure it's registered in the server side.", 1)
    end

    self._callback(function(...)
        TriggerServerEvent("vorp:ServerCallback", uniqueId, isSync, self.name, ...)
    end, ...)
end

RegisterNetEvent("vorp:TriggerServerCallback", function(name, uniqueId, isSync, ...)
    if not RegisteredCalls[name] then
        return error("Callback " .. name .. " hasn't been registered.", 1)
    end

    RegisteredCalls[name]:Trigger(uniqueId, isSync, ...)
end)

--- * Register a callback
---@param name string callback name
---@param callback fun( func:fun(any),any) callback function
function ClientRPC.Callback.Register(name, callback)
    if not name and type(name) ~= "string" then
        return error("Callback name must be a string!", 1)
    end

    RegisteredCalls[name] = ClientRPC:New(name, callback)
end

-- Export
exports("ClientRpcCall", function()
    return ClientRPC
end)
