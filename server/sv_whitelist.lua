local whitelist, whitelistActive = {}, Config.Whitelist

function AddUserToWhitelist(identifier)
    whitelist[identifier] = true
end

function RemoveUserFromWhitelist(identifier)
    whitelist[identifier] = nil
end

local function LoadWhitelist()
    Citizen.Wait(5000)
    exports.ghmattimysql:execute('SELECT * FROM whitelist', {}, function(result)
        if #result > 0 then
            for k,v in ipairs(result) do
                whitelist[v.identifier] = true
            end
        end
    end)
end

local function SetUpdateWhitelistPolicy()
    while Config.AllowWhitelistAutoUpdate do
        Citizen.Wait(600000)
        whitelist = {}
        exports.ghmattimysql:execute("SELECT * FROM whitelist", {}, function(result)
            if #result > 0 then
                for k,v in ipairs(result) do
                    whitelist[v.identifier] = true
                end
            end
        end)
    end
end

function GetSteamID(src)
	local sid = GetPlayerIdentifiers(src)[1] or false

	if (sid == false or sid:sub(1,5) ~= "steam") then
		return false
	end

	return sid
end

function GetLicenseID(src)
	local sid = GetPlayerIdentifiers(src)[2] or false

	if (sid == false or sid:sub(1,5) ~= "license") then
		return false
	end

	return sid
end

Citizen.CreateThread(function()
    LoadWhitelist()
    SetUpdateWhitelistPolicy()
end)

AddEventHandler("playerConnecting", function(playerName, setKickReason, deferrals)
    local source, userEntering = source, false

    deferrals.defer()

    local steamIdentifier = GetSteamID(source)

    if not steamIdentifier then
        deferrals.done(Config.Langs["NoSteam"])
        setKickReason(Config.Langs["NoSteam"])
    end

    if _users[steamIdentifier] then --Save and delete
        _users[steamIdentifier].SaveUser()
        _users[steamIdentifier] = nil
    end

    if whitelistActive then
        if whitelist[steamIdentifier] then
            deferrals.done()
        else
            deferrals.done(Config.Langs["NoInWhitelist"])
            setKickReason(Config.Langs["NoInWhitelist"])
        end
    else
        userEntering = true
    end

    if userEntering then
        deferrals.update(Config.Langs["LoadingUser"])
        if CheckConnected(steamIdentifier) then
            deferrals.done(Config.Langs["IsConnected"])
            setKickReason(Config.Langs["IsConnected"])
        else
            LoadUser(source, setKickReason, deferrals, steamIdentifier, GetLicenseID(source))
        end
    end


    
    --Debug.WriteLine($"{playerName} is connecting with (Identifier: [{steamIdentifier}])");

    exports.ghmattimysql:execute("SELECT * FROM characters WHERE `identifier` = ?", { steamIdentifier }, function(result)
        if #result ~= 0 then
            local inventory = "{}"
            if not result[1].inventory == nil then
                inventory = result[1].inventory
            end
            LoadCharacter(steamIdentifier, Character(source, steamIdentifier, result[1].charidentifier, result[1].group, result[1].job, result[1].jobgrade, result[1].firstname, result[1].lastname, inventory, result[1].status, result[1].coords, result[1].money, result[1].gold, result[1].rol, result[1].xp, result[1].isdead))
        end
    end)

    --When player is fully connected then load!!!!
end)
