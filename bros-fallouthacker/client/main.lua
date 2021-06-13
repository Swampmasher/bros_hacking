ESX = nil
local OpenManuHack = false
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


RegisterNetEvent('bros-fallouthacker:hack-menu-ac')
AddEventHandler('bros-fallouthacker:hack-menu-ac', function()
		govermenthackoutlawalert()	
		openHackMenu()
end)

function openHackMenu()
	SendNUIMessage({menu = 'open'})
	SetNuiFocus(true, true)
	OpenManuHack = true
end

RegisterNUICallback('CloseMenu', function(data)
	if data.suces then
		local money = math.random(10000,18000)
		ESX.ShowNotification("The amount you earned successfully hacking " .. money)
		TriggerServerEvent("bros-fallouthacker:givemoney", "add", "inv", money)
	elseif not data.suces then
		ESX.ShowNotification("Hacking failed.")
	end
	SetNuiFocus(false, false)
	OpenManuHack = false
end)

RegisterNUICallback('CloseMenuv2', function()
	SetNuiFocus(false, false)
	OpenManuHack = false
end)

function govermenthackoutlawalert()
	local playerPed = PlayerPedId()
	local PedPosition = GetEntityCoords(playerPed)
	local PlayerCoords = {x = PedPosition.x, y = PedPosition.y, z = PedPosition.z}

	TriggerServerEvent(
		"esx_addons_gcphone:startCall",
		"police",
		("Hack İhbarı"),
		PlayerCoords,
		{PlayerCoords = {x = PedPosition.x, y = PedPosition.y, z = PedPosition.z}}
	)
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		SetNuiFocus(false, false)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if OpenManuHack and (IsControlJustPressed(0, 177) or IsControlJustPressed(0, 214) or IsControlJustPressed(0, 49)) then
			OpenManuHack = false
			SendNUIMessage({menu = 'open'})
			SetNuiFocus(false, false)
		end
	end
end)