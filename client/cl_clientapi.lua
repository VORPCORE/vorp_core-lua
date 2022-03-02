AddEventHandler('getCore', function(cb)
    local corefunctions = {}

    corefunctions.RpcCall = function(name, callback, args)
        TriggerEvent('vorp:ExecuteServerCallBack', name, callback, args)
    end

    corefunctions.displayTip = function(text, miliseconds)
        exports["vorp_core"]:DisplayTip(text, miliseconds)
    end

    corefunctions.displayRightTip = function(text, miliseconds)
        exports["vorp_core"]:DisplayRightTip(text, miliseconds)
    end

    corefunctions.displayObjetive = function(text, miliseconds)
        exports["vorp_core"]:DisplayObjetive(text, miliseconds)
    end

    corefunctions.displayTopCenterNotification = function(text, location, miliseconds)
        exports["vorp_core"]:DisplayTopCenterNotification(text, location, miliseconds)
    end

    corefunctions.displayLeftNotification = function(title, text, dic, icon, miliseconds)
        LoadTexture(dic)
        exports["vorp_core"]:DisplayLeftNotification(title, text, dic, icon, miliseconds)
    end

    cb(corefunctions)
end)