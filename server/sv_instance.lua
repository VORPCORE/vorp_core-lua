
Namedinstances = {}

RegisterServerEvent("vorp_core:instanceplayers")
AddEventHandler("vorp_core:instanceplayers", function(setName)

    local _source = source
    local instanceSource = nil

    if setName == 0 then
        for k, v in pairs(Namedinstances) do
            for k2, v2 in pairs(v.people) do
                if v2 == _source then
                    table.remove(v.people, k2)
                end
            end
            if #v.people == 0 then
                Namedinstances[k] = nil
            end
        end
        instanceSource = setName

    else
        for k, v in pairs(Namedinstances) do
            if v.name == setName then
                instanceSource = k
            end
        end

        if instanceSource == nil then
            instanceSource = setName

            while Namedinstances[instanceSource] and #Namedinstances[instanceSource] >= 1 do
                instanceSource = setName
                Wait(1)
            end
        end
    end

    if instanceSource ~= 0 then

        if not Namedinstances[instanceSource] then
            Namedinstances[instanceSource] = {
                name = setName,
                people = {}
            }
        end

        table.insert(Namedinstances[instanceSource].people, _source)


    end

    SetPlayerRoutingBucket(
        _source,
        instanceSource
    )
end)

-- credits to MrDankKetchup
