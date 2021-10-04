fx_version "adamant"
games {"gta5"}

client_script {'phone.net.dll'}
server_script {'server.lua', '@mysql-async/lib/MySQL.lua',}

files {
    'Newtonsoft.Json.dll',
    'data/index.html',

    'data/bootstrap.css',
    'data/background.jpg',
    'data/css/*.css',
    'data/fonts/*.woff',
    'data/img/*.png',
    'data/img/*.jpg',
    'data/js/*.js',
    'data/js/*.js.map',
}

ui_page_preload 'yes'
ui_page 'data/index.html'
