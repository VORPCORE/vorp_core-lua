game 'rdr3'
fx_version 'adamant'
author 'goncalobsccosta#9041'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

shared_scripts {
  'config.lua'
}

client_scripts {
  'client/Notifications.js',
  'client/cl_*.lua',
}

server_scripts {
  'server/class/sv_*.lua',
  'server/sv_*.lua',
}

server_exports {'vorpAPI'}

files {
  'ui/hud.html',
  'ui/js/progressbar.js',
  'ui/js/progressbar.min.js',
  'ui/js/progressbar.min.js.map',
  'ui/hud.html',
  'ui/css/style.css',
  'ui/fonts/rdrlino-regular-webfont.woff',
  'ui/icons/gold_2.png',
  'ui/icons/token.png',
}

ui_page 'ui/hud.html'
