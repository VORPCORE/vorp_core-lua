--============================= NOTIFICATIONS ==========================================--
RegisterNetEvent('vorp:NotifyLeft')
RegisterNetEvent('vorp:Tip')
RegisterNetEvent('vorp:NotifyTop')
RegisterNetEvent('vorp:TipRight')
RegisterNetEvent('vorp:TipBottom')
RegisterNetEvent('vorp:ShowTopNotification')
RegisterNetEvent('vorp:ShowAdvancedRightNotification')
RegisterNetEvent('vorp:ShowBasicTopNotification')
RegisterNetEvent('vorp:ShowSimpleCenterText')
RegisterNetEvent('vorp:ShowBottomRight')
RegisterNetEvent('vorp:failmissioNotifY')
RegisterNetEvent('vorp:deadplayerNotifY')
RegisterNetEvent('vorp:updatemissioNotify')
RegisterNetEvent('vorp:warningNotify')


AddEventHandler('vorp:NotifyLeft', function(firsttext, secondtext, dict, icon, duration, color)
    LoadTexture(dict)
    exports.vorp_core:DisplayLeftNotification(tostring(firsttext), tostring(secondtext), tostring(dict), tostring(icon)
    , tonumber(duration), (tostring(color) or "COLOR_WHITE"))
end)

AddEventHandler('vorp:Tip', function(text, duration)
    exports.vorp_core:DisplayTip(tostring(text), tonumber(duration))
end)

AddEventHandler('vorp:NotifyTop', function(text, location, duration)
    exports.vorp_core:DisplayTopCenterNotification(tostring(text), tostring(location), tonumber(duration))
end)

AddEventHandler('vorp:TipRight', function(text, duration)
    exports.vorp_core:DisplayRightTip(tostring(text), tonumber(duration))
end)

AddEventHandler('vorp:TipBottom', function(text, duration)
    exports.vorp_core:DisplayObjective(tostring(text), tonumber(duration))
end)

AddEventHandler('vorp:ShowTopNotification', function(tittle, subtitle, duration)
    exports.vorp_core:ShowTopNotification(tostring(tittle), tostring(subtitle), tonumber(duration))
end)

AddEventHandler('vorp:ShowAdvancedRightNotification', function(text, dict, icon, text_color, duration, quality)
    exports.vorp_core:ShowAdvancedRightNotification(tostring(text), tostring(dict), tostring(icon),
        tostring(text_color), tonumber(duration), quality)
end)

AddEventHandler('vorp:ShowBasicTopNotification', function(text, duration)
    exports.vorp_core:ShowBasicTopNotification(tostring(text), tonumber(duration))
end)

AddEventHandler('vorp:ShowSimpleCenterText', function(text, duration)
    exports.vorp_core:ShowSimpleCenterText(tostring(text), tonumber(duration))
end)

AddEventHandler('vorp:ShowBottomRight', function(text, duration)
    exports.vorp_core:showBottomRight(tostring(text), tonumber(duration))
end)

AddEventHandler('vorp:failmissioNotifY', function(title, subtitle, duration)
    exports.vorp_core:failmissioNotifY(tostring(title), tostring(subtitle), tonumber(duration))
end)

AddEventHandler('vorp:deadplayerNotifY', function(title, audioRef, audioName, duration)
    exports.vorp_core:deadplayerNotifY(tostring(title), tostring(audioRef), tostring(audioName), tonumber(duration))
end)


AddEventHandler('vorp:updatemissioNotify', function(utitle, umsg, duration)
    exports.vorp_core:updatemissioNotify(tostring(utitle), tostring(umsg), tonumber(duration))
end)

AddEventHandler('vorp:warningNotify', function(title, msg, audioRef, audioName, duration)
    exports.vorp_core:warningNotify(tostring(title), tostring(msg), tostring(audioRef), tostring(audioName),
        tonumber(duration))
end)

exports("DisplayTip", function(text, duration)
    local string = CreateVarString(10, "LITERAL_STRING", text)
    local Var0 = DataView.ArrayBuffer(8 * 7)
    local Var13 = DataView.ArrayBuffer(8 * 3)
    local Duration = tonumber(duration) or 3000
    Var0:SetUint32(8 * 0, Duration)
    Var0:SetInt32(8 * 1, 0)
    Var0:SetInt32(8 * 2, 0)
    Var0:SetInt32(8 * 3, 0)
    Var13:SetUint64(8 * 1, bigInt(string))
    Citizen.InvokeNative(0x049D5C615BD38BAD, Var0:Buffer(), Var13:Buffer(), 1)
end)

