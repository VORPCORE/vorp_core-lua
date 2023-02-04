--========================================== FXMANIFEST ==================================================--

fx_version 'adamant'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
lua54 'yes'
description 'A framework '
author 'VORP' -- converted from the original C# vorp core by goncalobsccosta#9041

--=========================================== CONVARS =====================================================--

shared_script 'config.lua'

client_scripts {
  'client/Notifications.lua',
  'client/cl_*.lua',
  'client/cl_commands.lua'
}

server_scripts {
  'server/class/sv_*.lua',
  'server/sv_*.lua',
  'server/services/*.lua',
  'server/services/dbupdater/*.lua',
  '@oxmysql/lib/MySQL.lua'
}

files {
  'ui/**/*',
  'ui/assets/**/*',
  'ui/vendor/*',
  'ui/style/*'
}

ui_page 'ui/index.html'

--========================================== DEPRECATED ====================================================--

server_exports { 'vorpAPI' } -- deprecated refer to the API docs

--======================================= VERSION CHECK =====================================================--

version '2.1'
vorp_checker 'yes'
vorp_name '^4Resource version Check^3'
vorp_github 'https://github.com/VORPCORE/vorp-core-lua'

--===========================================================================================================--
