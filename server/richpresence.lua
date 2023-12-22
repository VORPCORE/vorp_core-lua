-- get player count from server
ServerRPC.Callback.Register("vorp:richpresence:callback:getplayers", function(source, callback)
    local pCount = #GetPlayers()
    callback(pCount)
end)
