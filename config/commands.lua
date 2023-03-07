local T = Translation[Lang].Commands

--============================
--? EXAMPLE
-- * in this file is where vor core commands are registered
-- * you can register your own commands here too
-- * it has features such as : arguments needed , is user in game , groups allowed ,aces allowed ,jobs allowed, webhooks and chat suggestions
-- * callfunction bellow, will return a table  with    {source , args , rawCommand , config} config is the value on this file the parameters of the command used like commandName
-- TODO job grade support
--! dont use t this way
 
--[[ addgroup = {
        webhook = "", -- discord log when someone uses this command leave to false if you dont need
        custom = "\n**PlayerID** `%d`\n**Group given** `%s`", -- for webhook
        title = "📋 `/Group command`", -- webhook title
        ---#end webhook
        commandName = "addGroup", -- name of the command to use
        label = "set players group", -- label of command when using
        suggestion = { -- chat arguments needed
            { name = "Id",    help = T.Commands.help1 }, -- add how many you need
            { name = "Group", help = T.Commands.help2 },
        },
        userCheck = true, -- does this command need to check if user is playing ?
        groupAllowed = { "admin" }, -- from users table in the database this group will be allowed to use this command
        aceAllowed = 'vorpcore.setGroup.Command', -- dont touch,
        --jobsAllow = {}, -- jobs allowed ? remove or leave empty if not needed
        callFunction = function(...) -- dont touch
            -- this is a function
            -- you can run code here trigger client events or server events , exports etc,
            -- get source local data = ...
            --local source = data.source
            SetGroup(...)
        end

    },]]
--END

