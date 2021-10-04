ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('ECLIPSE_PHONE:setContacts')
AddEventHandler('ECLIPSE_PHONE:setContacts', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
	local contactsData = json.decode(data)
    MySQL.Async.fetchScalar('SELECT identifier FROM eclipse_phone_contacts WHERE identifier = @identifier', {
				['@identifier'] = xPlayer.identifier
	}, function(result)
        if result == nil then

            MySQL.Async.execute('INSERT INTO eclipse_phone_contacts (identifier, phoneNumber, contacts) VALUES (@identifier, @phoneNumber, @contacts)',
			{
				['@identifier'] = xPlayer.identifier,
                ['@phoneNumber'] = contactsData.Number,
                ['@contacts'] = json.encode(contactsData.Contacts)
			})
        else
            MySQL.Async.execute('UPDATE eclipse_phone_contacts SET contacts = @contacts WHERE identifier = @identifier', {
                ['@contacts'] = json.encode(contactsData.Contacts),
                ['@identifier'] = xPlayer.identifier
	        })
        end
    end)
end)

RegisterServerEvent('ECLIPSE_PHONE:ChangeBgImage')
AddEventHandler('ECLIPSE_PHONE:ChangeBgImage', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
	local image = json.decode(data)
    MySQL.Async.execute('UPDATE users SET bgImage = @bgImage WHERE identifier = @identifier', {
                ['@bgImage'] = image.bgImage,
                ['@identifier'] = xPlayer.identifier
	})
end)

RegisterServerEvent('ECLIPSE_PHONE:getContacts')
AddEventHandler('ECLIPSE_PHONE:getContacts', function(number)
    local _source  = source
	local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM eclipse_phone_contacts WHERE identifier = @identifier AND phoneNumber = @phoneNumber', {
				['@identifier'] = xPlayer.identifier,
                ['@phoneNumber'] = number
	}, function(result)
        if result[1] then
            TriggerClientEvent("ECLIPSE:SendContactsToNui", _source, result[1].phoneNumber, result[1].contacts)
        end 
    end)
end)

RegisterServerEvent('ECLIPSE_PHONE:sendSecretChatMessage')
AddEventHandler('ECLIPSE_PHONE:sendSecretChatMessage', function(data)
    local _source  = source
	local xPlayer = ESX.GetPlayerFromId(source)
    local messageData = json.decode(data)
    MySQL.Async.execute('INSERT INTO eclipse_phone_coded_chat (`from`, `to`, `text`) VALUES(@from, @to, @text)',
    {
        ['@from'] = messageData.from,
        ['@to'] = messageData.to,
        ['@text'] = messageData.text
    }, function(result) 
        MySQL.Async.fetchScalar('SELECT identifier FROM users WHERE darkNetId = @darkNetId', {
                ['@darkNetId'] = messageData.to
            }, function(result)
                if result then
                    local xTarget = ESX.GetPlayerFromIdentifier(result)
                    if xTarget then
                        local from = messageData.from
                        local to = messageData.to
                        messageData.from = to
                        messageData.to = from
                        TriggerClientEvent("ECLIPSE:SendCodedMessageToNui", xTarget.source, json.encode(messageData))
                    else 
                        TriggerClientEvent("ECLIPSE:PlayerNotOnline", _source)
                    end
                else
                    TriggerClientEvent("ECLIPSE:PlayerNotOnline", _source)
                end
        end)
    end)
end)



RegisterServerEvent('ECLIPSE_PHONE:getMessages')
AddEventHandler('ECLIPSE_PHONE:getMessages', function(number)
    local _source  = source
	local xPlayer = ESX.GetPlayerFromId(source)
    local messages = {}
    MySQL.Async.fetchAll('SELECT * FROM eclipse_phone_messages WHERE playerphone = @playerphone', {
                ['@playerphone'] = number
	}, function(messagesFromPlayer)
        MySQL.Async.fetchAll('SELECT * FROM eclipse_phone_messages WHERE author = @playerphone', {
                ['@playerphone'] = number
        }, function(messagesToPlayer)
            TriggerClientEvent("ECLIPSE:SendMessagesToNui", _source, json.encode(messagesFromPlayer), json.encode(messagesToPlayer))
        end)
    end)
end)

