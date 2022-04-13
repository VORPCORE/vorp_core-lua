fx_version 'adamant'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'goncalobsccosta#9041'

shared_scripts {
  'config.lua'
}

client_scripts {
  'client/Notifications.js',
  'client/cl_adminactions.lua',
  'client/cl_callback.lua',
  'client/cl_clientapi.lua',
  'client/cl_controls.lua',
  'client/cl_discrichpresence.lua',
  'client/cl_idheads.lua',
  'client/cl_instance.lua',
  'client/cl_miscellanea.lua',
  'client/cl_notifications.lua',
  'client/cl_playeractions.lua',
  'client/cl_respawnsystem.lua',
  'client/cl_spawnplayer.lua',
  'client/cl_uicore.lua',
  'client/cl_voicechat.lua',
  'client/cl_dataview.lua'
}

server_scripts {
  'server/class/sv_character.lua',
  'server/class/sv_user.lua',
  'server/sv_apicontroller.lua',
  'server/sv_callbacks.lua',
  'server/sv_commands.lua',
  'server/sv_discrichpresence.lua',
  'server/sv_init.lua',
  'server/sv_loadcarachter.lua',
  'server/sv_loadusers.lua',
  'server/sv_old_luapi.lua',
  'server/sv_savecoordsdb.lua',
  'server/sv_whitelist.lua',
}

server_exports {'vorpAPI'}

files {
  'ui/hud.html',
  'ui/css/style.css',
  'ui/js/progressbar.js',
  'ui/js/progressbar.min.js',
  'ui/js/progressbar.min.js.map',
  'ui/fonts/HapnaSlabSerif-DemiBold.ttf',
  'ui/fonts/RDRCatalogueBold-Bold.ttf',
  'ui/fonts/RDRGothica-Regular.ttf',
  'ui/fonts/RDRLino-Regular.ttf',
  'ui/fonts/rdrlino-regular-webfont.woff',
  'ui/fonts/rdrlino-regular-webfont.woff2',
  'ui/fonts/Redemption.ttf',
  'ui/icons/*.png',
}

ui_page 'ui/hud.html'
