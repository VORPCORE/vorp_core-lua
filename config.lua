--=============================================
--            VORP SHARED CONFIG             --
--=============================================

-- make sure to read the comments in green
-- if you dont know what they are for ask, or leave it as it is

Lang = "English" -- choose here your language , check translation folder to see if its available in your language

Config = {
    onesync                  = true,  -- turn to false if you dont use onesync
    autoUpdateDB             = true,
    PrintPlayerInfoOnLeave   = false, -- print in server console information of players leaving
    PrintPlayerInfoOnEnter   = false, -- print player info on server console when enter server
    --=======================================
    ---STARTING POINT
    -- add here players initial money
    -- for items go to inventory
    initGold                 = 0.0,
    initMoney                = 200.0,
    initRol                  = 0.0,
    initXp                   = 0,
    initJob                  = "unemployed", -- leave it like this
    initJobGrade             = 0,            -- leave it like this
    initGroup                = "user",       -- leave it like this
    Whitelist                = false,        -- dont use
    AllowWhitelistAutoUpdate = false,        -- dont use
    SavePlayersStatus        = false,        -- save players health stamina inner and outter core to DB?
    maxHealth                = 10,           -- 10 is FULL 0 IS EMPTY define max outer core for players
    maxStamina               = 10,           -- 10 is FULL 0 IS EMPTY define max outer core for players
    PVP                      = true,         -- Can players attack/hurt one another
    PVPToggle                = true,         -- If true, players can set their own pvp state
    CommandOnOffPVP          = 'pvp',        -- [ NEED PVPToggle = true ] TOGGLE or OFF pvp for your character
    savePlayersTimer         = 10,           -- this will tell the core in how many minutes should all players be saved to the database
    showplayerIDwhenfocus    = true,         -- set false will show steam name when focus on another player RMB
    disableAutoAIM           = true,         -- if false players with controllers will have autoaim just like in rdr2
    SavePlayersHours         = false,        -- if you want to save players played hours in DB, tx admin already have this
    --========================================
    ---MULTICHAR
    SaveSteamNameDB          = true,  -- TRUE if you want save steamname on character DB when player drop (need to update SQL)
    UseCharPermission        = false, -- | if false it will let players create maxchars bellow
    MaxCharacters            = 5,     -- MAX ALLOWED TO BE CREATED [if UseCharPermission = true, SELECTED players(with command) can create MaxCharacters characters / if UseCharPermission = false, players can create MaxCharacters characters]
    --========================================
    --UI CORES
    HideOnlyDEADEYE          = true,
    HidePlayersCore          = false,
    HideHorseCores           = false,
    --========================================
    ---WEBHOOKS
    -- see commands.config
    webhookColor             = 16711680,                            --EMBED COLOR
    name                     = "VORP",                              --NAME OF EMBED
    logo                     = "https://via.placeholder.com/30x30", --HEAD LOGO
    footerLogo               = "https://via.placeholder.com/30x30", --FOOTER LOGO
    Avatar                   = "https://via.placeholder.com/30x30", -- AVATAR LOGO
    --=======================================
    ---UI Configurations
    HideUi                   = false,      -- Show or Hide the Overall UI
    HideGold                 = false,      -- disables Gold UI for all
    HideMoney                = false,      -- disables Money UI for all
    HideLevel                = false,      -- disables Level UI for all
    HideID                   = false,      -- disables ID UI for all
    HideTokens               = false,      -- disables Token UI for all
    HidePVP                  = false,      -- disables PVP UI for all
    UIPosition               = 'TopRight', -- Changes position of UI. Options: BottomRight, MiddleRight, TopRight, TopMiddle, BottomMiddle
    UILayout                 = 'Column',   -- Changes the layour of the UI. Options: Row, Column
    HideWithRader            = true,       -- UI will hide whenever the radar(minimap) is hidden
    OpenAfterRader           = true,       -- UI will show whenever the radar(minimap) is showing again
    CloseOnDelay             = false,      -- UI will automatically close after an amount of time
    CloseOnDelayMS           = 10000,      -- CloseOnDelays time in miliseconds, 10000 = 10seconds
    -- Commands of UI
    CommandHideIU            = 'hideUi',   -- HIDE all UI's from screen, nice to take screenshots.
    CommandToogleUI          = 'toggleUi', -- Toggle vorp UI's from screen
    -- Others
    CommandClearAnim         = 'stopAnim', -- To use if you are stuck on an animation
    --=======================================
    ---MAP Configurations
    mapTypeOnFoot            = 3,     -- 0 = Off(no radar), 1 = Regular 2 = Expanded  3 = Simple(compass), for on foot
    mapTypeOnMount           = 3,     -- 0 = Off(no radar), 1 = Regular 2 = Expanded  3 = Simple(compass), for on horse
    enableTypeRadar          = false, -- if true the above will work, if false players can choose their radar type in the game settings.
    Loadinscreen             = true,  -- ENABLE LOADING SCREENS on spawn and while spawn dead
    LoadinScreenTimer        = 10000, -- miliseconds
    --=======================================
    ---RESPAWN
    HealthOnRespawn          = 500,                                  -- Player's health when respawned in hospital (MAX = 500)
    HealthOnResurrection     = 100,                                  -- Player's health when resurrected (MAX = 500)
    RagdollOnResurrection    = true,                                 -- Enable or disable Ragdoll and revive effects when revived
    HealthRecharge           = { enable = true, multiplier = 0.37 }, -- enable or disable auto recharge of health outer core (real ped health), multiplier 1.0 is default
    StaminaRecharge          = { enable = true, multiplier = 0.4 },  -- enable or disable auto recharge of stamina outer core, multiplier 1.0 is default
    RespawnTime              = 10,                                   -- seconds
    RespawnKey               = 0xDFF812F9,                           -- [E] KEY
    RespawnKeyTime           = 5000,                                 -- Milliseconds it will take to press the button
    CombatLogDeath           = true,                                 -- people who combat log now spawn in dead rather than force spawned
    UseControlsCamera        = false,                                -- if youset this to true players while dead  or being carried can move the camera using w a d s controls this is resource intensive leave to false
    UseDeathHandler          = true,                                 -- levae this to true if you dont know what you doing . this is to disable the death handling incase you have something custom
    -- places for players to spawn
    Hospitals                = {
        Valentine = {
            name = "Valentine",
            pos = vector4(-283.83, 806.4, 119.38, 321.76), -- use vorp admin to get vector4 x y z h
        },
        SaintDenis = {
            name = "Saint Denis",
            pos = vector4(2721.4562, -1446.0975, 46.2303, 321.76),
        },
        Armadillo = {
            name = "Armadillo",
            pos = vector4(-3742.5, -2600.9, -13.23, 321.76),
        },
        Blackwater = {
            name = "Black water",
            pos = vector4(-723.9527, -1242.8358, 44.7341, 321.76),
        },
        Rhodes = {
            name = "Rhodes",
            pos = vector4(1229.0, -1306.1, 76.9, 321.76),
        },
    },
    ActiveEagleEye           = true,
    ActiveDeadEye            = false,
    --=======================================================
    -- BAN SYSTEM
    DateTimeFormat           = "%d/%m/%y %H:%M:%S", -- Set wished DateTimeFormat for output in ban notification
    TimeZone                 = " CET",              -- Set your timezone
    TimeZoneDifference       = 1,                   -- Your time zone difference with UTC in winter time this is used for the banning system
    --=======================================================
    -- COMMAND PERMISSION
    NewPlayerWebhook         = "",    -- new user on the server login with static id
    SetUserDBadmin           = true,  -- should the command addGroup set admins on Users table? for characters table do set false
    SetBothDBadmin           = false, -- if set true should the command addGroup set admins on both tables in databse!
    --=======================================================
    ---BUILT IN RICH PRESENCE DISCORD
    maxplayers               = 128,                       -- change to the number of players that can get in to your server
    appid                    = nil,                       -- Application ID (Replace this with you own)
    biglogo                  = "LOGOname",                -- image assets name for the "large" icon.
    biglogodesc              = " Redm Server Connect: ",  -- text when hover over image
    smalllogo                = "smallboy name",           -- image assets name for the "small" icon.(OPTIONAL)
    smalllogodesc            = "Join us for a good time", -- text when hover over image
    discordlink              = "https://discord.gg/",     -- discord link
    richpresencebutton       = "Join Discord",            --set button text for Rich Presence Button
    shownameandid            = true,                      --show player steam name and id
    --======================================================
}
