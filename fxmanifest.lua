fx_version "cerulean"

description "Cityhall Job Center"
author "MoneSuper"
version '1.0.0'

lua54 'yes'

games {
  "gta5",
  "rdr3"
}

ui_page 'web/build/index.html'

shared_script {
  'shared/config.lua',
  '@ox_lib/init.lua',
}

shared_script {
  'shared/config.lua',
}

client_script "client/**/*"
server_script "server/**/*"

files {
	'web/build/index.html',
	'web/build/**/*',
  'assets/1.jpeg',
  'assets/2.jpeg',
  'locales/*.json',
}

lua54 'yes'

escrow_ignore {
  'shared/config.lua',
}
