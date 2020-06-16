ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

GangsData = {}

function GetGangs()
	local data = LoadResourceFile('krz_gangsbuilder', 'data/gangData.json')
	return data and json.decode(data) or {}
end

function GetGang(job2)
	for i = 1, #GangsData, 1 do
		if job2.name == GangsData[i].Name then
			return GangsData[i]
		end
	end

	return false
end

ESX.RegisterServerCallback('KorioZ-GangsBuilder:Admin_getUsergroup', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local plyGroup = xPlayer.getGroup()

	if plyGroup ~= nil then 
		cb(plyGroup)
	else
		cb('user')
	end
end)

RegisterServerEvent('gb:addGang')
AddEventHandler('gb:addGang', function(data)
	MySQL.Async.execute([[
INSERT INTO `addon_account` (name, label, shared) VALUES (@gangSociety, @gangLabel, 1);
INSERT INTO `datastore` (name, label, shared) VALUES (@gangSociety, @gangLabel, 1);
INSERT INTO `addon_inventory` (name, label, shared) VALUES (@gangSociety, @gangLabel, 1);
INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES (@gangName, @gangLabel, 1);
INSERT INTO `job_grades` (`job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
	(@gangName, 0, 'rookie', 'Associé', 0, '{}', '{}'),
	(@gangName, 1, 'member', 'Soldat', 0, '{}', '{}'),
	(@gangName, 2, 'elite', 'Elite', 0, '{}', '{}'),
	(@gangName, 3, 'lieutenant', 'Lieutenant', 0, '{}', '{}'),
	(@gangName, 4, 'viceboss', 'Bras Droit', 0, '{}', '{}'),
	(@gangName, 5, 'boss', 'Patron', 0, '{}', '{}')
;
	]], {
		['@gangName'] = data.Name,
		['@gangLabel'] = data.Label,
		['@gangSociety'] = 'society_' .. data.Name
	}, function(rowsChanged)
		table.insert(GangsData, data)
		SaveResourceFile('krz_gangsbuilder', 'data/gangData.json', json.encode(GangsData))
	end)
end)

RegisterServerEvent('gb:requestSync')
AddEventHandler('gb:requestSync', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local plyGang = GetGang(xPlayer.job2)
	TriggerClientEvent('gb:SyncGang', xPlayer.source, plyGang)
end)

AddEventHandler('esx:playerLoaded', function(source, xPlayer)
	local plyGang = GetGang(xPlayer.job2)
	TriggerClientEvent('gb:SyncGang', source, plyGang)
end)

AddEventHandler('esx:setJob2', function(source, job2)
	local plyGang = GetGang(job2)
	TriggerClientEvent('gb:SyncGang', source, plyGang)
end)

Citizen.CreateThread(function()
	GangsData = GetGangs()

	for i = 1, #GangsData, 1 do
		TriggerEvent('esx_society:registerSociety', GangsData[i].Name, GangsData[i].Label, 'society_' .. GangsData[i].Name, 'society_' .. GangsData[i].Name, 'society_' .. GangsData[i].Name, {type = 'public'})
	end
end)