RegisterServerEvent('ECLIPSE_PHONE:GetCodedMessages')
AddEventHandler('ECLIPSE_PHONE:GetCodedMessages', function(number)
    local _source  = source
	local xPlayer = ESX.GetPlayerFromId(source)
    local messages = {}
    MySQL.Async.fetchAll('SELECT * FROM eclipse_phone_coded_chat WHERE `from` = @from', {
                ['@from'] = number
	}, function(messagesFromPlayer)
        MySQL.Async.fetchAll('SELECT * FROM eclipse_phone_coded_chat WHERE `to` = @to', {
                ['@to'] = number
        }, function(messagesToPlayer)
            TriggerClientEvent("ECLIPSE:SetCodedMessages", _source, json.encode(messagesFromPlayer), json.encode(messagesToPlayer))
        end)
    end)
end)

RegisterServerEvent('ECLIPSE_PHONE:GetBleeterLogin')
AddEventHandler('ECLIPSE_PHONE:GetBleeterLogin', function(number)
    local _source  = source
	local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM eclipse_phone_bleeter_logins WHERE playerphone = @playerphone AND identifier = @identifier', {
                ['@playerphone'] = number,
                ['@identifier'] = xPlayer.identifier,
	}, function(result)
        if result[1] then
            TriggerClientEvent("ECLIPSE:SendBleeterLogin", _source, result[1].login)
        end
    end)
end)


RegisterServerEvent('ECLIPSE_PHONE:saveLoginBleeter')
AddEventHandler('ECLIPSE_PHONE:saveLoginBleeter', function(data)
    local _source  = source
	local xPlayer = ESX.GetPlayerFromId(source)
    local loginData = json.decode(data)
    MySQL.Async.fetchAll('SELECT * FROM eclipse_phone_bleeter_logins WHERE identifier = @identifier AND playerPhone = @playerPhone', {
				['@identifier'] = xPlayer.identifier,
                ['@playerPhone'] = loginData.playerPhone
	}, function(result)
        if result[1] then
            MySQL.Async.insert("UPDATE eclipse_phone_bleeter_logins SET login = @login WHERE identifier = @identifier AND playerPhone = @playerPhone", { 
                    ['@identifier'] = xPlayer.identifier,
                    ['@playerPhone'] = loginData.playerPhone,
                    ['@login'] = loginData.login,
            }, function ()
                    
            end)
        else 
            MySQL.Async.execute('INSERT INTO eclipse_phone_bleeter_logins (`identifier`, `playerPhone`, `login`) VALUES(@identifier, @playerPhone, @login)',
            {
                ['@identifier'] = xPlayer.identifier,
                ['@playerPhone'] = loginData.playerPhone,
                ['@login'] = loginData.login,
            }, function(result) 
            end)
        end
    end)
end)

