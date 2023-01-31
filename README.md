---
## VORPcore Lua version
---

If you have the C# version of the core and want to replace it, it's just drag and drop. Everything works without having to change anything!
---
## Requirements
- [oxmysql](https://github.com/VORPCORE/oxmysql) 
- [VORP-Inputs](https://github.com/VORPCORE/vorp-inputs-lua/releases) 
-  for characters use whats in the vorp premade
---
## How to install 
* Rename the folder to ``vorp_core``
* Copy and paste ``vorp_core`` folder to ``[resources]/[vorp_core]``
* Add ensure to the top load order ``vorp_core`` to your ``resources.cfg`` file

---

## Screenshot
![image](https://user-images.githubusercontent.com/10902965/215692452-200c3460-9adc-4437-becc-6bda01ed3cb9.png)

---

## some of the features 
- admin commands 
- client commands
- config file to edit easly for server owners
- UI to display currency such as gold cash xp token.
- API to work with other scripts and exports
- refer to WIKI (link bellow )
- ace permissions and or group DB

---

## Bans, warns and whitelists

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


--
## Add permissions to perms.cfg
```
#############################################################################################
# VORP COMMANDS YOU CAN USE DISCORD ACE PERMS and use roles as permissions. just configure it.
#############################################################################################

add_ace group.admin vorpcore.tpm.Command allow
add_ace group.admin vorpcore.addMoney.Command allow
add_ace group.admin vorpcore.additems.Command allow
add_ace group.admin vorpcore.setGroup.Command allow
add_ace group.admin vorpcore.delCurrency.Command allow
add_ace group.admin vorpcore.addweapons.Command allow
add_ace group.admin vorpcore.setJob.Command allow
add_ace group.admin vorpcore.reviveplayer.Command allow
add_ace group.admin vorpcore.delhorse.Command allow
add_ace group.admin vorpcore.delwagons.Command allow
add_ace group.admin vorpcore.healplayer.Command allow 
add_ace group.admin vorpcore.wlplayer.Command allow
add_ace group.admin vorpcore.unwlplayer.Command allow
add_ace group.admin vorpcore.ban.Command allow
add_ace group.admin vorpcore.unban.Command allow
add_ace group.admin vorpcore.warn.Command allow
add_ace group.admin vorpcore.unwarn.Command allow
## to show the list of commands in chat
add_ace group.admin vorpcore.showAllCommands allow

```
---

## Note

We recommend using the latest version of server artifacts.
- [ARTIFACTS](https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/)

---

## For support 
- [DISCORD](https://discord.gg/DHGVAbCj7N)

---

## Wiki
- [Wiki VORP Core](https://github.com/outsider31000/VORP_API-docs)
---

## Credits
- [VORP-Core](https://github.com/VORPCORE/VORP-Core/releases) This script was based on this C# core.

---

converted by `goncalobsccosta#9041`

---
