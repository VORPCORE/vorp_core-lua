--TX ADMIN HEAL EVENT
AddEventHandler('txAdmin:events:healedPlayer', function(eventData)
    if GetInvokingResource() ~= "monitor" or type(eventData) ~= "table" or type(eventData.id) ~= "number" then
        return
    end
    local Player = eventData.id
    if Player ~= -1 then
        local identifier = GetSteamID(Player)
        local Character = _users[identifier].GetUsedCharacter()
        if Character and Character.isdead then
            TriggerClientEvent("vorp:TipRight", Player, Translation[Lang].Notify.healself, 4000)
            TriggerClientEvent('vorp:resurrectPlayer', Player)
            TriggerClientEvent('vorp:heal', Player)
        end
    else
        TriggerClientEvent("vorp:TipRight", -1, Translation[Lang].Notify.healall, 4000)
        TriggerClientEvent('vorp:resurrectPlayer', -1)
        TriggerClientEvent('vorp:heal', -1)
    end
end)

RegisterNetEvent('vorp:ImDead', function(isDead)
    local source = source
    local identifier = GetSteamID(source)
    if identifier and _users[identifier] then
        _users[identifier].GetUsedCharacter().setDead(isDead)
    end
end)

RegisterServerEvent('vorp:SaveDate')
AddEventHandler('vorp:SaveDate', function()
    local _source = source
    local identifier = GetSteamID(_source)
    local Character = _users[identifier].GetUsedCharacter()
    local charid = Character.charIdentifier
    MySQL.update("UPDATE characters SET LastLogin =NOW() WHERE charidentifier =@charidentifier", { charidentifier = charid })
end)
