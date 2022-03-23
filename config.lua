----------------------------------------------------------------------------
------------           VORP SHARED CONFIG                       ------------
----------------------------------------------------------------------------

Config = {
  initGold =  0.0,
  initMoney=  200.0,
  initRol =  0.0,
  initXp =  0,
  initJob =  "unemployed",
  initJobGrade =  0,
  initGroup =  "user",
  
  Whitelist =  false,
  AllowWhitelistAutoUpdate =  false,
  MaxCharacters =  5,
  ActiveVoiceChat =  false,
  KeySwapVoiceRange =  0x80F28E95,
  DefaultVoiceRange =  5.0,
  VoiceRanges = {2.0, 5.0, 12.0},
  
 
  -------------------------------- UI --------------------------------
  HideUi = false, --show or hide the UI includes cores gold cash ID and level bar -- note the cash gold ID are in the inventory. you can disable this one
  HideRadar = true -- show or hide radar for everyone 
  ShowUiDeath = true, -- show or hide the UI if player is dead 
  camDeath = false, -- enable or disable the camera death function
  
  RespawnTime =  10, -- 25 seconds
  RespawnKey =  0xDFF812F9,
  RespawnTitleFont =  1, -- for the draw text message
  RespawnSubTitleFont =  1, -- for the draw text message sub title font
  
  sprite = true, --- enable text with sprite or disable
  spriteGrey = false, -- if set to false will enable RED sprite true will be grey
 ---------------------------- RESPAWN COORDS ------------------------------------
  CombatLogDeath = true, -- people who combat log now spawn in dead rather than force spawned 
  
  hospital =  {
    Valentine = {
      name = "Valentine",
      x = -283.83,
      y = 806.4,
      z =  119.38,
      h = 321.76
    },
    Saint = {
      name = "Saint",
      x = 2721.4562,
      y = -1446.0975,
      z =  46.2303,
      h = 321.76
    },
    Armadillo = {
      name = "Armadillo",
      x = -3742.5,
      y = -2600.9,
      z =  -13.23,
      h = 321.76
    },
    bw = {
      name = "bw",
      x = -723.9527,
      y = -1242.8358,
      z =  44.7341,
      h = 321.76
    },
    rhodes = {
      name = "rhodes",
      x = 1229.0,
      y = -1306.1,
      z =  76.9,
      h = 321.76
    },
  },
 ----------------------------------------------------------------------------- 
  HeadId =  false,
  HeadIdDistance =  15,
  ModeKey =  true,
  KeyShowIds =  "0x8CC9CD42", -- Press X 
  ActiveEagleEye =  true,
  ActiveDeadEye =  false,

}
---------------------------------------------------------------------------------------

--------------------------- COMMAND PERMISSION GROUP ----------------------------------
Config.Group = {
  Admin = "admin", --- group for all commands including whitelist 
  Mod = "Modertor", --- second group for whitelist
}
---------------------------------------------------------------------------------------

------------------------------- TRANSLATE ---------------------------------------------
Config.Langs = {
  IsConnected = "🚫 Duplicated account connected (steam | rockstar)",
  NoSteam = "🚫 You have to have Steam open, please open Steam & restart RedM",
  NoInWhitelist = "🚫 You are not in the Whitelist",
  NoPermissions = "You don't have enough permissions",
  CheckingIdentifier = "Checking Identifiers",
  LoadingUser = "Loading User",
  BannedUser = "You Are Banned",
  TitleOnDead = "/alertdoctor in chat to request doctors aid",
  SubTitleOnDead = "You can respawn in %s seconds",
  RespawnIn = "You can respawn in  ~e~",
  SecondsMove = "~q~ seconds",
  YouAreCarried = "You are being carried by a person",
  VoiceRangeChanged = "Voice chat range changed to %s meters",
  promptLabel = "Respawn",  -- prompt label.   
  prompt = "Press",  -- prompt group label 
}
--------------------------------------------------------------------------------------


-----------------------------BUILT IN RICH PRESENCE DISCORD --------------------------
Config.maxplayers = 128
Config.appid = nil -- Application ID (Replace this with you own)
Config.biglogo = "synred" -- image assets name for the "large" icon.
Config.biglogodesc = " Redm Server Connect: " -- text when hover over image 
Config.smalllogo = "smallboy"  -- image assets name for the "small" icon.(OPTIONAL)
Config.smalllogodesc = "Join us for a good time" -- text when hover over image 
Config.discordlink = "https://discord.gg/" -- discord link 
Config.shownameandid = true --show player steam name and id 
--------------------------------------------------------------------------------------
