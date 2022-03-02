## VORP-CORE LUA
This is the new VORP CORE for RedM made in LUA! Finally!

If you have the C# version of the core and want to replace it, it's just drag and drop. Everything works without having to change anything!

For more questions message me on Discord: goncalobsccosta#9041

## Requirements
- [ghmattimysql](https://github.com/GHMatti/ghmattimysql/releases)
- [VORP-Inputs](https://github.com/VORPCORE/VORP-Inputs/releases)
- [VORP-Character](https://github.com/VORPCORE/VORP-Character/releases)

## How to install (Remember to download the lastest releases)
* Download ghmattimysql
* Copy and paste ``ghmattimysql`` folder to ``resources/ghmattimysql``
* Delete file ``resources/ghmattimysql/config.json``
* Add ``set mysql_connection_string "mysql://root:@localhost/vorp?acquireTimeout=60000&connectTimeout=60000"`` to your server.cfg file
* Add ``ensure ghmattimysql`` to your ``server.cfg`` file

* To change the language of the core go to ``resources/vorp_core/config.lua`` and change the default language (Same for other scripts)
* Copy and paste ``vorp_core`` folder to ``resources/[vorp]`` (Same for other scripts)
* Add ensure ``vorp_core`` to your ``server.cfg`` file (Same for other scripts)
* Example Server.cfg

```cfg
set mysql_connection_string "mysql://root:yourDBpassword(If you dont have one, leave this blank)@localhost/vorp?acquireTimeout=60000&connectTimeout=60000"

#These resources will start by default.
stop sessionmanager
stop webadmin
stop monitor
ensure mapmanager
ensure chat
ensure spawnmanager
ensure sessionmanager-rdr3
ensure fivem
#ensure hardcap
ensure rconlog
ensure interiors

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

## Note

The scripts may have an SQL file, you need to create a database and execute the SQL files.

We recommend to download and add the all the scripts to the server together before creating a character if you are going to test the scripts (Specially for vorp_metabolism and vorp_inventory).
We also recommend using the 2619 version of server artifacts.

Now you are ready!

## Wiki
[Wiki VORP Core](http://docs.vorpcore.com:3000/home)

## Credits
[VORP-Core](https://github.com/VORPCORE/VORP-Core/releases) This script was based on this core.
