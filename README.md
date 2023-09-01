
## VORPcore Lua version


### Requirements
- [oxmysql](https://github.com/VORPCORE/oxmysql) 

### How to install 
* Rename the folder to ``vorp_core``
* Copy and paste ``vorp_core`` folder to ``[resources]/[vorp_core]``
* Add ensure to the top load order ``vorp_core`` to your ``resources.cfg`` file

---

### features 
- admin commands 
- client commands
- UI to display currency such as gold cash xp token.
- API to work with other scripts and exports
- ace permissions and or group DB
- notifications can be used as exports or declare in your script fxmanifest
- callback system client and server
```lua
client_scripts {
  "@vorp_core/client/ref/vorp_notifications.lua"
}
```

### Admin

Whitelisting, banning and warning is based on static user-ids that can be changed only in the database. 
**Important!** Setup the *NewPlayerWebhook* to get player's user-id on first connection.
- to ban use `/ban <user-id> <length>[d/w/m/y]`, where d is days, w is weeks, m is months (30 days a month), y is years (365 days a year) or nothing for hours. Example `/ban 1 3d` for 3 days ban or `/ban 1 12` for 12 hours ban
- to ban permamnently `/ban <user-id> 0`
- to unban `/unban <user-id>`
- to warn `/warn <user-id>`
- to unwarn `/unwarn <user-id>`
- to whitelist `/wlplayer <user-id>`
- to unwhitelist `/unwlplayer <user-id>`
The user-id will be send to your discord **only** when *NewPlayerWebhook* is setup in config.
![image](https://i.imgur.com/cWlyIC8.png)



### For support 
- [DISCORD](https://discord.gg/DHGVAbCj7N)

### Credits
- [VORP-Core](https://github.com/VORPCORE/VORP-Core/releases) This script was based on this C# core.
---
converted by `goncalobsccosta#9041`

