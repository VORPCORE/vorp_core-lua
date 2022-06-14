## VORPcore Lua version
VORP CORE for RedM made in LUA! Finally!

If you have the C# version of the core and want to replace it, it's just drag and drop. Everything works without having to change anything!

## Requirements
- [ghmattimysql](https://github.com/VORPCORE/ghmattimysql-oxmysql) - is the new oxmysql
- [VORP-Inputs](https://github.com/VORPCORE/VORP-Inputs/releases) 
- [VORP-Character](https://github.com/VORPCORE/VORP-Character/releases)

## How to install (Remember to download the lastest releases)
* Rename the folder to ``vorp_core``
* install `SQL` file provided
* Copy and paste ``vorp_core`` folder to ``[resources]/[vorp_core]``
* Add ensure to the top load order ``vorp_core`` to your ``resources.cfg`` file


# These resources will start by default `example`
```
#MYSQL
ensure ghmattimysql

#VORP Core
ensure vorp_core
ensure vorp_inputs

#VORP Scripts
ensure vorp_character
ensure vorp_inventory
ensure vorp_metabolism
ensure vorp_clothingstore
ensure vorp_stables
ensure vorp_adminmenu
ensure vorp_stores
ensure vorp_weaponstore
ensure vorp_banks
ensure vorp_barbershops
ensure vorp_cinema
ensure vorp_housing
ensure vorp_postman
ensure vorp_woodcutter
```
## some of the features 

- admin commands 
- client commands
- config file to edit easly for server owners
- UI to display currency such as gold cash xp token.
- API to work with other scripts and exports
- refer to WIKI (link bellow )

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

## Note

We recommend using the latest version of server artifacts.
- [ARTIFACTS](https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/)

## For support 
- [DISCORD](https://discord.gg/DHGVAbCj7N)

## Wiki
- [Wiki VORP Core](http://docs.vorpcore.com:3000/home)

## Credits
- [VORP-Core](https://github.com/VORPCORE/VORP-Core/releases) This script was based on this core.



converted by `goncalobsccosta#9041`
