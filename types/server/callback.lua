---@class CallBack CallBack ServerRPC
---@field TriggerAwait fun(name:string, source:number, ...?) @Trigger a callback and wait for the response Synchronously
---@field TriggerAsync fun(name:string, source:number, callback: fun(any), ...?) @Trigger a callback Asynchronously
---@field Register fun(name: string, callback: fun(source:number,callback: fun(any), ...?)) @Register a callback
--- * `SERVER` see vorpcore >> [documentation](https://vorpcore.github.io/VORP_Documentation/api/core#server) << for more information
function exports.vorp_core:ServerRpcCall() end
