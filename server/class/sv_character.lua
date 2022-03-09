--- Deep copies a table into a new table.
-- Tables used as keys are also deep copied, as are metatables
-- @param orig The table to copy
-- @return Returns a copy of the input table
local function deep_copy(orig)
  local copy
  if type(orig) == "table" then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[deep_copy(orig_key)] = deep_copy(orig_value)
    end
    setmetatable(copy, deep_copy(getmetatable(orig)))
  else
    copy = orig
  end
  return copy
end
  
--- Copies a table into a new table.
-- neither sub tables nor metatables will be copied.
-- @param orig The table to copy
-- @return Returns a copy of the input table
local function shallow_copy(orig)
  local copy
  if type(orig) == "table" then
    copy = {}
    for orig_key, orig_value in pairs(orig) do
      copy[orig_key] = orig_value
    end
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

--Class for user characters
function Character(source, identifier, charIdentifier, group, job, jobgrade, firstname, lastname, inventory, status, coords, money, gold, rol, xp, isdead, skin, comps)
    local self = {}

    self.identifier = identifier
    self.charIdentifier = charIdentifier
    self.group = group
    self.job = job
    self.jobgrade = jobgrade
    self.firstname = firstname
    self.lastname = lastname
    self.inventory = inventory
    self.status = status
    self.coords = coords
    self.skin = skin
    self.comps = comps

    self.money = money
    self.gold = gold
    self.rol = rol

    self.xp = xp

    self.isdead = isdead

    --self.userPlayer --Isto serve para que mesmo???
    self.source = source

    --[[public Player PlayerVar { Isto só se usa em c#
        get {
            PlayerList pl = new PlayerList();
            return pl[source];
        } 
    }]]

    self.Identifier = function() return self.identifier end
    self.CharIdentifier = function(value) if value ~= nil then self.charIdentifier = value end return self.charIdentifier end
    self.Group = function(value) if value ~= nil then self.group = value end return self.group end
    self.Job = function(value) if value ~= nil then self.job = value end return self.job end
    self.Jobgrade = function(value) if value ~= nil then self.jobgrade = value end return self.jobgrade end
    self.Firstname = function(value) if value ~= nil then self.firstname = value end return self.firstname end
    self.Lastname = function(value) if value ~= nil then self.lastname = value end return self.lastname end
    self.Inventory = function(value) if value ~= nil then self.inventory = value end return self.inventory end
    self.Status = function(value) if value ~= nil then self.status = value end return self.status end
    self.Coords = function(value) if value ~= nil then self.coords = value end return self.coords end
    self.Money = function(value) if value ~= nil then self.money = value end return self.money end
    self.Gold = function(value) if value ~= nil then self.gold = value end return self.gold end
    self.Rol = function(value) if value ~= nil then self.rol = value end return self.rol end
    self.Xp = function(value) if value ~= nil then self.xp = value end return self.xp end
    self.IsDead = function(value) if value ~= nil then self.isdead = value end return self.isdead end

    self.Skin = function(value)
        if value ~= nil then
            self.skin = value
            exports.ghmattimysql:execute("UPDATE characters SET `skinPlayer` = ? WHERE `charidentifier` = ?", {value, self.CharIdentifier()})
        end

        return self.skin
    end
    
    self.Comps = function(value)
        if value ~= nil then
            self.comps = value
            exports.ghmattimysql:execute("UPDATE characters SET `compPlayer` = ? WHERE `charidentifier` = ?", {value, self.CharIdentifier()})
        end

        return self.comps
    end


    self.getCharacter = function()
        local userData = {}

        userData.identifier = self.identifier
        userData.charIdentifier = self.charIdentifier
        userData.group = self.group
        userData.job = self.job
        userData.jobGrade = self.jobgrade
        userData.money = self.money
        userData.gold = self.gold
        userData.rol = self.rol
        userData.xp = self.xp
        userData.firstname = self.firstname
        userData.lastname = self.lastname
        userData.inventory = self.inventory
        userData.status = self.status
        userData.coords = self.coords
        userData.isdead = self.isdead
        userData.skin = self.skin
        userData.comps = self.comps

        userData.setStatus = function(status) --Prevent bugs here
            self.Status(status)
        end

        userData.setJobGrade = function(jobgrade)
            self.Jobgrade(jobgrade)
        end

        userData.setGroup = function(group)
            self.Group(group)
        end

        userData.setJob = function(job)
            self.Job(job)
        end

        userData.setMoney = function(money)
            self.Money(money)
            self.updateCharUi()
        end

        userData.setGold = function(gold)
            self.Gold(gold)
            self.updateCharUi()
        end

        userData.setRol = function(rol)
            self.Rol(rol)
            self.updateCharUi()
        end

        userData.setXp = function(xp)
            self.Xp(xp)
            self.updateCharUi()
        end

        userData.setFirstname = function(firstname)
            self.Firstname(firstname)
        end

        userData.setLastname = function(lastname)
            self.Lastname(lastname)
        end

        userData.updateSkin = function(skin)
            self.Skin(skin)
        end

        userData.updateComps = function(comps)
            self.Comps(comps)
        end

        userData.addCurrency = function(currency, quantity)
            self.addCurrency(currency, quantity)
        end

        userData.removeCurrency = function(currency, quantity)
            self.removeCurrency(currency, quantity)
        end

        userData.addXp = function(xp)
            self.addXp(xp)
        end

        userData.removeXp = function(xp)
            self.removeXp(xp)
        end

        userData.updateCharUi = function()
            local nuipost = {}
    
            nuipost["type"] = "ui"
            nuipost["action"] = "update"
            nuipost["moneyquanty"] = self.Money()
            nuipost["goldquanty"] = self.Gold()
            nuipost["rolquanty"] = self.Rol()
            nuipost["serverId"] = self.source
            nuipost["xp"] = self.Xp()
    
            TriggerClientEvent("vorp:updateUi", self.source, json.encode(nuipost))
        end

        return userData
    end

    self.updateCharUi = function()
        local nuipost = {}

        nuipost["type"] = "ui"
        nuipost["action"] = "update"
        nuipost["moneyquanty"] = self.Money()
        nuipost["goldquanty"] = self.Gold()
        nuipost["rolquanty"] = self.Rol()
        nuipost["serverId"] = self.source
        nuipost["xp"] = self.Xp()

        TriggerClientEvent("vorp:updateUi", self.source, json.encode(nuipost))
    end

    self.addCurrency = function(currency, quantity) --add check for security
        if currency == 0 then
            self.money = self.money + quantity
        elseif currency == 1 then
            self.gold = self.gold + quantity
        elseif currency == 2 then
            self.rol = self.rol + quantity
        end
        self.updateCharUi()
    end

    self.removeCurrency = function(currency, quantity) --add check for security
        if currency == 0 then
            self.money = self.money - quantity
        elseif currency == 1 then
            self.gold = self.gold - quantity
        elseif currency == 2 then
            self.rol = self.rol - quantity
        end
        self.updateCharUi()
    end

    self.addXp = function(quantity) --add check for security
        self.xp = self.xp + quantity
        self.updateCharUi()
    end

    self.removeXp = function(quantity) --add check for security
        self.Xp = self.xp - quantity
        self.updateCharUi()
    end


    self.setJob = function(newjob)
        self.Job(newjob)
    end

    self.setGroup = function(newgroup)
        self.Group(newgroup)
    end

    self.setDead = function(dead)
        self.IsDead(dead)
    end

    self.SaveNewCharacterInDb = function(cb)
        exports.ghmattimysql:execute("INSERT INTO characters(`identifier`,`group`,`money`,`gold`,`rol`,`xp`,`inventory`,`job`,`status`,`firstname`,`lastname`,`skinPlayer`,`compPlayer`,`jobgrade`,`coords`,`isdead`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", {self.Identifier(), self.Group(), self.Money(), self.Gold(), self.Rol(), self.Xp(), self.Inventory(), self.Job(), self.Status(), self.Firstname(), self.Lastname(), self.Skin(), self.Comps(), self.Jobgrade(), self.Coords(), self.IsDead()}, function(character)
            cb(character.insertId)
        end)
    end

    self.DeleteCharacter = function()
        exports.ghmattimysql:execute("DELETE FROM characters WHERE `charidentifier` = ? ", {self.CharIdentifier()})
    end

    self.SaveCharacterCoords = function(coords)
        self.Coords(coords)
        exports.ghmattimysql:execute("UPDATE characters SET `coords` = ? WHERE `charidentifier` = ?", {self.Coords(), self.CharIdentifier()})
    end

    self.SaveCharacterInDb = function()
        local character = deep_copy(self);

        local group = character.Group()
        local money =  character.Money()
        local gold =  character.Gold()
        local rol =  character.Rol()
        local xp =  character.Xp()
        local job =  character.Job()
        local status = character.Status()
        local firstname =  character.Firstname()
        local lastname = character.Lastname()
        local jobgrade = character.Jobgrade()
        local coords = character.Coords()
        local isdead = character.IsDead()
        local charid =  character.CharIdentifier()

        exports.ghmattimysql:execute("UPDATE characters SET `group` = ?,`money` = ?,`gold` = ?,`rol` = ?,`xp` = ?,`job` = ?, `status` = ?,`firstname` = ?, `lastname` = ?, `jobgrade` = ?,`coords` = ?,`isdead` = ? WHERE `charidentifier` = ?"
        , {group, money, gold, rol, xp, job, status, firstname, lastname, jobgrade, coords, isdead, charid})
    end

    return self
end