AddEventHandler('esx:playerLoaded', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    --local xTarget = ESX.GetPlayerFromIdentifier(result[1].sender)
    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
				['@identifier'] = xPlayer.identifier,
	}, function(result)
        if result[1] then
            if result[1].phone_number ~= nil then
                TriggerClientEvent("ECLIPSE:getContacts", source, result[1].phone_number)
                TriggerClientEvent("ECLIPSE:getMessages", source, result[1].phone_number)
                local name = xPlayer.get('firstName') .. ' ' .. xPlayer.get('lastName')
                local job = xPlayer.job.name
                TriggerClientEvent("ECLIPSE:SetPlayerName", source, name, job, result[1].phone_number)
                TriggerClientEvent("ECLIPSE:GetNews", source)
                TriggerClientEvent("ECLIPSE:GetBleeterMessages", source)
                TriggerClientEvent("ECLIPSE:GetBleeterLogin", source, result[1].phone_number)
            else 
                number = getPhoneRandomNumber()
                MySQL.Async.insert("UPDATE users SET phone_number = @number WHERE identifier = @identifier", { 
                    ['@number'] = number,
                    ['@identifier'] = xPlayer.identifier
                }, function ()
                    TriggerClientEvent("ECLIPSE:getContacts", source, number)
                    TriggerClientEvent("ECLIPSE:getMessages", source, number)
                    local name = xPlayer.get('firstName') .. ' ' .. xPlayer.get('lastName')
                    local job = xPlayer.job.name
                    TriggerClientEvent("ECLIPSE:SetPlayerName", source, name, job, number)
                    TriggerClientEvent("ECLIPSE:GetNews", source)
                    TriggerClientEvent("ECLIPSE:GetBleeterMessages", source)
                    TriggerClientEvent("ECLIPSE:GetBleeterLogin", number)
                end)
            end
            if result[1].darkNetId ~= nil then
                TriggerClientEvent("ECLIPSE:SendDarkNetId", source, result[1].darkNetId)
                TriggerClientEvent("ECLIPSE:GetCodeMessages", source, result[1].darkNetId)
            else 
                local darkNetId = GetRandomDarkNetId()
                MySQL.Async.insert("UPDATE users SET darkNetId = @darkNetId WHERE identifier = @identifier", { 
                    ['@darkNetId'] = darkNetId,
                    ['@identifier'] = xPlayer.identifier
                }, function (result)
                    TriggerClientEvent("ECLIPSE:SendDarkNetId", source, darkNetId)
                    TriggerClientEvent("ECLIPSE:GetCodeMessages", source, darkNetId)
                end)
            end
            TriggerClientEvent("ECLIPSE:LoadDarkNetAnon", source)
            TriggerClientEvent("ECLIPSE:GetAnonMessage", source)
            TriggerClientEvent('ECLIPSE:GetAdds', source)
            if result[1].bgImage ~= nil then
                TriggerClientEvent('ECLIPSE:ChangeBgImage', source, result[1].bgImage)
            end
        end
    end)
end)

function getPhoneRandomNumber()
    local numBase0 = math.random(100,999)
    local numBase1 = math.random(0,9999)
    local num = string.format("%03d-%04d", numBase0, numBase1)

	return num
end

function GetRandomDarkNetId() 
    local numBase0 = math.random(100,999)
    local numBase1 = math.random(0,9999)
    local num = string.format("%03d%04d", numBase0, numBase1)

	return num
end

RegisterServerEvent('ECLIPSE_PHONE:setMessage')
AddEventHandler('ECLIPSE_PHONE:setMessage', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
	local messageData = json.decode(data)
    MySQL.Async.execute('INSERT INTO eclipse_phone_messages (`from`, `readed`, `numb`, `date`, `message`, `author`, `playerphone`) VALUES(@from, @readed, @numb, @date, @message, @author, @playerphone)',
	{
		['@from'] = messageData.from,
        ['@readed'] = messageData.readed,
        ['@numb'] = messageData.numb,
        ['@date'] = messageData.date,
        ['@message'] = messageData.message,
        ['@author'] = messageData.author,
        ['@playerphone'] = messageData.playerphone
	}, function(result) 
        MySQL.Async.fetchScalar('SELECT identifier FROM users WHERE phone_number = @phone_number', {
                ['@phone_number'] = messageData.author
            }, function(result)
                if result then
                    local xTarget = ESX.GetPlayerFromIdentifier(result)
                    if xTarget then
                        TriggerClientEvent('esx:showNotification', xTarget.source, "New sms")
                        TriggerClientEvent("ECLIPSE:SendMessageToNui", xTarget.source, json.encode(messageData))
                    else 
                        TriggerClientEvent("ECLIPSE:PlayerNotOnline", _source)
                    end
                else
                    TriggerClientEvent("ECLIPSE:PlayerNotOnline", _source)
                end
        end)
    end)
end)

