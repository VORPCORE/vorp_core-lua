_whitelist = {}


function AddUserToWhitelistById(id)
    _whitelist[id].GetEntry().setStatus(true)
end

function RemoveUserFromWhitelistById(id)
    _whitelist[id].GetEntry().setStatus(false)
end

local function LoadWhitelist()
    Wait(5000)
    MySQL.query('SELECT * FROM whitelist', {}, function(result)
        if #result > 0 then
            for _, v in ipairs(result) do
                _whitelist[v.id] = Whitelist(v.id, v.identifier, v.status, v.firstconnection)
            end
        end
    end)
end

local function SetUpdateWhitelistPolicy()
    while Config.AllowWhitelistAutoUpdate do
        Wait(3600000) --change this value if you want to have update from SQL not every 1 hour
        _whitelist = {}
        MySQL.query("SELECT * FROM whitelist", {}, function(result)
            if #result > 0 then
                for _, v in ipairs(result) do
                    _whitelist[v.id] = Whitelist(v.id, v.identifier, v.status, v.firstconnection)
                end
            end
        end)
    end
end

function GetSteamID(src)
    local sid = GetPlayerIdentifiers(src)[1] or false

    if sid == false or sid:sub(1, 5) ~= "steam" then
        return false
    end
    return sid
end

---comment
---@param source number
---@param id_type string
---@return nil | number
local function GetIdentifier(source, id_type)
    if type(id_type) ~= "string" then return print('Invalid usage') end

    for _, identifier in pairs(GetPlayerIdentifiers(source)) do
        if string.find(identifier, id_type) then
            return identifier
        end
    end
    return nil
end

---comment
---@param src number
---@return boolean
local function GetLicenseID(src)
    local sid = GetPlayerIdentifiers(src)[2] or false
    if (sid == false or sid:sub(1, 5) ~= "license") then
        return false
    end
    return sid
end

---comment
---@param identifier any
---@return any
function GetUserId(identifier)
    for k, v in pairs(_whitelist) do
        if v.GetEntry().getIdentifier() == identifier then
            return v.GetEntry().getId()
        end
    end
end

---comment
---@param identifier any
---@return number
local function InsertIntoWhitelist(identifier)
    if GetUserId(identifier) then
        return GetUserId(identifier)
    end

    MySQL.prepare.await("INSERT INTO whitelist (identifier, status, firstconnection) VALUES (?,?,?)"
        , { identifier, false, true }, function(result) end)

    local entryList = MySQL.single.await('SELECT 1 FROM whitelist WHERE identifier = ?', { identifier })
    local currentFreeId
    if entryList then
        local entry = entryList
        currentFreeId = entry.id
    end
    _whitelist[currentFreeId] = Whitelist(currentFreeId, identifier, false, true)

    return currentFreeId
end

CreateThread(function()
    LoadWhitelist()
    SetUpdateWhitelistPolicy()
end)

AddEventHandler("playerConnecting", function(playerName, setKickReason, deferrals)
    local _source = source
    local userEntering = false

    deferrals.defer()
    local steamIdentifier = GetSteamID(_source)
    local playerWlId = nil
    local IDs = GetIdentifier(_source, 'steam')

    if IDs == nil then
        deferrals.done(Config.Langs.NoSteam)
        userEntering = false
        CancelEvent()
        return
    end

    if _users[steamIdentifier] and not _usersLoading[identifier] then --Save and delete
        _users[steamIdentifier].SaveUser()
        _users[steamIdentifier] = nil
    end

    if Config.Whitelist then
        playerWlId = GetUserId(steamIdentifier)
        if _whitelist[playerWlId] and _whitelist[playerWlId].GetEntry().getStatus() then
            deferrals.done()
            userEntering = true
        else
            playerWlId = InsertIntoWhitelist(steamIdentifier)
            deferrals.done(Config.Langs.NoInWhitelist .. playerWlId)
            setKickReason(Config.Langs.NoInWhitelist .. playerWlId)
        end
    else
        userEntering = true
    end

    if userEntering then
        deferrals.update(Config.Langs.LoadingUser)
        LoadUser(_source, setKickReason, deferrals, steamIdentifier, GetLicenseID(_source))
    end

    MySQL.single("SELECT 1 FROM characters WHERE `identifier` = ?", { steamIdentifier }, function(result)
        if result then
            local inventory = "{}"
            if not result.inventory == nil then
                inventory = result.inventory
            end
            LoadCharacter(steamIdentifier,
                Character(_source, steamIdentifier, result.charidentifier, result.group, result.job,
                    result.jobgrade, result.firstname, result.lastname, inventory, result.status,
                    result.coords, result.money, result.gold, result.rol, result.healthouter,
                    result.healthinner, result.staminaouter, result.staminainner, result.xp,
                    result.hours, result.isdead
                )
            )
        end
    end)
    local getPlayer = GetPlayerName(_source)
    if getPlayer and Config.PrintPlayerInfoOnEnter then
        print("Player ^2" .. getPlayer .. " ^7steam: ^3" .. steamIdentifier .. "^7 Loading...")
    end
    --When player is fully connected then load!!!!
end)
