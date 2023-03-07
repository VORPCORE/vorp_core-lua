Namedinstances = {}

RegisterServerEvent("vorp_core:instanceplayers")
AddEventHandler("vorp_core:instanceplayers", function(setName)
    local _source = source
    local instanceSource = setName ~= 0 and setName or nil

    for k, v in pairs(Namedinstances) do
        for k2, v2 in pairs(v.people) do
            if v2 == _source then
                table.remove(v.people, k2)
                break
            end
        end
        if #v.people == 0 then
            Namedinstances[k] = nil
        end
    end

    if instanceSource ~= nil then
        while Namedinstances[instanceSource] and #Namedinstances[instanceSource].people >= 1 do
            Wait(1)
        end

        if not Namedinstances[instanceSource] then
            Namedinstances[instanceSource] = {
                name = setName,
                people = {}
            }
        end

        table.insert(Namedinstances[instanceSource].people, _source)
    end

    SetPlayerRoutingBucket(_source, instanceSource)
end)

-- credits to MrDankKetchup