RegisterServerEvent('ECLIPSE_PHONE:isPlayerOnline')
AddEventHandler('ECLIPSE_PHONE:isPlayerOnline', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
    local _source  = source
    local playerData = json.decode(data)
    MySQL.Async.fetchScalar('SELECT identifier FROM users WHERE phone_number = @phone_number', {
                ['@phone_number'] = playerData.number
	}, function(result)
        if result then
            local xTarget = ESX.GetPlayerFromIdentifier(result)
            if xTarget then 
                TriggerClientEvent("ECLIPSE:PlayerOnline", _source)
            else 
                TriggerClientEvent("ECLIPSE:PlayerNotOnline", _source)
            end
        else
            TriggerClientEvent("ECLIPSE:PlayerNotOnline", _source)
        end
    end)
end)

RegisterServerEvent('ECLIPSE_PHONE:tryStartCall')
AddEventHandler('ECLIPSE_PHONE:tryStartCall', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
    local _source  = source
    local numbersData = json.decode(data)
    MySQL.Async.fetchScalar('SELECT identifier FROM users WHERE phone_number = @phone_number', {
                ['@phone_number'] = numbersData.targetNumber
	}, function(result)
        if result then
            local xTarget = ESX.GetPlayerFromIdentifier(result)
            if xTarget then 
                TriggerClientEvent("ECLIPSE:StartCall", xTarget.source, numbersData.playerNumber)
            else 
                TriggerClientEvent("ECLIPSE:PlayerNotOnline", _source)
            end
        else
            TriggerClientEvent("ECLIPSE:PlayerNotOnline", _source)
        end
    end)
end)

RegisterServerEvent('ECLIPSE_PHONE:AcceptCall')
AddEventHandler('ECLIPSE_PHONE:AcceptCall', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
    local _source  = source
    local numbersData = json.decode(data)
    MySQL.Async.fetchScalar('SELECT identifier FROM users WHERE phone_number = @phone_number', {
                ['@phone_number'] = numbersData.targetNumber
	}, function(result)
        if result then
            local xTarget = ESX.GetPlayerFromIdentifier(result)
            if xTarget then
                TriggerClientEvent("ECLIPSE:AcceptCall", _source, _source, numbersData.targetNumber)
                TriggerClientEvent("ECLIPSE:AcceptCall", xTarget.source, _source, numbersData.playerNumber)
                TriggerClientEvent("ECLIPSE:CallStarted", xTarget.source, numbersData.playerNumber)
            else 
                TriggerClientEvent("ECLIPSE:PlayerNotOnline", _source)
            end
        else
            TriggerClientEvent("ECLIPSE:PlayerNotOnline", _source)
        end
    end)
end)

RegisterServerEvent('ECLIPSE_PHONE:DeclineCall')
AddEventHandler('ECLIPSE_PHONE:DeclineCall', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
    local _source  = source
    local numbersData = json.decode(data)
    MySQL.Async.fetchScalar('SELECT identifier FROM users WHERE phone_number = @phone_number', {
                ['@phone_number'] = numbersData.targetNumber
	}, function(result)
        if result then
            local xTarget = ESX.GetPlayerFromIdentifier(result)
            if xTarget then
                TriggerClientEvent("ECLIPSE:DeclineCall", _source)
                TriggerClientEvent("ECLIPSE:DeclineCall", xTarget.source)
                TriggerClientEvent("ECLIPSE:TargetStopCall", xTarget.source)
            else 
                TriggerClientEvent("ECLIPSE:PlayerNotOnline", _source)
                TriggerClientEvent("ECLIPSE:DeclineCall", _source)
            end
        else
            TriggerClientEvent("ECLIPSE:DeclineCall", _source)
            TriggerClientEvent("ECLIPSE:PlayerNotOnline", _source)
        end
    end)
end)

RegisterServerEvent('ECLIPSE_PHONE:AddNews')
AddEventHandler('ECLIPSE_PHONE:AddNews', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
	local messageData = json.decode(data)
    MySQL.Async.execute('INSERT INTO eclipse_phone_weazel (`title`, `subtitle`, `material`, `image`, `author`, `date`) VALUES(@title, @subtitle, @material, @image, @author, @date)',
	{
		['@title'] = messageData.title,
        ['@subtitle'] = messageData.subtitle,
        ['@material'] = messageData.material,
        ['@image'] = messageData.image,
        ['@author'] = messageData.author,
        ['@date'] = messageData.date,
	}, function(result) 

    end)
end)

