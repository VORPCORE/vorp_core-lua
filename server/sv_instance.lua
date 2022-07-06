local instances = {}

RegisterServerEvent("vorp_core:instanceplayer")
AddEventHandler("vorp:core:instanceplayer", function(set)

    local _source = source

    local instanceSource = 0
    if set then
        if set == 0 then
            for k, v in pairs(instances) do
                for k2, v2 in pairs(v) do
                    if v2 == _source then
                        table.remove(v, k2)
                        if #v == 0 then
                            instances[k] = nil
                        end
                    end
                end
            end
        end
        instanceSource = set
    else

        instanceSource = math.random(1, 63)

        while instances[instanceSource] and #instances[instanceSource] >= 1 do
            instanceSource = math.random(1, 63)
            Wait(1)
        end
    end


    if instanceSource ~= 0 then
        if not instances[instanceSource] then
            instances[instanceSource] = {}
        end

        table.insert(instances[instanceSource], _source)
    end

    SetPlayerRoutingBucket(
        _source,
        instanceSource
    )
end)

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
