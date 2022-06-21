
-------------------------------------------------------------------------------------------------------------
-------------------------------------------- HIDEUI ---------------------------------------------------------
local hideUI = true

RegisterCommand("hideui", function()
    

    if hideUI then
		ExecuteCommand("togglechat")
        DisplayRadar(false)
        TriggerEvent("syn_displayrange", false)
        TriggerEvent("vorp:showUi", false)
        hideUI = false
    else
		ExecuteCommand("togglechat")
        DisplayRadar(true)
		TriggerEvent("syn_displayrange", true)
        TriggerEvent("vorp:showUi", true)
        hideUI = true
    end
end,false)

TriggerEvent("chat:addSuggestion","/hideui", " VORPcore command to HIDE all UI's from screen, nice to take screenshots.")

-------------------------------------------------------------------------------------------------------------
-------------------------------------------- CLEAR PED TASKS ---------------------------------------------------------

RegisterCommand('cleartask', function()
   local player = PlayerPedId()

    ClearPedTasksImmediately(player)

end,false)

TriggerEvent("chat:addSuggestion","/cleartask", " VORPcore command to use if you are stuck on an animation.")

-------------------------------------------------------------------------------------------------------------
-------------------------------------------- PVP Toggle ---------------------------------------------------------
if Config.PVPToggle then
    RegisterCommand("pvp",function()
        pvp = not pvp

        if pvp then
            TriggerEvent("vorp:TipRight", Config.Langs.PVPNotifyOn , 4000)
        else
            TriggerEvent("vorp:TipRight", Config.Langs.PVPNotifyOff , 4000)
        end
    end) 
    TriggerEvent("chat:addSuggestion","/pvp", " VORPcore command to TOGGLE pvp for your character.")
end
-------------------------------------------------------------------------------------------------------------
