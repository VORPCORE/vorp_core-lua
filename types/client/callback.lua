---@class ClientCallBack @CallBack ClientRPC
---@field TriggerAwait fun(name:string, ...?)
---@field TriggerAsync fun(name:string, callback: fun(any), ...?)
---@field Register fun(name: string, callback: fun(callback: fun(any), ...?))
--- * `CLIENT` see vorpcore >> [documentation](https://vorpcore.github.io/VORP_Documentation/api/core#cient) << for more information
function exports.vorp_core:ClientRpcCall() end
