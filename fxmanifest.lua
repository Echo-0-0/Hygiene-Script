fx_version 'cerulean'
game 'gta5'

author 'BootStrap-Development'
description 'A Player Stats Menu Using ox_lib'
version '1.0.0'

lua54 'yes'

-- Initialize ox_lib
shared_script '@ox_lib/init.lua'

-- Server scripts
server_scripts {
    'server.lua'
}

-- Client scripts
client_scripts {
    'client.lua'
}
