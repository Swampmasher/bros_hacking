ESX = nil
level1 = 20
level2 = 35
level3 = 80
level4 = 1100


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('bros_hacking:copCount', function(source, cb)
	local xPlayers = ESX.GetPlayers()

	copConnected = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
			copConnected = copConnected + 1
		end
	end

	cb(copConnected)
end)

RegisterCommand('hackertablet', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM bros_hacking WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier}, function(result)
		if result[1] == nil then
			MySQL.Async.execute('INSERT INTO bros_hacking (identifier) VALUES (@identifier)',{
				['@identifier'] = xPlayer.identifier})
		else
			if result[1].level == 0 and result[1].currentexp >= level1 then
				MySQL.Async.execute("UPDATE bros_hacking SET level = @level WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier, ['level'] = 1})
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Access to Level 1 features unlocked!', length = 4000})
			elseif result[1].level == 1 and result[1].currentexp >= level2 then
				MySQL.Async.execute("UPDATE bros_hacking SET level = @level WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier, ['level'] = 2})
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Access to Level 2 features unlocked!', length = 4000})
			elseif result[1].level == 2 and result[1].currentexp >= level3 then
				MySQL.Async.execute("UPDATE bros_hacking SET level = @level WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier, ['level'] = 3})
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Access to Level 3 features unlocked', length = 4000})
			elseif result[1].level == 3 and result[1].currentexp >= level4 then
				MySQL.Async.execute("UPDATE bros_hacking SET level = @level WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier, ['level'] = 4})
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Access to Level 4features unlocked!', length = 4000})
			elseif result[1].level == 4 and result[1].currentexp >= level5 then
				MySQL.Async.execute("UPDATE bros_hacking SET level = @level WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier, ['level'] = 5})
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Access to Level 5 features unlocked!', length = 4000})
			end
		end
	end)
	TriggerClientEvent('bros_hacking:usedTablet', source)

end)

ESX.RegisterServerCallback('bros_hacking:getItemAmount', function(source, cb, item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer ~= nil then
		local items = xPlayer.getInventoryItem(item)
		if items == nil then
			cb(0)
		else
			cb(items.count)
		end
	end
end)

ESX.RegisterServerCallback('bros_hacking:getLevel', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll('SELECT * FROM bros_hacking WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier,
	}, function(result)
		if result[1] ~= nil then
			cb(result[1].level, result[1].currentexp)
		else
			cb(0)
		end
	end)
end)

ESX.RegisterServerCallback('bros_hacking:getIdent', function(source, cb, phone_number)
	MySQL.Async.fetchAll('SELECT * FROM users WHERE phone_number = @phone_number', {
		['@phone_number'] = phone_number,
	}, function(result)
		if result[1] ~= nil then
			MySQL.Async.fetchAll('SELECT * FROM jobs WHERE name = @name', {
				['@name'] = result[1].job,
			}, function(jlabel)
				if jlabel[1] ~= nil then
					results = {}
					table.insert(results, {
						job   = jlabel[1].label,
						name  = result[1].firstname,
						lname  = result[1].lastname
					})

					cb(jlabel[1].label, result[1].firstname, result[1].lastname)
				else
					cb(nil)
				end
			end)
		else
			cb(nil)
		end
	end)
end)

ESX.RegisterServerCallback('bros_hacking:getIdentfromPh', function(source, cb, phone_number)
	MySQL.Async.fetchAll('SELECT * FROM users WHERE phone_number = @phone_number', {['@phone_number'] = phone_number}, function(result)
		if result[1] ~= nil then
			local xPlayers = ESX.GetPlayers()

			for i=1, #xPlayers, 1 do
				local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
				if xPlayer.identifier == result[1].identifier then
					cb(tonumber(xPlayer.source))
				end
			end
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'Phone number not found!', length = 4000})
			cb(0)
		end
	end)
end)

ESX.RegisterUsableItem('hackertablet', function(source)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	MySQL.Async.fetchAll('SELECT * FROM bros_hacking WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier}, function(result)
		if result[1] == nil then
			MySQL.Async.execute('INSERT INTO bros_hacking (identifier) VALUES (@identifier)',{
				['@identifier'] = xPlayer.identifier})
		else
			if result[1].level == 0 and result[1].currentexp >= level1 then
				MySQL.Async.execute("UPDATE bros_hacking SET level = @level WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier, ['level'] = 1})
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Access to Level 1 features unlocked!', length = 4000})
			elseif result[1].level == 1 and result[1].currentexp >= level2 then
				MySQL.Async.execute("UPDATE bros_hacking SET level = @level WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier, ['level'] = 2})
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Access to Level 2 features unlocked!', length = 4000})
			elseif result[1].level == 2 and result[1].currentexp >= level3 then
				MySQL.Async.execute("UPDATE bros_hacking SET level = @level WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier, ['level'] = 3})
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Access to Level 3 features unlocked', length = 4000})
			elseif result[1].level == 3 and result[1].currentexp >= level4 then
				MySQL.Async.execute("UPDATE bros_hacking SET level = @level WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier, ['level'] = 4})
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Access to Level 4features unlocked!', length = 4000})
			elseif result[1].level == 4 and result[1].currentexp >= level5 then
				MySQL.Async.execute("UPDATE bros_hacking SET level = @level WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier, ['level'] = 5})
				TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = 'Access to Level 5 features unlocked!', length = 4000})
			end
		end
	end)
	TriggerClientEvent('bros_hacking:usedTablet', source)
end)

RegisterServerEvent('bros_hacking:giveMoney')
AddEventHandler('bros_hacking:giveMoney', function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.addBank(money)
	TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = '' .. money .. 'you won $!', length = 4000})
end)

RegisterServerEvent('bros_hacking:giveExp')
AddEventHandler('bros_hacking:giveExp', function(exp)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll('SELECT * FROM bros_hacking WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier}, function(result)

		MySQL.Async.execute("UPDATE bros_hacking SET currentexp = @currentexp WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier, ['currentexp'] = result[1].currentexp + exp})
		TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'inform', text = '' .. exp .. ' you have gained experience points!', length = 4000})

	end)
end)

RegisterServerEvent('bros_hacking:copNotify')
AddEventHandler('bros_hacking:copNotify', function()
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' then
			TriggerClientEvent('bros_hacking:copNotifyC', xPlayer.source)
		end
	end
end)

RegisterServerEvent('bros_hacking:blip')
AddEventHandler('bros_hacking:blip', function(hackerPos)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' or xPlayer.job.name == 'sheriff' then
			TriggerClientEvent('bros_hacking:blipC', xPlayer.source, hackerPos)
		end
	end
end)


RegisterServerEvent('bros_hacking:engineCrash')
AddEventHandler('bros_hacking:engineCrash', function(vehicle)
	local xPlayers = ESX.GetPlayers()

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('bros_hacking:engineCrashC', xPlayer.source, vehicle)
	end
end)

ESX.RegisterServerCallback('bros_hacking:getTime', function(source, cb)
	cb(os.time())
end)

ESX.RegisterServerCallback('bros_hacking:bankTime', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll('SELECT * FROM bros_hacking WHERE identifier = @identifier', {['@identifier'] = xPlayer.identifier}, function(result)
		if result[1] then
			cb(result[1].banktime)
		else
			cb(nil)
		end
	end)
end)

RegisterServerEvent('bros_hacking:bankTimeUpdate')
AddEventHandler('bros_hacking:bankTimeUpdate', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.execute("UPDATE bros_hacking SET banktime = @banktime WHERE identifier = @identifier", {['@identifier'] = xPlayer.identifier, ['banktime'] = os.time()})
end)

RegisterServerEvent('bros_hacking:stealBank')
AddEventHandler('bros_hacking:stealBank', function(phone_number)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll('SELECT * FROM users WHERE phone_number = @phone_number', {['@phone_number'] = phone_number}, function(result)
		if result[1] ~= nil then
			local xPlayers = ESX.GetPlayers()

			for i=1, #xPlayers, 1 do
				local xTarget = ESX.GetPlayerFromId(xPlayers[i])
				if xTarget.identifier == result[1].identifier then
					local money = result[1].bank / 20
					xTarget.removeBank(money)
					TriggerClientEvent('mythic_notify:client:SendAlert', xTarget.source, { type = 'error', text = 'Hackers robbed your bank account! You lost 5% of money!', length = 4000})
					xPlayer.addBank(money)
				end
			end
		else
			TriggerClientEvent('mythic_notify:client:SendAlert', _source, { type = 'error', text = 'Phone number not found!', length = 4000})
		end
	end)
end)


ESX.RegisterUsableItem("hackv1", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
		TriggerClientEvent('hack:v1', source)
end)

ESX.RegisterUsableItem("hackv2", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
		TriggerClientEvent('hack:v2', source)
end)

ESX.RegisterUsableItem("hackv3", function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
		TriggerClientEvent('hack:v3', source)
end)

RegisterServerEvent('bros_hacking:v1reward')
AddEventHandler('bros_hacking:v1reward', function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(source)
	local givebitcoin = math.random(Config.V1MinBitcoin, Config.V1MaxBitcoin)
    xPlayer.addInventoryItem(Config.Bitcoinitem, givebitcoin)
end)

RegisterServerEvent('bros_hacking:v2reward')
AddEventHandler('bros_hacking:v2reward', function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(source)
	local givebitcoin2 = math.random(Config.V2MinBitcoin,Config.V2MaxBitcoin)
    xPlayer.addInventoryItem(Config.Bitcoinitem,givebitcoin2)
end)

RegisterServerEvent('bros_hacking:v3reward')
AddEventHandler('bros_hacking:v3reward', function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(source)
	local givebitcoin3 = math.random(Config.V3MinBitcoin,Config.V3MaxBitcoin)
    xPlayer.addInventoryItem(Config.Bitcoinitem,givebitcoin3)
end)

RegisterServerEvent('bros_hacking:givehacktablet')
AddEventHandler('bros_hacking:givehacktablet', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer.getInventoryItem(Config.Bitcoinitem).count >= Config.HackerTabletBitcoinPrice then
        if xPlayer.canCarryItem(Config.Hackertabletitem, 1) then
			Citizen.Wait(250)
            xPlayer.removeInventoryItem(Config.Bitcoinitem, Config.HackerTabletBitcoinPrice)
            Citizen.Wait(500)
            xPlayer.addInventoryItem(Config.Hackertabletitem, 1)
        else
            TriggerClientEvent('esx:showNotification', src, 'There is no place on it to carry it!')
        end
    end
end)

RegisterNetEvent("bros_hacking:givehackv1tablet")
AddEventHandler("bros_hacking:givehackv1tablet", function(item, count)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            if xPlayer.getMoney(Config.Hackv1Price) >= Config.Hackv1Price then
				xPlayer.removeMoney(Config.Hackv1Price)
				xPlayer.addInventoryItem(Config.HackV1Item, 1)
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'There is not enough material!'})
            end
        end
