local activeVoiceChat = Config["ActiveVoiceChat"]
local voiceRange = Config["VoiceRanges"]
local voiceRangeSelected = Config["DefaultVoiceRange"]
local keyRange = Config["KeySwapVoiceRange"]

Citizen.CreateThread(function()
    while activeVoiceChat do
        if IsControlJustPressed(0, keyRange) then
            voiceRangeSelected = (voiceRangeSelected + 1) % #voiceRange
            TriggerEvent("vorp:TipRight", string.format(Config.Langs["VoiceRangeChanged"], voiceRangeSelected), 4000)
            N_0x08797a8c03868cb8(voiceRange[voiceRangeSelected]) --Threshold?
            N_0xec8703e4536a9952() --??
            N_0x58125b691f6827d5(voiceRange[voiceRangeSelected]) --Range?
        end

        if IsControlPressed(0, keyRange) then
            local playerCoords = GetEntityCoords(PlayerPedId(), true, true)
            DrawMarker(0x94FDAE17, playerCoords.x, playerCoords.y, playerCoords.z - 0.5, 0.0, 0.0, 0.0, 0, 0.0, 0.0, voiceRange[voiceRangeSelected], voiceRange[voiceRangeSelected], 1.0, 255, 179, 38, 200, false, true, 2, false, false, false, false)
        end

        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while activeVoiceChat do
        N_0x08797a8c03868cb8(voiceRange[voiceRangeSelected]) --Threshold?
        N_0xec8703e4536a9952() --??
        N_0x58125b691f6827d5(voiceRange[voiceRangeSelected]) --Range?
        
        Citizen.Wait(10000)
    end
end)
