function LoadModel(hash)
    if IsModelValid(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            --Debug.WriteLine($"Waiting for model {hash} load!");
            Citizen.Wait(0)
        end
        return true
    else
        --Debug.WriteLine($"Model {hash} is not valid!");
        return false
    end
end

function LoadTexture(hash)
    if not Citizen.InvokeNative(0x7332461FC59EB7EC, texture) then
        Citizen.InvokeNative(0xC1BA29DF5631B0F8, hash)
        while not Citizen.InvokeNative(0x54D6900929CCF162, hash) do
            --Debug.WriteLine($"Waiting for texture {hash} load!");
            Citizen.Wait(0)
        end
        return true
    else
        --Debug.WriteLine($"Texture {hash} is not valid!");
        return false
    end
end

function DrawText(text, font, x, y, fontscale, fontsize, r, g, b, alpha, textcentred, shadow)
    local str = CreateVarString(10, "LITERAL_STRING", text)
    SetTextScale(fontscale, fontsize)
    SetTextColor(r, g, b, alpha)
    SetTextCentre(textcentred)
    if shadow then SetTextDropshadow(1, 0, 0, 0, 255) end
    SetTextFontForCurrentCommand(font)
    DisplayText(str, x, y)
end