--==============================
Commands = {
    addgroup = {
        webhook = "",
        custom = T.addGroup.custom,
        title = T.addGroup.tittle,
        ---#end webhook
        commandName = "addGroup",
        label = T.addGroup.label,
        suggestion = {
            { name = T.addGroup.name,  help = T.addGroup.help },
            { name = T.addGroup.name1, help = T.addGroup.help1 },
        },
        userCheck = true,
        groupAllowed = { "admin" },
        aceAllowed = 'vorpcore.setGroup.Command',
        callFunction = function(...)
            SetGroup(...)
        end

    },
    addJob = {
        webhook = "",
        custom = T.addJob.custom,
        title = T.addJob.title,
        ---#end webhook
        commandName = "addJob",
        label = T.addJob.label,
        suggestion = {
            { name = T.addJob.name,  help = T.addJob.help },
            { name = T.addJob.name1, help = T.addJob.help1 },
            { name = T.addJob.name2, help = T.addJob.help2 },
        },
        userCheck = true,
        groupAllowed = { "admin" },
        aceAllowed = 'vorpcore.setJob.Command',
        callFunction = function(...)
            AddJob(...)
        end
    },
    addItem = {
        webhook = "",
        custom = "\n**PlayerID:** `%d` \n**Item given** `%s`\n**Count:** `%d`",
        title = "📋` /additems command` ",
        ---#end webhook
        commandName = "addItems",
        label = "VORPcore command to give items",
        suggestion = {
            { name = "Id",       help = 'player ID to give item' },
            { name = "Name",     help = 'item name' },
            { name = "Quantity", help = 'amount' },
        },
        userCheck = true,
        groupAllowed = { "admin" },
        aceAllowed = 'vorpcore.additems.Command',
        callFunction = function(...)
            AddItems(...)
        end
    },
    addWeapon = {
        webhook = "",
        custom = "\n**PlayerID** `%d` \n**Weapon given** `%s`",
        title = "📋` /addweapons command` ",
        ---#end webhook
        commandName = "addWeapon",
        label = "VORPcore command add weapon to player ",
        suggestion = {
            { name = "Id",     help = "" },
            { name = "weapon", help = 'weapon name ex: weapon_revolver_lemat' },
        },
        userCheck = true,
        groupAllowed = { "admin" },
        aceAllowed = 'vorpcore.addweapons.Command',
        callFunction = function(...)
            AddWeapons(...)
        end
    },
    delMoney = {
        webhook = "",
        custom = "`\n**PlayerID** `%d` \n**Type** `%d` \n**Quantity** `%d`",
        title = "📋` /delcurrency command` ",
        ---#end webhook
        commandName = "delMoney",
        label = "VORPcore command to remove money from players",
        suggestion = {
            { name = "Id",       help = "" },
            { name = "Type",     help = 'type 0 to give money or 1 to give gold' },
            { name = "Quantity", help = 'Quantity to remove from player' },
        },
        userCheck = true,
        groupAllowed = { "admin" },
        aceAllowed = 'vorpcore.delCurrency.Command',
        callFunction = function(...)
            RemmoveCurrency(...)
        end
    },
    addMoney = {
        webhook = "",
        custom = "\n**PlayerID** `%d` \n**Type** `%d`\n**Quantity** `%d`",
        title = "📋` /Addmoney command` ",
        ---#end webhook
        commandName = "addMoney",
        label = "VORPcore command to to give Money or gold",
        suggestion = {
            { name = "Id",       help = "server id" },
            { name = "Type",     help = 'type 0 to give money or 1 to give gold' },
            { name = "Quantity", help = 'Quantity to give' },
        },
        userCheck = true,
        groupAllowed = { "admin" },
        aceAllowed = 'vorpcore.setGroup.Command',
        callFunction = function(...)
            AddMoney(...)
        end
    },
    delWagons = {
        webhook = "",
        custom = "`\n**PlayerID** `%d`\n **Action:** `Used delwagons` \n **Radius:** `%d`",
        title = "📋` /delwagons command` ",
        ---#end webhook
        commandName = "delWagons",
        label = "VORPcore command to remove delete wagons within radius",
        suggestion = {
            { name = "radius", help = 'add a number from 1 to any' },
        },
        userCheck = false,
        groupAllowed = { "admin" },
        aceAllowed = 'vorpcore.delwagons.Command',
        callFunction = function(...)
            DeleteWagons(...)
        end
    },
    revive = {
        webhook = "",
        custom = "`\n**PlayerID** `%d`\n **Action:** `Was Revived`",
        title = "📋` /revive command` ",
        commandName = "revive",
        label = "VORPcore command to revive players or yourself",
        suggestion = {
            { name = "Id", help = "player id" },
        },
        userCheck = true,
        groupAllowed = { "admin" },
        aceAllowed = 'vorpcore.reviveplayer.Command',
        callFunction = function(...)
            RevivePlayer(...)
        end
    },
    teleport = {
        webhook = "",
        custom = "\n**PlayerID** `%d`\n**Action:** `Used TPM`",
        title = "📋` /Tpm command` ",
        commandName = "tpm",
        label = "VORPcore command to teleport to marker",
        suggestion = {},
        userCheck = false,
        groupAllowed = { "admin" },
        aceAllowed = 'vorpcore.tpm.Command',
        callFunction = function(...)
            TeleporPlayer(...)
        end
    },
    delHorse = {
        webhook = "",
        custom = "`\n**PlayerID** `%d `\n **Action:** `Used Delhorse`",
        title = "📋` /delhorse command` ",
        commandName = "delHorse",
        label = "VORPcore command to delete a horse you are mounted",
        suggestion = {},
        userCheck = false,
        groupAllowed = { "admin" },
        aceAllowed = 'vorpcore.delhorse.Command',
        callFunction = function(...)
            DeleteHorse(...)
        end
    },
    heal = {
        webhook = "",
        custom = "`\n**PlayerID** `%d`\n **Action:** `Was healed`",
        title = "📋` /healplayer command` ",
        commandName = "heal",
        label = "VORPcore command to heal a player or yourself",
        suggestion = {
            { name = "Id", help = 'player ID no need for player id if its for you' }
        },
        userCheck = true,
        groupAllowed = { "admin" },
        aceAllowed = 'vorpcore.healplayer.Command',
        callFunction = function(...)
            local data = ...
            -- in here you can add your metabolism events
            TriggerClientEvent("vorpmetabolism:changeValue", data.source, "Thirst", 1000)
            TriggerClientEvent("vorpmetabolism:changeValue", data.source, "Hunger", 1000)
            HealPlayers(...)
        end
    },
    addWhitelist = {
        webhook = "",
        custom = "`\n**PlayerID:** ` %d `\n **Action:** `has used whitelist`",
        title = "📋` /wlplayer command` ",
        commandName = "addWhtelist",
        label = "VORPcore command set player as whitelisted",
        suggestion = {
            { name = "steamid", help = 'steam ID like this > 11000010c8aa16e' }
        },
        userCheck = false,
        groupAllowed = { "admin" },
        aceAllowed = 'vorpcore.wlplayer.Command',
        callFunction = function(...)
            AddPlayerToWhitelist(...)
        end
    },
    unWhitelist = {
        webhook = "",
        custom = "`\n**PlayerID** ` %d `\n **Action:** `has used unwhitelist`",
        title = "📋` /unwlplayer command` ",
        commandName = "unWhitelist",
        label = "VORPcore command to set player as unwhitelisted", -- set up the log for this
        suggestion = {
            { name = "steamid", help = 'steam id must be provided' },
        },
        userCheck = false,
        groupAllowed = { "admin" },
        aceAllowed = 'vorpcore.unwlplayer.Command',
        callFunction = function(...)
            RemovePlayerFromWhitelist(...)
        end
    },
    ban = {
        webhook = "",
        custom = "\n**PlayerID** `%d`\n **Action:** `%s`",
        title = "📋` /ban command` ",
        commandName = "ban",
        label = "VORPcore command to set player as banned", -- set up the log for this
        suggestion = {
            { name = "steamid", help = 'steam id must be provided' },
            { name = "Time",    help = 'Time of ban: d for day w for week m for month y for years example /ban steamid d2   player will be banned for 2 days' },
        },
        userCheck = false,
        groupAllowed = { "admin" },
        aceAllowed = 'vorpcore.ban.Command',
        callFunction = function(...)
            BanPlayers(...)
        end
    },
    unBan = {
        webhook = "",
        custom = "\n**PlayerID:** ` %d `\n**Action:** `has used unbanned`",
        title = "📋` /unban command` ",
        commandName = "unBan",
        label = "VORPcore command to set player as unBanned", -- set up the log for this
        suggestion = {
            { name = "steamid", help = 'steam id must be provided' },
        },
        userCheck = false,
        groupAllowed = { "admin" },
        aceAllowed = 'vorpcore.unban.Command',
        callFunction = function(...)
            UnBanPlayers(...)
        end
    },
    warn = {
        webhook = "",
        custom = "`\n**PlayerID** ` %d `\n **Action:** `has used warned`",
        title = "📋` /warn command` ",
        commandName = "warn",
        label = "VORPcore command to add a warn to player ", -- set up the log for this
        suggestion = {
            { name = "steamid", help = 'steam id must be provided' }
        },
        userCheck = false,
        groupAllowed = { "admin" },
        aceAllowed = 'vorpcore.warn.Command',
        callFunction = function(...)
            WarnPlayers(...)
        end
    },
    unWarn = {
        webhook = "",
        custom = "`\n**PlayerID** ` %d `\n **Action:** `has used unwarned`",
        title = "📋` /unwarn command` ",
        commandName = "unWarn",
        label = "VORPcore command to remove a warn from player", -- set up the log for this
        suggestion = {
            { name = "steamid", help = 'steam id must be provided' },
        },
        userCheck = false,
        groupAllowed = { "admin" },
        aceAllowed = 'vorpcore.unwarn.Command',
        callFunction = function(...)
            UnWarnPlayer(...)
        end
    },
    charName = {
        webhook = "",
        custom = "`\n**PlayerID** ` %d `\n **Action:** `Has used changename`",
        title = "📋` /changename command` ",
        commandName = "modifyCharName",
        label = "VORPcore command to modify a player name", -- set up the log for this
        suggestion = {
            { name = "Id",        help = 'player ID ' },
            { name = "firstname", help = 'new player first name' },
            { name = "lastname",  help = 'new player last  name' },
        },
        userCheck = true,
        groupAllowed = { "admin" },
        aceAllowed = 'vorpcore.changeCharName',
        callFunction = function(...)
            ModifyCharName(...)
        end
    },
    charCreateAdd = {
        webhook = "",
        custom = "`\n**PlayerID: ** ` %d `\n **Action:** `has used multicharacter`",
        title = "📋` /addchar command` ",
        commandName = "addChar",
        label = "VORPcore command to set player can create more than one character will be allowed to create: " .. Config.MaxCharacters,
        suggestion = {
            { name = "Steam Hex", help = 'steam id required' },
        },
        userCheck = false,
        groupAllowed = { "admin" },
        aceAllowed = 'vorpcore.addchar.Command',
        callFunction = function(...)
            AddCharCanCreateMore(...)
        end
    },
    charCreateRemove = {
        webhook = "",
        custom = "`\n**PlayerID:** ` %d `\n **Action:** `Has used remove multicharacter`",
        title = "📋` /removechar command` ",
        --end webhook
        commandName = "removeChar",
        label = "VORPcore command to remove player from being able to create more than one character ",
        suggestion = {
            { name = "Steam Hex", help = 'steam id required' },
        },
        userCheck = false,
        groupAllowed = { "admin" },
        aceAllowed = 'vorpcore.removechar.Command',
        callFunction = function(...)
            RemoveCharCanCreateMore(...)
        end
    },
    myJob = {
        webhook = "",
        commandName = "myJob",
        label = "VORPcore command to check what job you hold",
        suggestion = {},
        userCheck = false,
        groupAllowed = {}, -- leave empty anyone can use
        aceAllowed = nil, -- leave nil anyone can use
        callFunction = function(...)
            MyJob(...)
        end
    },
    myHours = {
        webhook = "",
        commandName = "myHours",
        label = " VORPcore command to check your hours player in this server  ",
        suggestion = {},
        userCheck = false,
        groupAllowed = {}, -- leave empty anyone can use
        aceAllowed = nil, -- leave nil anyone can use
        callFunction = function(...)
            MyHours(...)
        end
    },
    -- create your commands here just copy from above , see first line on how to do it

}