RegisterServerEvent('ECLIPSE_PHONE:sendAnonMessage')
AddEventHandler('ECLIPSE_PHONE:sendAnonMessage', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
	local messageData = json.decode(data)
    MySQL.Async.execute('INSERT INTO eclipse_phone_anon_chat (`from`, `text`) VALUES(@from, @text)',
	{
		['@from'] = messageData.from,
        ['@text'] = messageData.text,
	}, function(result) 
        for i=1, #xPlayers, 1 do
            TriggerClientEvent('ECLIPSE:GetAnonMessage', xPlayers[i])
        end    
    end)
end)

RegisterServerEvent('ECLIPSE_PHONE:AddAds')
AddEventHandler('ECLIPSE_PHONE:AddAds', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
	local messageData = json.decode(data)
    MySQL.Async.execute('INSERT INTO eclipse_phone_8dynasty (`category`, `date`, `text`, `author`, `image`, `playerPhone`) VALUES(@category, @date, @text, @author, @image, @playerPhone)',
	{
		['@category'] = messageData.category,
        ['@date'] = messageData.date,
        ['@text'] = messageData.text,
        ['@author'] = messageData.author,
        ['@image'] = messageData.image,
        ['@playerPhone'] = messageData.playerPhone,
	}, function(result) 
        for i=1, #xPlayers, 1 do
            TriggerClientEvent('ECLIPSE:GetAdds', xPlayers[i])
        end    
    end)
end)



RegisterServerEvent('ECLIPSE_PHONE:sendNewBleet')
AddEventHandler('ECLIPSE_PHONE:sendNewBleet', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
	local messageData = json.decode(data)
    MySQL.Async.execute('INSERT INTO eclipse_phone_bleeter (`text`, `author`, `authorImage`, `image`, `date`, `authorPhone`) VALUES(@text, @author, @authorImage, @image, @date, @authorPhone)',
	{
		['@text'] = messageData.text,
        ['@author'] = messageData.author,
        ['@authorImage'] = messageData.authorImage,
        ['@image'] = messageData.image,
        ['@authorPhone'] = messageData.authorPhone,
        ['@date'] = messageData.date,
	}, function(result) 
        for i=1, #xPlayers, 1 do
            TriggerClientEvent('ECLIPSE:GetBleeterMessages', xPlayers[i], data)
        end        
    end)
end)

RegisterServerEvent('ECLIPSE_PHONE:DeleteNews')
AddEventHandler('ECLIPSE_PHONE:DeleteNews', function(data)
	local xPlayer = ESX.GetPlayerFromId(source)
	local messageData = json.decode(data)
    MySQL.Async.execute('DELETE FROM eclipse_phone_weazel WHERE id = @id',
	{
		['@id'] = messageData.id,
	}, function(result) 

    end)
end)

RegisterServerEvent('ECLIPSE_PHONE:AmbulancePanicButton')
AddEventHandler('ECLIPSE_PHONE:AmbulancePanicButton', function(data, service)
	local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
	--local victimData = json.decode(data)
    local _source  = source
    --print(victimData.victimPosition)
    -- local cops = 0  
	-- for i=1, #xPlayers, 1 do
	-- 	local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
	-- 	if xPlayer.job.name == 'police' then
	-- 		cops = cops + 1
	-- 	end
	-- end
    if service == 'ambulance' then
        TriggerClientEvent('esx:showNotification', _source, "You called an ambulance")
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer.job.name == 'ambulance' then
                TriggerClientEvent('esx:showNotification', xPlayers[i], "Panic alarm. Drive to the scene")
                TriggerClientEvent('esx_holdup:setBlip', xPlayers[i], data)
            end
        end
    elseif service == 'police' then
        TriggerClientEvent('esx:showNotification', _source, "You called police")
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer.job.name == 'police' then
                TriggerClientEvent('esx:showNotification', xPlayers[i], "Panic alarm. Drive to the scene")
                TriggerClientEvent('esx_holdup:setBlip', xPlayers[i], data)
            end
        end
    end
end)