exports("DisplayLeftNotification", function(title, subTitle, dict, icon, duration, color)
    local struct1 = DataView.ArrayBuffer(8 * 7)
    local struct2 = DataView.ArrayBuffer(8 * 8)
    local Duration = tonumber(duration) or 3000
    struct1:SetInt32(8 * 0, Duration)
    local string1 = CreateVarString(10, "LITERAL_STRING", title)
    local string2 = CreateVarString(10, "LITERAL_STRING", subTitle)
    struct2:SetInt64(8 * 1, bigInt(string1))
    struct2:SetInt64(8 * 2, bigInt(string2))
    struct2:SetInt32(8 * 3, 0)
    struct2:SetInt64(8 * 4, bigInt(joaat(dict)))
    struct2:SetInt64(8 * 5, bigInt(joaat(icon)))
    struct2:SetInt64(8 * 6, bigInt(joaat(color or "COLOR_WHITE")))
    Citizen.InvokeNative(0x26E87218390E6729, struct1:Buffer(), struct2:Buffer(), 1, 1)
end)

exports("DisplayTopCenterNotification", function(text, location, duration)
    local string1 = CreateVarString(10, "LITERAL_STRING", location)
    local string2 = CreateVarString(10, "LITERAL_STRING", text)
    local struct1 = DataView.ArrayBuffer(8 * 7)
    local struct2 = DataView.ArrayBuffer(8 * 5)
    local Duration = tonumber(duration) or 3000
    struct1:SetInt32(8 * 0, Duration)
    struct2:SetInt64(8 * 1, bigInt(string1))
    struct2:SetInt64(8 * 2, bigInt(string2))
    Citizen.InvokeNative(0xD05590C1AB38F068, struct1:Buffer(), struct2:Buffer(), 0, 1)
end)

exports("DisplayRightTip", function(text, duration)
    local string1 = CreateVarString(10, "LITERAL_STRING", text)
    local struct1 = DataView.ArrayBuffer(8 * 7)
    local struct2 = DataView.ArrayBuffer(8 * 3)
    local Duration = tonumber(duration) or 3000
    struct1:SetInt32(8 * 0, Duration)
    struct2:SetInt64(8 * 1, bigInt(string1))
    Citizen.InvokeNative(0xB2920B9760F0F36B, struct1:Buffer(), struct2:Buffer(), 1)
end)

exports("DisplayObjective", function(text, duration)
    Citizen.InvokeNative("0xDD1232B332CBB9E7", 3, 1, 0)
    local string1 = CreateVarString(10, "LITERAL_STRING", text)
    local struct1 = DataView.ArrayBuffer(8 * 7)
    local struct2 = DataView.ArrayBuffer(8 * 3)
    local Duration = tonumber(duration) or 3000
    struct1:SetInt32(8 * 0, Duration)
    struct2:SetInt64(8 * 1, bigInt(string1))
    Citizen.InvokeNative(0xCEDBF17EFCC0E4A4, struct1:Buffer(), struct2:Buffer(), 1)
end)

exports("ShowTopNotification", function(title, subtext, duration)
    local struct1 = DataView.ArrayBuffer(8 * 7)
    local Duration = tonumber(duration) or 3000
    struct1:SetInt32(8 * 0, Duration)
    local string1 = CreateVarString(10, "LITERAL_STRING", title)
    local string2 = CreateVarString(10, "LITERAL_STRING", subtext)
    local struct2 = DataView.ArrayBuffer(8 * 7)
    struct2:SetInt64(8 * 1, bigInt(string1))
    struct2:SetInt64(8 * 2, bigInt(string2))
    Citizen.InvokeNative(0xA6F4216AB10EB08E, struct1:Buffer(), struct2:Buffer(), 1, 1)
end)

exports("ShowAdvancedRightNotification", function(_text, _dict, icon, text_color, duration, quality, showquality)
    local text = CreateVarString(10, "LITERAL_STRING", _text)
    local dict = CreateVarString(10, "LITERAL_STRING", _dict)
    local sdict = CreateVarString(10, "LITERAL_STRING", "Transaction_Feed_Sounds")
    local sound = CreateVarString(10, "LITERAL_STRING", "Transaction_Positive")
    local Duration = tonumber(duration) or 3000
    local struct1 = DataView.ArrayBuffer(8 * 7)
    struct1:SetInt32(8 * 0, Duration)
    struct1:SetInt64(8 * 1, bigInt(sdict))
    struct1:SetInt64(8 * 2, bigInt(sound))
    local struct2 = DataView.ArrayBuffer(8 * 10)
    struct2:SetInt64(8 * 1, bigInt(text))
    struct2:SetInt64(8 * 2, bigInt(dict))
    struct2:SetInt64(8 * 3, bigInt(joaat(icon)))
    struct2:SetInt64(8 * 5, bigInt(joaat(text_color or "COLOR_WHITE")))
    if showquality then
        struct2:SetInt32(8 * 6, quality or 1)
    end
    Citizen.InvokeNative(0xB249EBCB30DD88E0, struct1:Buffer(), struct2:Buffer(), 1)
end)

exports("ShowBasicTopNotification", function(text, duration)
    local struct1 = DataView.ArrayBuffer(8 * 7)
    local Duration = tonumber(duration) or 3000
    struct1:SetInt32(8 * 0, Duration)
    local string1 = CreateVarString(10, "LITERAL_STRING", text)
    local struct2 = DataView.ArrayBuffer(8 * 7)
    struct2:SetInt64(8 * 1, bigInt(string1))
    Citizen.InvokeNative(0x860DDFE97CC94DF0, struct1:Buffer(), struct2:Buffer(), 1)
end)