end)

RegisterNetEvent("bros_hacking:givehackv2tablet")
AddEventHandler("bros_hacking:givehackv2tablet", function(item, count)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            if xPlayer.getMoney(Config.Hackv2Price) >= Config.Hackv2Price then
				xPlayer.removeMoney(Config.Hackv2Price)
				xPlayer.addInventoryItem(Config.HackV2Item, 1)
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'There is not enough material!'})
            end
        end
end)

RegisterNetEvent("bros_hacking:givehackv3tablet")
AddEventHandler("bros_hacking:givehackv3tablet", function(item, count)
    local _source = source
    local xPlayer  = ESX.GetPlayerFromId(_source)
        if xPlayer ~= nil then
            if xPlayer.getMoney(Config.Hackv3Price) >= Config.Hackv3Price then
				xPlayer.removeMoney(Config.Hackv3Price)
				xPlayer.addInventoryItem(Config.HackV3Item, 1)
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'There is not enough material!'})
            end
        end
end)

RegisterServerEvent('bros_hacking:sellbtc')
AddEventHandler('bros_hacking:sellbtc', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer ~= nil then
	if xPlayer.getInventoryItem(Config.Bitcoinitem).count >= Config.BitcoinAmount then
			xPlayer.removeInventoryItem(Config.Bitcoinitem, 1)
            Citizen.Wait(500)
			xPlayer.addMoney(Config.BitcoinPrice)
            else
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = 'There is not enough material!'})
            end
        end
end)