RegisterServerEvent('ECLIPSE_PHONE:AmbulanceCall')
AddEventHandler('ECLIPSE_PHONE:AmbulanceCall', function(data, position, service, date)
	local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()
    local victimData = json.decode(data)
    local _source  = source
    if service == 'ambulance' then
        TriggerClientEvent('esx:showNotification', _source, "You called an ambulance")
        MySQL.Async.execute('INSERT INTO eclipse_phone_ambulance_calls (`PlayerName`, `PlayerPhone`, `Message`, `Date`) VALUES(@PlayerName, @PlayerPhone, @Message, @Date)',
        {
            ['@PlayerName'] = victimData.PlayerName,
            ['@PlayerPhone'] = victimData.PlayerPhone,
            ['@Message'] = victimData.Message,
            ['@Date'] = date,
        }, function(result) 

        end)
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer.job.name == 'ambulance' then
                TriggerClientEvent('esx:showNotification', xPlayers[i], victimData.PlayerPhone..' '..victimData.PlayerName..': '..victimData.Message)
                TriggerClientEvent('esx_holdup:setBlip', xPlayers[i], position)
            end
        end
    elseif service == 'police' then
        TriggerClientEvent('esx:showNotification', _source, "You called police")
        MySQL.Async.execute('INSERT INTO eclipse_phone_police_calls (`PlayerName`, `PlayerPhone`, `Message`, `Date`) VALUES(@PlayerName, @PlayerPhone, @Message, @Date)',
        {
            ['@PlayerName'] = victimData.PlayerName,
            ['@PlayerPhone'] = victimData.PlayerPhone,
            ['@Message'] = victimData.Message,
            ['@Date'] = date,
        }, function(result) 
               
        end)
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer.job.name == 'police' then
                TriggerClientEvent('esx:showNotification', xPlayers[i], victimData.PlayerPhone..' '..victimData.PlayerName..': '..victimData.Message)
                TriggerClientEvent('esx_holdup:setBlip', xPlayers[i], position)
            end
        end
    end
end)

RegisterServerEvent('ECLIPSE_PHONE:GetNews')
AddEventHandler('ECLIPSE_PHONE:GetNews', function(number)
    local _source  = source
	local xPlayer = ESX.GetPlayerFromId(source)
    local messages = {}
    MySQL.Async.fetchAll('SELECT * FROM eclipse_phone_weazel', {

	}, function(data)
        TriggerClientEvent("ECLIPSE:SendNewsToNui", _source, json.encode(data))
    end)
end)

RegisterServerEvent('ECLIPSE_PHONE:GetAdds')
AddEventHandler('ECLIPSE_PHONE:GetAdds', function(number)
    local _source  = source
	local xPlayer = ESX.GetPlayerFromId(source)
    local messages = {}
    MySQL.Async.fetchAll('SELECT * FROM eclipse_phone_8dynasty', {

	}, function(data)
        TriggerClientEvent("ECLIPSE:SendAddsToNui", _source, json.encode(data))
    end)
end)

RegisterServerEvent('ECLIPSE_PHONE:GetAnonChatMessage')
AddEventHandler('ECLIPSE_PHONE:GetAnonChatMessage', function(number)
    local _source  = source
	local xPlayer = ESX.GetPlayerFromId(source)
    local messages = {}
    MySQL.Async.fetchAll('SELECT * FROM eclipse_phone_anon_chat', {

	}, function(data)
        TriggerClientEvent("ECLIPSE:SendAnonChatMessage", _source, json.encode(data))
    end)
end)

RegisterServerEvent('ECLIPSE_PHONE:GetBleeterMessages')
AddEventHandler('ECLIPSE_PHONE:GetBleeterMessages', function()
    local _source  = source
	local xPlayer = ESX.GetPlayerFromId(source)
    local messages = {}
    MySQL.Async.fetchAll('SELECT * FROM eclipse_phone_bleeter', {

	}, function(data)
        TriggerClientEvent("ECLIPSE:SendBleeterMessageToNui", _source, json.encode(data))
    end)
end)