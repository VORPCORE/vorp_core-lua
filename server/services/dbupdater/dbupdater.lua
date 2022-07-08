-- Service that creates a table if it doesnt exist or if the table does exist, add new columns.
local tableupdated = false
local dbversion = nil

local Tables = {
    {
        name = "whitelist",
        sql = [[
            CREATE TABLE IF NOT EXISTS `whitelist`  (
            `id` int(11) NOT NULL AUTO_INCREMENT,
            `identifier` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
            `status` boolean,
            `firstconnection` boolean DEFAULT TRUE,
            PRIMARY KEY (`id`) USING BTREE,
            UNIQUE INDEX `identifier`(`identifier`) USING BTREE
            ) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;
        ]]
    },
    {
        name = "users",
        sql = [[
            CREATE TABLE IF NOT EXISTS `users` (
            `identifier` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
            `group` varchar(50) DEFAULT 'user',
            `warnings` int(11) DEFAULT 0,
            `banned` boolean,
            `banneduntil` int(10) DEFAULT 0,
            PRIMARY KEY (`identifier`),
            UNIQUE KEY `identifier` (`identifier`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
        ]]
    },
    {
        name = "characters",
        sql = [[
            CREATE TABLE IF NOT EXISTS `characters`  (
            `identifier` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '',
            `charidentifier` int(11) NOT NULL AUTO_INCREMENT,
            `steamname` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
            `group` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT 'user',
            `money` double(11, 2) NULL DEFAULT 0,
            `gold` double(11, 2) NULL DEFAULT 0,
            `rol` double(11, 2) NOT NULL DEFAULT 0,
            `xp` int(11) NULL DEFAULT 0,
            `inventory` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
            `job` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT 'unemployed',
            `status` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '{}',
            `firstname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT ' ',
            `lastname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT ' ',
            `skinPlayer` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
            `compPlayer` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL,
            `jobgrade` int(11) NULL DEFAULT 0,
            `coords` varchar(75) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT '{}',
            `isdead` tinyint(1) NULL DEFAULT 0,
            `ammo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT '{}',
            UNIQUE INDEX `identifier_charidentifier`(`identifier`, `charidentifier`) USING BTREE,
            INDEX `charidentifier`(`charidentifier`) USING BTREE,
            INDEX `ammo` (`ammo`) USING BTREE,
            CONSTRAINT `FK_characters_users` FOREIGN KEY (`identifier`) REFERENCES `users` (`identifier`) ON DELETE CASCADE ON UPDATE CASCADE
            ) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;
        ]]
    }
}

local Updates = {
    {
        name = "banned",
        sql = [[
            ALTER TABLE `users` MODIFY COLUMN  `banned` boolean;
        ]]
    },
    {
        name = "banneduntil",
        find = [[
            select *
            from Information_Schema.Columns
            where Table_Name = 'users'
            AND  Column_Name = 'banneduntil';
        ]],
        sql =  [[
            ALTER TABLE `users` ADD `banneduntil` int(10) DEFAULT 0
        ]]
    },
    {
        name = "status",
        find = [[
            select *
            from Information_Schema.Columns
            where Table_Name = 'whitelist'
            AND  Column_Name = 'status';
        ]],
        sql = [[
            ALTER TABLE `whitelist` ADD `status` boolean;
        ]]
    },
    {
        name = "firstconnection",
        find = [[
            select *
            from Information_Schema.Columns
            where Table_Name = 'whitelist'
            AND  Column_Name = 'firstconnection';
        ]],
        sql = [[
            ALTER TABLE `whitelist` ADD `firstconnection` boolean;
        ]]
    },
    {
        name = "steamname",
        find = [[
            select *
            from Information_Schema.Columns
            where Table_Name = 'characters'
            AND  Column_Name = 'steamname';
        ]],
        sql = [[
            ALTER TABLE `characters` ADD `steamname` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '';
        ]]
    },
    {
        name = "char",
        find = [[
            select *
            from Information_Schema.Columns
            where Table_Name = 'users'
            AND  Column_Name = 'char';
        ]],
        sql = [[
            ALTER TABLE `users` ADD `char` varchar(50) NOT NULL DEFAULT 'false';
        ]]
    },
    {
        name = "ammo",
        find = [[
            select *
            from Information_Schema.Columns
            where Table_Name = 'characters'
            AND  Column_Name = 'ammo';
        ]],
        sql = [[
            ALTER TABLE `characters` ADD COLUMN `ammo` longtext DEFAULT '{}';
        ]]
    },
    {
        name = "ammoindex",
        find = [[
            select *
            from Information_Schema.Columns
            where Table_Name = 'characters'
            AND  Column_Name = 'ammo';
        ]],
        sql = [[
            ALTER TABLE `characters` ADD INDEX `ammo` (`ammo`);
        ]]
    }
}

local function runSQLList(list, type)
    for index, it in ipairs(list) do
        local hascolumn = false
        if it.find then
            local isfound = exports.ghmattimysql:executeSync(it.find)
            if #isfound > 0 then
                hascolumn = true
                print('^4Database Updater ^3('..GetCurrentResourceName()..')^2✅ Column Exists: ' .. it.name .. ' ^0')
            end
        end

        if hascolumn == false then
            local result = exports.ghmattimysql:executeSync(it.sql)
            if result and result.warningStatus > 0 then
                local out = ''
                if type == 'table' then
                    out = '^1❌ ('..dbversion..') Failed to Create: '
                    if result.warningStatus == 1  or dbversion == 'MySQL' then
                        out = '^2✅ ' .. 'Table exists: ' 
                    end
                else 
                    out = '^1❌ ('..dbversion..') Failed to Updated: '
                end
                print('^4Database Updater ^3('..GetCurrentResourceName()..')' .. out .. it.name .. ' ^0')
            else
                local out = ''
                if type == 'table' then
                    out = 'Created Table: '
                    tableupdated = true
                else 
                    out = 'Updated Column: '
                end
                print('^4Database Updater ^3('..GetCurrentResourceName()..')^2✅ ' .. out .. it.name .. '^0')
            end 
        end
    end
end

function RunDBCheck() 
    local rversion = exports.ghmattimysql:executeSync('SELECT VERSION();')
    local version = rversion[1]['VERSION()']

    if string.match(version, "MariaDB") then
        dbversion = "MariaDB"
    else
        dbversion = "MySQL"
    end
end

Citizen.CreateThread(function()
    if not Config.autoUpdateDB then
        return
    end

    repeat
        Wait(10)
    until GetResourceState('ghmattimysql') == 'started' and VorpInitialized == true

    local filedata = LoadResourceFile(GetCurrentResourceName(), "./server/services/dbupdater/status.json")
    local status = json.decode(filedata)
    local updated = false

    RunDBCheck()
    print('')
    print("^3VORPcore Database Auto Updater ")
    print('')
    if status.tablecount < #Tables then
        runSQLList(Tables, 'table')
        status.tablecount = #Tables
        updated = true
    end

    if status.updatecount < #Updates then
        runSQLList(Updates, 'update')
        status.updatecount = #Updates
        updated = true
    end

    if updated then
        SaveResourceFile(GetCurrentResourceName(), "./server/services/dbupdater/status.json", json.encode(status))
    else
        print('^4Database Updater ^3('..GetCurrentResourceName()..')^2✅ Database('..dbversion..') is up to date^0')
    end

    print('^0###############################################################################')
end)