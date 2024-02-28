-- Service that creates a table if it doesnt exist or if the table does exist, add new columns.
local dbversion = nil

local Tables = {
    --   {
    --      name = "whitelist",
    --    script = "vorp_core",
    --  sql = [[
    --    CREATE TABLE IF NOT EXISTS `whitelist`  (
    --  `id` int(11) NOT NULL AUTO_INCREMENT,
    --       `identifier` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
    --       `status` boolean,
    --       `firstconnection` boolean DEFAULT TRUE,
    --       PRIMARY KEY (`id`) USING BTREE,
    --       UNIQUE INDEX `identifier`(`identifier`) USING BTREE
    --        ) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;
    --    ]]
    -- },

}

local Updates = {

    {
        name = "users",
        script = "vorp_core",
        find = [[
            SELECT * FROM Information_Schema.Columns
            WHERE Table_Name = 'users' AND COLUMN_NAME = 'char' AND DATA_TYPE = 'int'
        ]],
        sql = [[
            ALTER TABLE `users` MODIFY COLUMN `char` INT DEFAULT 5;
        ]]
    }

}

dbupdaterAPI = {}

dbupdaterAPI.addTables = function(tbls)
    for _, tbl in ipairs(tbls) do
        table.insert(Tables, tbl)
    end
end

dbupdaterAPI.addUpdates = function(updts)
    for _, updt in ipairs(updts) do
        table.insert(Updates, updt)
    end
end

local function runSQLList(list, type)
    for index, it in ipairs(list) do
        local hascolumn = false
        if it.find then
            local findresponse = MySQL.query.await(it.find)

            if #findresponse > 0 then
                hascolumn = true
                print('^4Database Auto Updater ^3(' .. it.script .. ')^2✅ Column Exists: ' .. it.name .. ' ^0')
            end
        end

        if hascolumn == false then
            MySQL.query(it.sql, function(result)
                if result and result.warningStatus > 0 then
                    local out = ''
                    if type == 'table' then
                        out = '^1❌ (' .. dbversion .. ') Failed to Create: '
                        if result.warningStatus == 1 or dbversion == 'MySQL' then
                            out = '^2✅ ' .. 'Table exists: '
                        end
                    else
                        out = '^1❌ (' .. dbversion .. ') Failed to Updated: '
                    end
                    print('^4Database Auto Updater ^3(' .. it.script .. ')' .. out .. it.name .. ' ^0')
                else
                    local out = ''
                    if type == 'table' then
                        out = 'Created Table: '
                    else
                        out = 'Updated Column: '
                    end
                    print('^4Database Auto Updater ^3(' .. it.script .. ')^2✅ ' .. out .. it.name .. '^0')
                end
            end)
        end
    end
end

function RunDBCheck()
    local rversion = MySQL.single.await('SELECT VERSION();')
    local version = rversion['VERSION()']

    if string.match(version, "MariaDB") then
        dbversion = "MariaDB"
    else
        dbversion = "MySQL"
    end
end

CreateThread(function()
    if not Config.autoUpdateDB then
        return
    end

    repeat
        Wait(10)
    until GetResourceState('oxmysql') == 'started' and VorpInitialized == true

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
        SaveResourceFile(GetCurrentResourceName(), "./server/services/dbupdater/status.json", json.encode(status), -1)
    else
        print('^4Database Auto Updater ^3(' .. dbversion .. ')^2✅ Database is up to date^0')
    end

    print('^0###############################################################################')
end)
