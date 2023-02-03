--=============================================================================--
--========================= VORP SHARED CONFIG ================================--


Config = {

    autoUpdateDB = true,
    PrintPlayerInfoOnLeave = false, -- print in server console information of players leaving
    PrintPlayerInfoOnEnter = false, -- print player info on server console when enter server
    --======================== STARTING POINT ===========================--

    initGold     = 0.0,
    initMoney    = 200.0,
    initRol      = 0.0,
    initXp       = 0,
    initJob      = "unemployed", -- leave it like this
    initJobGrade = 0, -- leave it like this
    initGroup    = "user", -- leave it like this

    Whitelist                = false, -- dont use
    AllowWhitelistAutoUpdate = false, -- dont use
    SavePlayersStatus        = false, -- save players health stamina inner and outter core to DB?

    maxHealth             = 10, -- 10 is FULL 0 IS EMPTY define max outer core for players
    maxStamina            = 10, -- 10 is FULL 0 IS EMPTY define max outer core for players
    PVP                   = true, -- Can players attack/hurt one another
    PVPToggle             = true, -- If true, players can set their own pvp state
    savePlayersTimer      = 10, -- this will tell the core in how many minutes should all players be saved to the database
    showplayerIDwhenfocus = true, -- set false will show steam name when focus on another player RMB
    disableAutoAIM        = true, -- if false players with controllers will have autoaim just like in rdr2
    SavePlayersHours      = false, -- if you want to save players played hours in DB, tx admin already have this

    --=========================== MULTICHAR ==============================--
    SaveSteamNameDB   = true, -- TRUE if you want save steamname on character DB when player drop (need to update SQL)
    UseCharPermission = false, --| if false it will let players create maxchars bellow
    MaxCharacters     = 5, --MAX ALLOWED TO BE CREATED [if UseCharPermission = true, SELECTED players(with command) can create MaxCharacters characters / if UseCharPermission = false, players can create MaxCharacters characters]

    --=========================== UI CORES ==================================--
    -- disable
    HideOnlyDEADEYE = true,
    HidePlayersCore = false,
    HideHorseCores = false,

    --=========================== WEBHOOKS ==================================--

    webhookColor = 16711680, --EMBED COLOR
    name         = "VORP", --NAME OF EMBED
    logo         = "https://via.placeholder.com/30x30", --HEAD LOGO
    footerLogo   = "https://via.placeholder.com/30x30", --FOOTER LOGO
    Avatar       = "https://via.placeholder.com/30x30", -- AVATAR LOGO


    -- delete what you dont want
    Logs = {
        SetgroupWebhook   = "", --SETJOB
        SetjobWebhook     = "", --SETGROUP
        AddmoneyWebhook   = "", --ADDMONEY
        DelMoneyWebhook   = "", --DELMONEY
        AddItemsWebhook   = "", --ADDITEMS
        AddWeaponsWebhook = "", --ADDWEAPONS
        DelWagonsWebhook  = "", --DELWAGONS
        TpmWebhook        = "", --TPM
        DelHorseWebhook   = "", --DELHORSE
        HealPlayerWebhook = "", --HEALPLAYER
        ReviveWebhook     = "", --REVIVE
        WhitelistWebhook  = "", --WHITELIST
        BanWarnWebhook    = "", --BANS/WARNS
        NewPlayerWebhook  = "", --NEWPLAYER
        CharPermWebhook   = "", --CHARPERMS
        ChangeNameWebhook = "", -- CHANGECHARNAMES
    },

    ------------------------------------------------------------------------------
    ------------------------- UI Configurations ----------------------------------
    HideUi         = false, -- Show or Hide the Overall UI
    HideGold       = false, --disables Gold UI for all
    HideMoney      = false, --disables Money UI for all
    HideLevel      = false, --disables Level UI for all
    HideID         = false, --disables ID UI for all
    HideTokens     = false, --disables Token UI for all
    HidePVP        = false, --disables PVP UI for all
    UIPosition     = 'TopRight', -- Changes position of UI. Options: BottomRight, MiddleRight, TopRight, TopMiddle, BottomMiddle
    UILayout       = 'Column', -- Changes the layour of the UI. Options: Row, Column
    HideWithRader  = true, -- UI will hide whenever the radar(minimap) is hidden
    OpenAfterRader = true, -- UI will show whenever the radar(minimap) is showing again
    CloseOnDelay   = false, -- UI will automatically close after an amount of time
    CloseOnDelayMS = 10000, -- CloseOnDelays time in miliseconds, 10000 = 10seconds

    ------------------------------------------------------------------------------
    ------------------------- MAP Configurations ----------------------------------
    mapTypeOnFoot     = 3, -- 0 = Off(no radar), 1 = Regular 2 = Expanded  3 = Simple(compass), for on foot
    mapTypeOnMount    = 3, -- 0 = Off(no radar), 1 = Regular 2 = Expanded  3 = Simple(compass), for on horse
    enableTypeRadar   = false, --- if true the above will work, if false players can choose their radar type in the game settings.
    Loadinscreen      = true, --ENABLE LOADING SCREENS on spawn and while spawn dead
    LoadinScreenTimer = 10000, -- miliseconds

    -------------------------------------------------------------------------------
    ------------------------------- RESPAWN ---------------------------------------

    HealthOnRespawn = 500, --Player's health when respawned in hospital (MAX = 500)
    HealthOnResurrection = 100, --Player's health when resurrected (MAX = 500)
    RagdollOnResurrection = true, -- Enable or disable Ragdoll and revive effects when revived
    --CanBeDamagedToSpawn = false, -- The player can take damage while spawning
    HealthRecharge = { enable = true, multiplier = 0.37 }, -- enable or disable auto recharge of health outer core (real ped health), multiplier 1.0 is default
    StaminaRecharge = { enable = true, multiplier = 0.4 }, -- enable or disable auto recharge of stamina outer core, multiplier 1.0 is default
    RespawnTime = 10, --seconds
    RespawnKey = 0xDFF812F9, --[E] KEY
    RespawnKeyTime = 5000, -- Milliseconds it will take to press the button
    CombatLogDeath = true, -- people who combat log now spawn in dead rather than force spawned
    --sprite = true, --- enable text with sprite or disable
    -- spriteColor = { r = 100, g = 1, b = 1 }, -- sprite rgb color
    UseControlsCamera = false, -- if youset this to true players while dead  or being carried can move the camera using w a d s controls this is resource intensive leave to false
    UseDeathHandler = true, -- levae this to true if you dont know what you doing . this is to disable the death handling incase you have something custom

    Hospitals = {
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
    -----------------------------------------------------------------------------

    ActiveEagleEye = false,
    ActiveDeadEye = false,
    TimeZoneDifference = 1, -- Your time zone difference with UTC in winter time

    ----------------------------------------------------------------------------
    --------------------------- COMMAND PERMISSION -----------------------------
    SetUserDBadmin = true, -- should the command addGroup set admins on Users table? for characters table do set false
    GroupAllowed = { "admin" }, -- add here groups
    -- dont change this unless you change them in sv_commands too
    Commands = { "addGroup", "addJob", "addItems", "addWeapons", "addMoney", "delMoney", "healplayer",
        "reviveplayer", "tpm", "delhorse", "delwagons", "banplayer", "wlplayer", "unwlplayer", "warn",
        "unban", "unwarn", "changeCharName" }, -- commands available

    --------------------------------------------------------------------------------------
    -----------------------------BUILT IN RICH PRESENCE DISCORD --------------------------
    maxplayers = 128, -- change to the number of players that can get in to your server
    appid = nil, -- Application ID (Replace this with you own)
    biglogo = "LOGOname", -- image assets name for the "large" icon.
    biglogodesc = " Redm Server Connect: ", -- text when hover over image
    smalllogo = "smallboy name", -- image assets name for the "small" icon.(OPTIONAL)
    smalllogodesc = "Join us for a good time", -- text when hover over image
    discordlink = "https://discord.gg/", -- discord link
    richpresencebutton = "Join Discord", --set button text for Rich Presence Button
    shownameandid = true, --show player steam name and id

    ---------------------------------------------------------------------------------------
    ------------------------------- TRANSLATE ---------------------------------------------
    Langs = {
        IsConnected        = "🚫 Duplicated account connected (steam | rockstar)",
        NoSteam            = "🚫 You have to have Steam open, please open Steam & restart RedM",
        NoInWhitelist      = "🚫 You are not in the Whitelist. Send in discord channel #user-id your user-id: ",
        NoPermissions      = "You don't have enough permissions",
        CheckingIdentifier = "Checking Identifiers",
        LoadingUser        = "Loading User",
        BannedUser         = "You Are Banned Until ",
        DateTimeFormat     = "%d/%m/%y %H:%M:%S", -- Set wished DateTimeFormat for output in ban notification
        TimeZone           = " CET", -- Set your timezone
        DropReasonBanned   = "You were banned from the server until ",
        Warned             = "You were warned",
        Unwarned           = "You were unwarned",
        TitleOnDead        = "Do /alertdoctor in chat to request doctors aid",
        SubTitleOnDead     = "You can respawn in %s seconds",
        SecondsMove        = " seconds",
        YouAreCarried      = "You are being carried by a person",
        VoiceRangeChanged  = "Voice chat range changed to %s meters",
        promptLabel        = "Respawn", -- prompt label.
        prompt             = "Respawn", -- prompt group label
        wayPoint           = "VORP: You need to set a waypoint first!",
        mustBeSeated       = "VORP: You must be in the driver's seat!",
        wagonInFront       = "VORP: You must be seated or near a wagon to delete it!",
        cantCarry          = "VORP: Can't carry more weapons!",
        Hold               = "HOLD ON!!",
        Load               = "You are loading in",
        Almost             = "Almost there...",
        Holddead           = "YOU ARE DEAD",
        Loaddead           = "you left the server while dead",
        forcedrespawn      = "YOU WILL BE RESPAWNED",
        forced             = "Because you left the server while dead",
        sit                = "you need to be steated",
        NotifyChar         = "you must set your char height to 1.0 there will bugs if you dont.",
        NotifyCharSelect   = "Once you ~e~delete ~q~a character theres no going back!",
        PVPNotifyOn        = "PVP On ",
        PVPNotifyOff       = "PVP Off",
        AddChar            = "Added Multicharacter ",
        RemoveChar         = "Removed Multicharacter ",
        WrongHex           = "Hex not in DB or Wrong Hex",
        myjob              = "your job is: ~o~",
        mygrade            = " ~q~grade: ~o~",
        charhours          = "your character hours is: ~o~",
        playhours          = "hours played is: ~o~",
        RespawnIn          = "You can respawn in ",
        message            = " or " .. " /calldoctor",
        message2           = "Time has passed respawn",
        message3           = "You need to wait untill you can respawn",
        message4           = "Player ID ",
        message5           = "you were injured , per rule you must forget the past 30 minutes",
        message6           = "Respawn!!!"
    },



}
