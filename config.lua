Config = {
  initGold =  0.0,
  initMoney=  120.0,
  initRol =  0.0,
  initXp =  0,
  initJob =  "none",
  initJobGrade =  0,
  initGroup =  "user",
  Whitelist =  false,
  AllowWhitelistAutoUpdate =  false,
  MaxCharacters =  1,
  ActiveVoiceChat =  false,
  KeySwapVoiceRange =  0x80F28E95,
  DefaultVoiceRange =  5.0,
  VoiceRanges = {2.0, 5.0, 12.0},
  
  CombatLogDeath = true, -- people who combat log now spawn in dead rather than force spawned 

  RespawnTime =  25, -- 25 seconds
  RespawnKey =  0xDFF812F9,
  RespawnTitleFont =  1,
  RespawnSubTitleFont =  1,
--  "RespawnCoords =  [ -353.08, 752.11, 116.0, 321.76 ], // X, Y, Z, Heading
  hospital =  {
    Valentine = {
      name = "Valentine",
      x = -325.8,
      y = 759.7,
      z = 120.7,
      h = 303.6
    },
    Blackwater = {
      name = "Blackwater",
      x = -870.5,
      y = -1282.5,
      z = 42.1,
      h = 8.8
    },
    SaintDenis = {
      name = "SaintDenis",
      x = 2720.791,
      y = -1228.876,
      z = 50.5676,
      h = 166.054
    }
  },
  HeadId =  true,
  HeadIdDistance =  15,
  ModeKey =  true,
  KeyShowIds =  "0x8CC9CD42", -- Press X 

  ActiveEagleEye =  true,
  ActiveDeadEye =  false,

  --Discord Rich Precense FEATURE DISABLED Please Wait for Milestone 4
  ActiveDRP =  false,
  DiscordAppId =  "null",
  RichPresenceText =  "Test",
  DiscordRichPresenceAsset =  "logo_name",
  DiscordRichPresenceAssetText =  "This server is running with VorpCore",
  DiscordRichPresenceAssetSmall =  "logo_name",
  DiscordRichPresenceAssetSmallText =  "vorpcore.com"
}

Config.Langs = {
  IsConnected = "🚫 Duplicated account connected (steam | rockstar)",
  NoSteam = "🚫 You have to have Steam open, please open Steam & restart RedM",
  NoInWhitelist = "🚫 You are not in the Whitelist",
  NoPermissions = "You don't have enough permissions",
  CheckingIdentifier = "Checking Identifiers",
  LoadingUser = "Loading User",
  BannedUser = "You Are Banned",
  TitleOnDead = "You have died!",
  SubTitleOnDead = "You will respawn in %s seconds",
  SubTitlePressKey = "Press ~e~E~q~ to respawn",
  YouAreCarried = "You are being carried by a person",

  VoiceRangeChanged = "Voice chat range changed to %s meters"
}
