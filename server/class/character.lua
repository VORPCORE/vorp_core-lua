--- update state bags
local function SetState(source, key, field, newValue)
    local state = Player(source).state[key]
    if state then
        state[field] = newValue
        Player(source).state:set(key, state, true)
    end
end

function Character(data)
    local self = {}
    self.identifier = data.identifier
    self.charIdentifier = data.charIdentifier
    self.group = data.group
    self.job = data.job
    self.joblabel = data.joblabel
    self.jobgrade = data.jobgrade
    self.firstname = data.firstname
    self.lastname = data.lastname
    self.inventory = data.inventory
    self.status = data.status
    self.coords = data.coords
    self.skin = data.skin
    self.comps = data.comps
    self.money = data.money
    self.gold = data.gold
    self.rol = data.rol
    self.healthOuter = data.healthOuter
    self.healthInner = data.healthInner
    self.staminaOuter = data.staminaOuter
    self.staminaInner = data.staminaInner
    self.xp = data.xp
    self.hours = data.hours
    self.isdead = data.isdead
    self.source = data.source
    self.compTints = data.compTints
    self.age = data.age
    self.gender = data.gender
    self.charDescription = data.charDescription
    self.nickname = data.nickname
    self.steamname = data.steamname
    self.slots = data.slots

    self.Identifier = function()
        return self.identifier
    end

    self.CharIdentifier = function(value)
        if value then self.charIdentifier = value end
        return self.charIdentifier
    end

    self.Group = function(value, flag)
        if value then
            self.group = value
            if flag or flag == nil then -- alow true or nil, only false will not trigger the event
                TriggerEvent("vorp:playerGroupChange", self.source, self.group)
            end
            SetState(self.source, "Character", "Group", self.group)
        end

        return self.group
    end

    self.Job = function(value, flag)
        if value then
            self.job = value
            if flag or flag == nil then -- alow true or nil, only false will not trigger the event
                TriggerEvent("vorp:playerJobChange", self.source, self.job)
            end
            SetState(self.source, "Character", "Job", self.job)
        end
        return self.job
    end

    self.Joblabel = function(value)
        if value then
            self.joblabel = value
            SetState(self.source, "Character", "JobLabel", self.joblabel)
        end

        return self.joblabel
    end

    self.Jobgrade = function(value, flag)
        if value then
            self.jobgrade = value
            if flag or flag == nil then -- alow true or nil, only false will not trigger the event
                TriggerEvent("vorp:playerJobGradeChange", self.source, self.jobgrade)
            end
            SetState(self.source, "Character", "Grade", self.jobgrade)
        end

        return self.jobgrade
    end

    self.Firstname = function(value)
        if value then
            self.firstname = value
            SetState(self.source, "Character", "FirstName", self.firstname)
        end
        return self.firstname
    end

    self.Lastname = function(value)
        if value then
            self.lastname = value
            SetState(self.source, "Character", "LastName", self.lastname)
        end

        return self.lastname
    end

    self.Age = function(value)
        if value then
            self.age = value
            SetState(self.source, "Character", "age", self.age)
        end
        return self.age
    end

    self.Gender = function(value)
        if value then
            self.gender = value
            SetState(self.source, "Character", "Gender", self.gender)
        end
        return self.gender
    end

    self.CharDescription = function(value)
        if value then
            self.charDescription = value
            SetState(self.source, "Character", "CharDescription", self.charDescription)
        end
        return self.charDescription
    end

    self.NickName = function(value)
        if value then
            self.nickname = value
            SetState(self.source, "Character", "Nickname", self.nickname)
        end
        return self.nickname
    end

    self.Inventory = function(value)
        if value then self.inventory = value end
        return self.inventory
    end

    self.Status = function(value)
        if value then self.status = value end
        return self.status
    end

    self.Coords = function(value)
        if value then self.coords = value end
        return self.coords
    end

    self.Money = function(value)
        if value then self.money = value end
        return self.money
    end

    self.Gold = function(value)
        if value then self.gold = value end
        return self.gold
    end

    self.Rol = function(value)
        if value then self.rol = value end
        return self.rol
    end

    self.HealthOuter = function(value)
        if value then self.healthOuter = value end
        return self.healthOuter
    end

    self.HealthInner = function(value)
        if value then self.healthInner = value end
        return self.healthInner
    end

    self.StaminaOuter = function(value)
        if value then self.staminaOuter = value end
        return self.staminaOuter
    end

    self.StaminaInner = function(value)
        if value then self.staminaInner = value end
        return self.staminaInner
    end

    self.Xp = function(value)
        if value then self.xp = value end
        return self.xp
    end

    self.Hours = function(value)
        if value then self.hours = value end
        return self.hours
    end

    self.IsDead = function(value)
        if value ~= nil then self.isdead = value end
        return self.isdead
    end

    self.Skin = function(value)
        if value then
            self.skin = value
            MySQL.update(
                "UPDATE characters SET `skinPlayer` = @skin WHERE `identifier` = @identifier AND `charidentifier` = @charIdentifier",
                { skin = value, identifier = self.identifier, charIdentifier = self.charIdentifier })
        end
        return self.skin
    end

    self.Comps = function(value)
        if value then
            self.comps = value
            MySQL.update(
                "UPDATE characters SET `compPlayer` = @comps WHERE `identifier` = @identifier AND `charidentifier` = @charIdentifier",
                { comps = value, identifier = self.identifier, charIdentifier = self.charIdentifier })
        end
        return self.comps
    end

    self.CompTints = function(value)
        if value then
            self.compTints = value
            MySQL.update(
                "UPDATE characters SET `compTints` = @tints WHERE `identifier` = @identifier AND `charidentifier` = @charIdentifier",
                { tints = value, identifier = self.identifier, charIdentifier = self.charIdentifier })
        end
        return self.compTints
    end

    self.updateCharUi = function()
        local nuipost = {
            type = "ui",
            action = "update",
            moneyquanty = self.Money(),
            goldquanty = self.Gold(),
            rolquanty = self.Rol(),
            serverId = self.source,
            xp = self.Xp()
        }
        TriggerClientEvent("vorp:updateUi", self.source, json.encode(nuipost))
    end

    self.addCurrency = function(currency, quantity) --add check for security
        if currency == 0 then
            self.money = self.money + quantity
            SetState(self.source, "Character", "Money", self.money)
        elseif currency == 1 then
            self.gold = self.gold + quantity
            SetState(self.source, "Character", "Gold", self.gold)
        elseif currency == 2 then
            self.rol = self.rol + quantity
            SetState(self.source, "Character", "Rol", self.rol)
        end
        self.updateCharUi()
    end

    self.removeCurrency = function(currency, quantity)
        if currency == 0 then
            self.money = self.money - quantity
            SetState(self.source, "Character", "Money", self.money)
        elseif currency == 1 then
            self.gold = self.gold - quantity
            SetState(self.source, "Character", "Gold", self.gold)
        elseif currency == 2 then
            self.rol = self.rol - quantity
            SetState(self.source, "Character", "Rol", self.rol)
        end

        self.updateCharUi()
    end

    self.addXp = function(quantity)
        self.xp = self.xp + quantity
        self.updateCharUi()
    end

    self.removeXp = function(quantity)
        self.Xp = self.xp - quantity
        self.updateCharUi()
    end

    self.saveHealthAndStamina = function(healthOuter, healthInner, staminaOuter, staminaInner)
        self.healthOuter = healthOuter
        self.healthInner = healthInner
        self.staminaOuter = staminaOuter
        self.staminaInner = staminaInner
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

    self.UpdateHours = function(hours)
        self.hours = self.hours + hours
    end

    self.setSlots = function(slots)
        if slots then
            self.slots = self.slots + slots
        end
        return self.slots
    end

    self.SaveNewCharacterInDb = function(cb)
        MySQL.query("INSERT INTO characters (`identifier`,`group`,`money`,`gold`,`rol`,`xp`,`healthouter`,`healthinner`,`staminaouter`,`staminainner`,`hours`,`inventory`,`job`,`status`,`firstname`,`lastname`,`skinPlayer`,`compPlayer`,`jobgrade`,`coords`,`isdead`,`joblabel`, `age`,`gender`,`character_desc`,`nickname`,`compTints`,`steamname`,`slots`) VALUES (@identifier,@group, @money, @gold, @rol, @xp, @healthouter, @healthinner, @staminaouter, @staminainner, @hours, @inventory, @job, @status, @firstname, @lastname, @skinPlayer, @compPlayer, @jobgrade, @coords, @isdead, @joblabel, @age, @gender, @charDescription, @nickname,@compTints,@steamname,@slots)",
            {
                identifier = self.identifier,
                group = self.group,
                money = self.money,
                gold = self.gold,
                rol = self.rol,
                xp = self.xp,
                healthouter = self.healthOuter,
                healthinner = self.healthInner,
                staminaouter = self.staminaOuter,
                staminainner = self.staminaInner,
                hours = self.hours,
                inventory = self.inventory,
                job = self.job,
                status = self.status,
                firstname = self.firstname,
                lastname = self.lastname,
                skinPlayer = self.skin,
                compPlayer = self.comps,
                jobgrade = self.jobgrade,
                coords = self.coords,
                isdead = self.isdead,
                joblabel = self.joblabel,
                age = self.age,
                gender = self.gender,
                charDescription = self.charDescription,
                nickname = self.nickname,
                compTints = self.compTints,
                steamname = self.steamname,
                slots = self.slots
            },
            function(character)
                cb(character.insertId)
            end)
    end

    self.DeleteCharacter = function()
        MySQL.query("DELETE FROM characters WHERE `identifier` = @identifier AND `charidentifier` = @charidentifier ", { identifier = self.identifier, charidentifier = self.charIdentifier })
    end

    self.SaveCharacterCoords = function(coords)
        MySQL.update("UPDATE characters SET `coords` = @coords WHERE `identifier` =  @identifier AND `charidentifier` = @charidentifier", { coords = coords, identifier = self.identifier, charidentifier = self.charIdentifier })
    end

    self.SaveCharacterInDb = function()
        MySQL.update(
            "UPDATE characters SET `group` =@group ,`money` =@money ,`gold` =@gold ,`rol` =@rol ,`xp` =@xp ,`healthouter` =@healthouter ,`healthinner` =@healthinner ,`staminaouter` =@staminaouter ,`staminainner` =@staminainner ,`hours` =@hours ,`job` =@job , `status` =@status ,`firstname` =@firstname , `lastname` =@lastname , `jobgrade` =@jobgrade , `coords` =@coords , `isdead` =@isdead , `joblabel` =@joblabel, `age` =@age, `gender`=@gender, `character_desc`=@charDescription,`nickname`=@nickname,`steamname`=@steamname, `slots` =@slots WHERE `identifier` =@identifier AND `charidentifier` =@charidentifier",
            {
                group = self.group,
                money = self.money,
                gold = self.gold,
                rol = self.rol,
                xp = self.xp,
                healthouter = self.healthOuter,
                healthinner = self.healthInner,
                staminaouter = self.staminaOuter,
                staminainner = self.staminaInner,
                hours = self.hours,
                job = self.job,
                status = self.status,
                firstname = self.firstname,
                lastname = self.lastname,
                jobgrade = self.jobgrade,
                coords = self.coords,
                isdead = self.isdead,
                joblabel = self.joblabel,
                identifier = self.identifier,
                charidentifier = self.charIdentifier,
                age = self.age,
                gender = self.gender,
                charDescription = self.charDescription,
                nickname = self.nickname,
                steamname = self.steamname,
                slots = self.slots
            })
    end

    -- getters and functions setters
    self.getCharacter = function()
        local userData = {}

        userData.identifier = self.identifier
        userData.charIdentifier = self.charIdentifier
        userData.group = self.group
        userData.job = self.job
        userData.jobLabel = self.joblabel
        userData.jobGrade = self.jobgrade
        userData.money = self.money
        userData.gold = self.gold
        userData.rol = self.rol
        userData.xp = self.xp
        userData.healthOuter = self.healthOuter
        userData.healthInner = self.healthInner
        userData.staminaOuter = self.staminaOuter
        userData.staminaInner = self.staminaInner
        userData.hours = self.hours
        userData.firstname = self.firstname
        userData.lastname = self.lastname
        userData.inventory = self.inventory
        userData.status = self.status
        userData.coords = self.coords
        userData.isdead = self.isdead
        userData.skin = self.skin
        userData.comps = self.comps
        userData.compTints = self.compTints
        userData.age = self.age
        userData.gender = self.gender
        userData.charDescription = self.charDescription
        userData.nickname = self.nickname
        userData.invCapacity = tonumber(self.slots)

        userData.updateInvCapacity = function(slots)
            self.setSlots(slots)
        end
        userData.setStatus = function(status)
            self.Status(status)
        end

        userData.setJobGrade = function(jobgrade, flag)
            self.Jobgrade(jobgrade, flag)
        end
        userData.setJobLabel = function(joblabel)
            self.Joblabel(joblabel)
        end
        userData.setGroup = function(group, flag)
            self.Group(group, flag)
        end

        userData.setJob = function(job, flag)
            self.Job(job, flag)
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
        -------------------
        userData.setAge = function(age)
            self.Age(age)
        end

        userData.setGender = function(gender)
            self.Gender(gender)
        end

        userData.setCharDescription = function(charDescription)
            self.CharDescription(charDescription)
        end

        userData.setNickName = function(nickname)
            self.NickName(nickname)
        end
        --------------
        userData.updateSkin = function(skin)
            self.Skin(skin)
        end

        userData.updateComps = function(comps)
            self.Comps(comps)
        end
        userData.updateCompTints = function(tints)
            self.CompTints(tints)
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
            local nuipost = {
                type = "ui",
                action = "update",
                moneyquanty = self.Money(),
                goldquanty = self.Gold(),
                rolquanty = self.Rol(),
                serverId = self.source,
                xp = self.Xp()
            }

            TriggerClientEvent("vorp:updateUi", self.source, json.encode(nuipost))
        end

        return userData
    end

    return self
end