exports("ShowSimpleCenterText", function(text, duration, text_color)
    local struct1 = DataView.ArrayBuffer(8 * 7)
    local Duration = tonumber(duration) or 3000
    struct1:SetInt32(8 * 0, Duration)
    local string1 = CreateVarString(10, "LITERAL_STRING", text)
    local struct2 = DataView.ArrayBuffer(8 * 4)
    struct2:SetInt64(8 * 1, bigInt(string1))
    struct2:SetInt64(8 * 2, bigInt(joaat(text_color or "COLOR_PURE_WHITE")))
    Citizen.InvokeNative(0x893128CDB4B81FBB, struct1:Buffer(), struct2:Buffer(), 1)
end)




exports("showBottomRight", function(text, duration)
    local struct1 = DataView.ArrayBuffer(8 * 7)
    local Duration = tonumber(duration) or 3000
    struct1:SetInt32(8 * 0, Duration)
    local string1 = CreateVarString(10, "LITERAL_STRING", text)
    local struct2 = DataView.ArrayBuffer(8 * 5)
    struct2:SetInt64(8 * 1, bigInt(string1))
    Citizen.InvokeNative(0x2024F4F333095FB1, struct1:Buffer(), struct2:Buffer(), 1)
end)


--new

exports("failmissioNotifY", function(title, subTitle, duration)
    local title = CreateVarString(10, "LITERAL_STRING", title)
    local msg = CreateVarString(10, "LITERAL_STRING", subTitle)
    local Duration = tonumber(duration) or 3000
    local struct1 = DataView.ArrayBuffer(8 * 5)
    local struct2 = DataView.ArrayBuffer(8 * 9)
    struct2:SetInt64(8 * 1, bigInt(title))
    struct2:SetInt64(8 * 2, bigInt(msg))
    local zz = Citizen.InvokeNative(0x9F2CC2439A04E7BA, struct1:Buffer(), struct2:Buffer(), 1)
    Wait(Duration)
    Citizen.InvokeNative(0x00A15B94CBA4F76F, zz)
end)


exports("deadplayerNotifY", function(title, _audioRef, _audioName, duration)
    local title = CreateVarString(10, "LITERAL_STRING", title)
    local audioRef = CreateVarString(10, "LITERAL_STRING", _audioRef)
    local audioName = CreateVarString(10, "LITERAL_STRING", _audioName)
    local Duration = tonumber(duration) or 3000
    local struct1 = DataView.ArrayBuffer(8 * 5)
    local struct2 = DataView.ArrayBuffer(8 * 9)
    struct1:SetInt64(8 * 0, bigInt(audioRef))
    struct1:SetInt64(8 * 1, bigInt(audioName))
    struct1:SetInt16(8 * 2, 4)
    struct2:SetInt64(8 * 1, bigInt(title))
    local zz = Citizen.InvokeNative(0x815C4065AE6E6071, struct1:Buffer(), struct2:Buffer(), 1)
    Wait(tonumber(Duration))
    Citizen.InvokeNative(0x00A15B94CBA4F76F, zz)
end)



exports("updatemissioNotify", function(utitle, umsg, duration)
    local title = CreateVarString(10, "LITERAL_STRING", utitle)
    local msg = CreateVarString(10, "LITERAL_STRING", umsg)
    local duration = tonumber(duration) or 3000
    local struct1 = DataView.ArrayBuffer(8 * 5)
    local struct2 = DataView.ArrayBuffer(8 * 9)
    struct2:SetInt64(8 * 1, bigInt(title))
    struct2:SetInt64(8 * 2, bigInt(msg))
    local zz = Citizen.InvokeNative(0x9F2CC2439A04E7BA, struct1:Buffer(), struct2:Buffer(), 1)
    Wait(duration)
    Citizen.InvokeNative(0x00A15B94CBA4F76F, zz)
end)


exports("warningNotify", function(title, msg, _audioRef, _audioName, duration)
    local title = CreateVarString(10, "LITERAL_STRING", title)
    local msg = CreateVarString(10, "LITERAL_STRING", msg)
    local audioRef = CreateVarString(10, "LITERAL_STRING", _audioRef)
    local audioName = CreateVarString(10, "LITERAL_STRING", _audioName)
    local duration = tonumber(duration) or 3000
    local struct1 = DataView.ArrayBuffer(8 * 5)
    local struct2 = DataView.ArrayBuffer(8 * 9)
    struct1:SetInt64(8 * 0, bigInt(audioRef))
    struct1:SetInt64(8 * 1, bigInt(audioName))
    struct1:SetInt16(8 * 2, 4)
    struct2:SetInt64(8 * 2, bigInt(title))
    struct2:SetInt64(8 * 3, bigInt(msg))
    local zz = Citizen.InvokeNative(0x339E16B41780FC35, struct1:Buffer(), struct2:Buffer(), 1)
    Wait(duration)
    Citizen.InvokeNative(0x00A15B94CBA4F76F, zz)
end)
