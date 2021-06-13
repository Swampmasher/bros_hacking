ESX = nil
local phcoordstarted = false
local target = nil
local boost = false
local failed = false
local canOpen = true
local lastcredit = 0
local lastengine = 0
local lastident = 0
local lastenginepw = 0
local lastphcoord = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	PlayerData = ESX.GetPlayerData()
end)

Citizen.CreateThread(function()
    if Config.NPCEnable == true then
        for i, v in pairs(Config.NPC) do
            RequestModel(v.npc)
            while not HasModelLoaded(v.npc) do
                Wait(1)
            end
            meth_dealer_seller = CreatePed(1, v.npc, v.x, v.y, v.z, v.h, false, true)
            SetBlockingOfNonTemporaryEvents(meth_dealer_seller, true)
            SetPedDiesWhenInjured(meth_dealer_seller, false)
            SetPedCanPlayAmbientAnims(meth_dealer_seller, true)
            SetPedCanRagdollFromPlayerImpact(meth_dealer_seller, false)
            SetEntityInvincible(meth_dealer_seller, true)
            FreezeEntityPosition(meth_dealer_seller, true)
        end
    end
end)


Citizen.CreateThread(function ()
    while true do
		Citizen.Wait(0) 
        local dist = #(GetEntityCoords(PlayerPedId(), true) - vector3(Config.SellerCoordX, Config.SellerCoordY, Config.SellerCoordZ))
        if dist < 3.0 then
            DrawText3D(Config.SellerCoordX, Config.SellerCoordY, Config.SellerCoordZ, Config.SellerDrawText)
            if IsControlJustPressed(0, 38) then
                TriggerEvent("bros_hacking:sellermainmenu")
            end
        end
    end
end)

-- Citizen.CreateThread(function ()
--     while true do
--         Citizen.Wait(0) 
--         local dist = #(GetEntityCoords(PlayerPedId(), true) - vector3(Config.BlackX, Config.BlackY, Config.BlackZ))
--         if dist < 3.0 then
-- 			-- DrawText3D(Config.BlackX, Config.BlackY, Config.BlackZ, Config.BlackDrawText)
--             if IsControlJustPressed(0, 38) then
--                 TriggerEvent('lucid:dialog:open', {
--                     { text="Sell Bitcoin", event= "bros_hacking:sellbtc", server= true},

--                 }, Config.NPCName, Config.NPCDialog)
--             end
--         end
--     end
-- end)


RegisterNetEvent('bros_hacking:usedTablet')
AddEventHandler('bros_hacking:usedTablet', function()
	local elements = {}

	local PlayerData = ESX.GetPlayerData()

	if PlayerData.job.name ~= 'police' and PlayerData.job.name ~= 'ambulance' and PlayerData.job.name ~= 'doj' and PlayerData.job.name ~= 'ranger' then
		if canOpen then
			ESX.TriggerServerCallback('bros_hacking:getLevel', function(level, currentexp)
				if level == nil then
					local level = 0
				end
				if currentexp == nil then
					local currentexp = 0
				end
					table.insert(elements, {label = 'Level: ' .. level .. ' - Experience: ' .. currentexp .. '', value = nil}) --
					table.insert(elements, {label = 'Unlock Car', value = 'vehiclelock'}) --
				if level >= 1 then
					table.insert(elements, {label = 'Learn number of active officer', value = 'countlspd'}) --
					table.insert(elements, {label = 'Break the car engine', value = 'enginecrash'}) --
					table.insert(elements, {label = 'Boost engine', value = 'enginepw'}) --
				end
				if level >= 2 then
					table.insert(elements, {label = 'Get Location from Phone Number', value = 'phonecoord'}) --
					table.insert(elements, {label = 'Credit Card Hack', value = 'creditcarda'})
				end
				if level >= 3 then
					table.insert(elements, {label = 'Goverment Hack', value = 'govermenthack'}) --
					table.insert(elements, {label = 'Get information from phone number', value = 'mhident'}) 
					table.insert(elements, {label = 'Steal Money from Person Bank Account', value = 'stealbank'}) --
				end

				ESX.UI.Menu.CloseAll()

				ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'hackmenu', {
					title    = 'Hacking Operations"',
					align    = 'right',
					elements = elements
				}, function(data, menu)

					if data.current.value == 'creditcarda' then
						menu.close()
						opencredithackmenu()
					elseif data.current.value == 'vehiclelock' then
						menu.close()
						vehiclelock()
					elseif data.current.value == 'countlspd' then
						menu.close()
						countlspd()
					elseif data.current.value == 'mhident' then
						menu.close()
						idenhack()
					elseif data.current.value == 'enginepw' then
						menu.close()
						enginepw()
					elseif data.current.value == 'enginecrash' then
						menu.close()
						enginecrash()
					elseif data.current.value == 'stealbank' then
						menu.close()
						stealbank()
					elseif data.current.value == 'govermenthack' then
						menu.close()
						govermenthack()
					elseif data.current.value == 'phonecoord' then
						menu.close()
						phonecoord()
					elseif data.current.value == nil then
					end

				end, function(data, menu)
					menu.close()
				end)
			end)
		else
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You cannot use the tablet here!'})
		end
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Tablet Encrypted!'})
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(2000)
		if failed then
			local player = PlayerPedId()
			local pCoords = GetEntityCoords(player)
			TriggerServerEvent('bros_hacking:blip', pCoords)
		end
	end
end)


local bliptimer = 5 
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(60000)
		if failed then
			bliptimer = bliptimer - 1
			if bliptimer == 0 then
                failed = false
				bliptimer = 5
			end
		end
    end
end)

RegisterNetEvent('bros_hacking:cantOpen')
AddEventHandler('bros_hacking:cantOpen', function()
	canOpen = false
end)

RegisterNetEvent('bros_hacking:canOpen')
AddEventHandler('bros_hacking:canOpen', function()
	canOpen = true
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)
		if phcoordstarted then
			local pCoords = GetEntityCoords(PlayerPedId())
			local tCoords = GetEntityCoords(target)
			if GetDistanceBetweenCoords(pCoords, tCoords.x, tCoords.y, tCoords.z, true) <= 2.0 then
				phcoordstarted = false
				target = nil
				TriggerEvent("mtracker:stop")
			end
		end
	end
end)


function phonecoord()
	if not IsPedInAnyVehicle(PlayerPedId(), false) then
		if GetGameTimer() - lastphcoord > 5 * 60000 then
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Enter the phone number of the person whose location you want to find!', length = 5000})
			DisplayOnscreenKeyboard(1, "", "", "", "", "", "", 30)
			while (UpdateOnscreenKeyboard() == 0) do
				DisableAllControlActions(0)
				Wait(0)
			end
			if (GetOnscreenKeyboardResult()) then
				phphone_number = GetOnscreenKeyboardResult()
				TriggerEvent("mhacking:show")
				TriggerEvent("mhacking:start", 3, 20, mhphcoord)
			end
		else
			local ctime = 5 * 60000 - (GetGameTimer() - lastphcoord)
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = '' .. math.floor(ctime / 60000 + 1) .. ' try again in a minute!'})
		end
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You cannot start this feature while in the vehicle!'})
	end
end

function mhphcoord(success)
	TriggerEvent('mhacking:hide')
	if success then
		local giveexp = math.random(1, 3)
		TriggerServerEvent('bros_hacking:giveExp', giveexp)
		ESX.TriggerServerCallback('bros_hacking:getIdentfromPh', function(targetid)
			target = GetPlayerPed(GetPlayerFromServerId(targetid))
			targetsEntity = {}
			if DoesEntityExist(target) then
				table.insert(targetsEntity, target)
				Citizen.Wait(100)
				TriggerEvent('mtracker:settargets', targetsEntity)
				Citizen.Wait(100)
				TriggerEvent('mtracker:start')
				phcoordstarted = true
				targetsEntity = {}
			end
		end, phphone_number)
		lastphcoord = GetGameTimer()
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You failed! Your position has been revealed!'})
		failed = true
		phonecoordispatch()
	end
	phphone_number = nil
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)
		if phcoordstarted then
			local pCoords = GetEntityCoords(PlayerPedId())
			local tCoords = GetEntityCoords(target)
			if GetDistanceBetweenCoords(pCoords, tCoords.x, tCoords.y, tCoords.z, true) <= 2.0 then
				phcoordstarted = false
				target = nil
				TriggerEvent("mtracker:stop")
			end
		end
	end
end)

function enginepw()
	if GetGameTimer() - lastenginepw > 5 * 60000 then
		if IsPedInAnyVehicle(PlayerPedId(), false) then
			local player = PlayerPedId()
			local vehicle = GetVehiclePedIsIn(player, false)

			TriggerEvent("mhacking:show")
			TriggerEvent("mhacking:start", 3, 20, mhenginepw)
		else
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'This feature cannot be used outside the vehicle..'})
		end
	else
		local ptime = 5 * 60000 - (GetGameTimer() - lastenginepw)
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = '' .. math.floor(ptime / 60000 + 1) .. ' try again in a minute!'})
	end
end

function mhenginepw(success)
	local player = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(player, false)
	TriggerEvent('mhacking:hide')
	if success then
		local giveexp = math.random(1, 3)
		TriggerServerEvent('bros_hacking:giveExp', giveexp)
		TriggerServerEvent('bros_hacking:boostEngine', vehicle)
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'The vehicles software has been strengthened by 40% for 15 minutes!', length = 5000})
		lastenginepw = GetGameTimer()
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You failed! Your position has been exposed!'})
		failed = true
		carboostdispatch()
	end
end

RegisterNetEvent('bros_hacking:boostEngineC')
AddEventHandler('bros_hacking:boostEngineC', function(vehicle)
	boost = true
	boostedvehicle = vehicle
	Citizen.Wait(100000)
	boost = false
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(100)
		if boost then
			if IsPedInAnyVehicle(PlayerPedId(), false) then
				local player = PlayerPedId()
				local vehicle = GetVehiclePedIsIn(player, false)
				if boostedvehicle == vehicle then
					SetVehicleEnginePowerMultiplier(boostedvehicle, 40.0)
				end
			end
		else
			if IsPedInAnyVehicle(PlayerPedId(), false) then
				local player = PlayerPedId()
				local vehicle = GetVehiclePedIsIn(player, false)
				if boostedvehicle == vehicle then
					SetVehicleEnginePowerMultiplier(boostedvehicle, 0.0)
					boostedvehicle = nil
				end
			end
		end
	end
end)	

function idenhack()
	if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		if GetGameTimer() - lastident > 20 * 60000 then
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Enter the phone number of the person whose identity you want to know.!', length = 5000})
			DisplayOnscreenKeyboard(1, "", "", "", "", "", "", 30)
			while (UpdateOnscreenKeyboard() == 0) do
				DisableAllControlActions(0)
				Wait(0)
			end
			if (GetOnscreenKeyboardResult()) then
				iphone_number = GetOnscreenKeyboardResult()
				TriggerEvent("mhacking:show")
				TriggerEvent("mhacking:start", 4, 30, mhident)
			end
		else
			local itime = 20 * 60000 - (GetGameTimer() - lastident)
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = '' .. math.floor(itime / 60000 + 1) .. ' try again in a minute!'})
		end
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'This feature is not available while in the vehicle.'})
	end
end

function mhident(success)
	TriggerEvent('mhacking:hide')
	if success then
		ESX.TriggerServerCallback('bros_hacking:getIdent', function(job, name, lname)
			if job ~= nil and name ~= nil and lname ~= nil then
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Name surname: ' .. name .. ' ' .. lname .. ' Job: ' .. job .. ''})
			else
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'Number owner not found!'})
			end
		end, iphone_number)
		local giveexp = math.random(1, 3)
		TriggerServerEvent('bros_hacking:giveExp', giveexp)
		iphone_number = nil
		lastident = GetGameTimer()
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You failed! Your position has been exposed!'})
		failed = true
		identhackwalert()
	end
end

function vehiclelock()
	if not IsPedInAnyVehicle(PlayerPedId(), false) then
		local player = PlayerPedId()
		local pCoords = GetEntityCoords(player, true)

		if IsAnyVehicleNearPoint(pCoords.x, pCoords.y, pCoords.z, 3.0) then
			local vehicle = ESX.Game.GetVehicleInDirection()
			if DoesEntityExist(vehicle) then
				TriggerEvent("mhacking:show")
				TriggerEvent("mhacking:start", 4, 30, mhvehicle)
			else
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You need to turn towards the vehicle!'})
			end
		else
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'There are no vehicles nearby!'})
		end
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'This feature is not available while in the vehicle.'})
	end
end

function mhvehicle(success)
	local vehicle = ESX.Game.GetVehicleInDirection()
	TriggerEvent('mhacking:hide')
	if success then
		local giveexp = math.random(1, 3)
		TriggerServerEvent('bros_hacking:giveExp', giveexp)
		TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 10, "unlock", 1.0)
		SetVehicleDoorsLocked(vehicle, 1)
		SetVehicleDoorsLockedForAllPlayers(vehicle, false)
		SetVehicleLights(vehicle, 2)
		Citizen.Wait(150)
		SetVehicleLights(vehicle, 0)
		Citizen.Wait(150)
		SetVehicleLights(vehicle, 2)
		Citizen.Wait(150)
		SetVehicleLights(vehicle, 0)
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Vehicle unlocked.'})
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You failed! Your position has been exposed!'})
		failed = true
		lockdispatch()
	end
end

function countlspd()
	TriggerEvent("mhacking:show")
	TriggerEvent("mhacking:start", 3, 30, mhcountlspd)
end

function mhcountlspd(success)
	TriggerEvent('mhacking:hide')
	if success then
		local giveexp = math.random(1, 3)
		TriggerServerEvent('bros_hacking:giveExp', giveexp)
		ESX.TriggerServerCallback('bros_hacking:copCount', function(count)
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Active ' .. count .. ' LSPD Officer!', length = 4000})
		end)
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You failed! Your position has been exposed!'})
		failed = true
		lspdcountdispatch()
	end
end

function enginecrash()
	if not IsPedInAnyVehicle(PlayerPedId(), false) then
		local player = PlayerPedId()
		local pCoords = GetEntityCoords(player, true)

		if IsAnyVehicleNearPoint(pCoords.x, pCoords.y, pCoords.z, 3.0) then
			local vehicle = ESX.Game.GetVehicleInDirection()
			if DoesEntityExist(vehicle) then
				TriggerEvent("mhacking:show")
				TriggerEvent("mhacking:start", 3, 20, mhengine)
			else
				TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You need to turn towards the vehicle!'})
			end
		else
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'There are no vehicles nearby!'})
		end
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'This feature is not available while in the vehicle.'})
	end
end

function mhengine(success)
	local vehicle = ESX.Game.GetVehicleInDirection()
	TriggerEvent('mhacking:hide')
	if success then
		local giveexp = math.random(1, 3)
		TriggerServerEvent('bros_hacking:giveEx', giveexp)
		TriggerServerEvent('bros_hacking:engineCrash', vehicle)
		lastengine = GetGameTimer()
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You failed! Your position has been exposed!'})
		failed = true
		carbreakwalert()
	end
end

RegisterNetEvent('bros_hacking:engineCrashC')
AddEventHandler('bros_hacking:engineCrashC', function(veh)
	local vehicle = veh
	local newvehicle = ESX.Game.GetVehicleInDirection()

	if newvehicle == vehicle then
		SetVehicleEngineHealth(vehicle, 0.0)
	end
end)

function stealbank()
	if not IsPedInAnyVehicle(PlayerPedId(), false) then
		ESX.TriggerServerCallback('bros_hacking:getTime', function(ostime)
			ESX.TriggerServerCallback('bros_hacking:bankTime', function(dbbanktime)
				local remainingtime = ostime - dbbanktime
				if ostime - dbbanktime <= 86400 then
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = '' .. math.floor((86400 - remainingtime) / 60) .. ' try again in a minute!'})
				elseif ostime - dbbanktime >= 86400 then
					TriggerEvent('mythic_notify:client:SendAlert', { type = 'inform', text = 'Enter the phone number of the person whose bank you want to steal money from!', length = 5000})
					DisplayOnscreenKeyboard(1, "", "", "", "", "", "", 30)
					while (UpdateOnscreenKeyboard() == 0) do
						DisableAllControlActions(0)
						Wait(0)
					end
					if (GetOnscreenKeyboardResult()) then
						bphone_number = GetOnscreenKeyboardResult()
						TriggerEvent("mhacking:show")
						TriggerEvent("mhacking:start", 2, 20, mhbank)
					end
				end
			end)
		end)
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'This feature is not available while in the vehicle.'})
	end
end

function mhbank(success)
	TriggerEvent('mhacking:hide')
	if success then
		local giveexp = math.random(1, 3)
		TriggerServerEvent('bros_hacking:giveExp', giveexp)
		TriggerServerEvent('bros_hacking:stealBank', bphone_number)
		TriggerServerEvent('bros_hacking:bankTimeUpdate')
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You failed! Your position has been exposed!'})
		failed = true
		bankhackwalert()
	end
	bphone_number = nil
end


AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		ESX.UI.Menu.CloseAll()
	end
end)

function hackv1()
	TriggerEvent("mhacking:show")
	TriggerEvent("mhacking:start", 5 , 30, hackv1bitir)
end

function hackv2()
	TriggerEvent("mhacking:show")
	TriggerEvent("mhacking:start", 4 , 20, hackv2bitir)
end

function hackv3()
	TriggerEvent("mhacking:show")
	TriggerEvent("mhacking:start", 2 , 20, hackv3bitir)
end


function hackv1bitir(success)
	TriggerEvent('mhacking:hide')
	if success then
		TriggerServerEvent("bros_hacking:v1reward")
		stopAnim()
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You failed! Your position has been exposed!'})
		hackv1walert()
	end
end


function hackv2bitir(success)
	TriggerEvent('mhacking:hide')
	if success then
		TriggerServerEvent("bros_hacking:v2reward")
		stopAnim()
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You failed! Your position has been exposed!'})
		hackv2walert()
	end
end

function hackv3bitir(success)
	TriggerEvent('mhacking:hide')
	if success then
		TriggerServerEvent("bros_hacking:v3reward")
		stopAnim()
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You failed! Your position has been exposed!'})
		hackv3walert()
	end
end

function attachObject()
	tab = CreateObject(GetHashKey("prop_cs_tablet"), 0, 0, 0, true, true, true)
	AttachEntityToEntity(tab, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), -0.05, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
end

function stopAnim()
	temp = false
	StopAnimTask(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a" ,8.0, -8.0, -1, 50, 0, false, false, false)
	DeleteObject(tab)
end

function startAnim()
	if not temp then
		RequestAnimDict("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a")
		while not HasAnimDictLoaded("amb@code_human_in_bus_passenger_idles@female@tablet@idle_a") do
			Citizen.Wait(0)
		end
		attachObject()
		TaskPlayAnim(PlayerPedId(), "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a", "idle_a" ,8.0, -8.0, -1, 50, 0, false, false, false)
		temp = true
	end
end

RegisterNetEvent('hack:v1')
AddEventHandler('hack:v1', function()
	local ped = PlayerPedId()
	attachObject()
	startAnim()
    TriggerEvent("mythic_progbar:client:progress", {
		duration = 5000,
		label = 'Connecting..',
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
	}, function(status)
		if not status then
			hackv1()
		end
	end)
end)

RegisterNetEvent('hack:v2')
AddEventHandler('hack:v2', function()
	local ped = PlayerPedId()
	attachObject()
	startAnim()
    TriggerEvent("mythic_progbar:client:progress", {
		duration = 10000,
		label = 'Connecting..',
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
	}, function(status)
		if not status then
			hackv2()
		end
	end)
end)

RegisterNetEvent('hack:v3')
AddEventHandler('hack:v3', function()
	local ped = PlayerPedId()
	attachObject()
	startAnim()
    TriggerEvent("mythic_progbar:client:progress", {
		duration = 10000,
		label = 'Connecting..',
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
	}, function(status)
		if not status then
			hackv3()
		end
	end)
end)

RegisterNetEvent('bros_hacking:sellbitcoin')
AddEventHandler('bros_hacking:sellbitcoin', function()
	TriggerEvent("mythic_progbar:client:progress", {
		name = "unique_action_name",
		duration = 1000,
		label = "Stock market is controlling...",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "mp_common",
			anim = "givetake1_a",
		},
	}, function(status)
		if not status then
			TriggerServerEvent("bros_hacking:sellbtc")
		end
	end)
end)

RegisterNetEvent('hack:v2buy')
AddEventHandler('hack:v2buy', function()
	TriggerEvent("mythic_progbar:client:progress", {
		name = "unique_action_name",
		duration = 3000,
		label = "Purchasing...",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "mp_common",
			anim = "givetake1_a",
		},
	}, function(status)
		if not status then
			TriggerServerEvent("bros_hacking:givehackv2tablet")
		end
	end)
end)

RegisterNetEvent('hackt:tabletbuy')
AddEventHandler('hackt:tabletbuy', function()
	TriggerEvent("mythic_progbar:client:progress", {
		name = "unique_action_name",
		duration = 3000,
		label = "Purchasing...",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "mp_common",
			anim = "givetake1_a",
		},
	}, function(status)
		if not status then
			TriggerServerEvent("bros_hacking:givehacktablet")
		end
	end)
end)

RegisterNetEvent('hack:v1buy')
AddEventHandler('hack:v1buy', function()
	TriggerEvent("mythic_progbar:client:progress", {
		name = "unique_action_name",
		duration = 3000,
		label = "Purchasing...",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "mp_common",
			anim = "givetake1_a",
		},
	}, function(status)
		if not status then
			TriggerServerEvent("bros_hacking:givehackv1tablet")
		end
	end)
end)

RegisterNetEvent('hack:v3buy')
AddEventHandler('hack:v3buy', function()
	TriggerEvent("mythic_progbar:client:progress", {
		name = "unique_action_name",
		duration = 3000,
		label = "Purchasing...",
		useWhileDead = false,
		canCancel = true,
		controlDisables = {
			disableMovement = true,
			disableCarMovement = true,
			disableMouse = false,
			disableCombat = true,
		},
		animation = {
			animDict = "mp_common",
			anim = "givetake1_a",
		},
	}, function(status)
		if not status then
			TriggerServerEvent("bros_hacking:givehackv3tablet")
		end
	end)
end)

function opencredithackmenu()
	local elements = {}
	
	table.insert(elements, {label = 'Easy', value = 'easyhack'})
	table.insert(elements, {label = 'Medium', value = 'medhack'})
	table.insert(elements, {label = 'Hard', value = 'hardhack'})
    
    ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'darkdeep', {
		title    = 'Illegal Link',
		align    = 'right',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'easyhack' then
			menu.close()
			kredikartikolay()
		elseif data.current.value == 'medhack' then
			menu.close()
			kredikartinormal()
		elseif data.current.value == 'hardhack' then
			menu.close()
			kredikartizor()
		elseif data.current.value == nil then
		end

	end, function(data, menu)
		menu.close()
	end)
end

function kredikartikolay()
	if not IsPedInAnyVehicle(PlayerPedId(), false) then
		if GetGameTimer() - lastcredit > 5 * 60000 then
			TriggerEvent("mhacking:show")
			TriggerEvent("mhacking:start", 5, 30, kolaykrediver)
		else
			local time = 5 * 60000 - (GetGameTimer() - lastcredit)
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = '' .. math.floor(time / 60000 + 1) .. ' Try again in a minute!'})
		end
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'This feature is not available while in the vehicle.'})
	end
end

function kolaykrediver(success)
	TriggerEvent('mhacking:hide')
	if success then
		local givemoney = math.random(1800, 2400)
		local giveexp = math.random(10, 25)
		TriggerServerEvent('bros_hacking:giveMoney', givemoney)
		TriggerServerEvent('bros_hacking:giveExp', giveexp)
		lastcredit = GetGameTimer()
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You failed! Your position has been exposed!'})
		failed = true
		hackihbar()
	end
end

function kredikartinormal()
	if not IsPedInAnyVehicle(PlayerPedId(), false) then
		if GetGameTimer() - lastcredit > 5 * 60000 then
			TriggerEvent("mhacking:show")
			TriggerEvent("mhacking:start", 3, 20, normalkrediver)
		else
			local time = 5 * 60000 - (GetGameTimer() - lastcredit)
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = '' .. math.floor(time / 60000 + 1) .. ' Try again in a minute!'})
		end
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'This feature is not available while in the vehicle.'})
	end
end

function normalkrediver(success)
	TriggerEvent('mhacking:hide')
	if success then
		local givemoney = math.random(1800, 2400)
		local giveexp = math.random(10, 25)
		TriggerServerEvent('bros_hacking:giveMoney', givemoney)
		TriggerServerEvent('bros_hacking:giveExp', giveexp)
		lastcredit = GetGameTimer()
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You failed! Your position has been exposed!'})
		failed = true
		hackihbar()
	end
end

function kredikartizor()
	if not IsPedInAnyVehicle(PlayerPedId(), false) then
		if GetGameTimer() - lastcredit > 5 * 60000 then
			TriggerEvent("mhacking:show")
			TriggerEvent("mhacking:start", 2, 18,zorkrediver)
		else
			local time = 5 * 60000 - (GetGameTimer() - lastcredit)
			TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = '' .. math.floor(time / 60000 + 1) .. ' Try again in a minute!'})
		end
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'This feature is not available while in the vehicle.'})
	end
end

function zorkrediver(success)
	TriggerEvent('mhacking:hide')
	if success then
		local givemoney = math.random(1800, 2400)
		local giveexp = math.random(10, 25)
		TriggerServerEvent('bros_hacking:giveMoney', givemoney)
		TriggerServerEvent('bros_hacking:giveExp', giveexp)
		lastcredit = GetGameTimer()
	else
		TriggerEvent('mythic_notify:client:SendAlert', { type = 'error', text = 'You failed! Your position has been exposed!'})
		failed = true
		hackihbar()
	end
end

function govermenthack()
	TriggerEvent("bros-fallouthacker:hack-menu-ac")
end

function hackihbar()
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

function identhackwalert()
	local playerPed = PlayerPedId()
	local PedPosition = GetEntityCoords(playerPed)
	local PlayerCoords = {x = PedPosition.x, y = PedPosition.y, z = PedPosition.z}

	TriggerServerEvent(
		"esx_addons_gcphone:startCall",
		"police",
		(Config.IdentHackWalert),
		PlayerCoords,
		{PlayerCoords = {x = PedPosition.x, y = PedPosition.y, z = PedPosition.z}}
	)
end

function phonecoordispatch()
	local playerPed = PlayerPedId()
	local PedPosition = GetEntityCoords(playerPed)
	local PlayerCoords = {x = PedPosition.x, y = PedPosition.y, z = PedPosition.z}

	TriggerServerEvent(
		"esx_addons_gcphone:startCall",
		"police",
		(Config.PhonecoordWalertMessage),
		PlayerCoords,
		{PlayerCoords = {x = PedPosition.x, y = PedPosition.y, z = PedPosition.z}}
	)
end

function carboostdispatch()
	local playerPed = PlayerPedId()
	local PedPosition = GetEntityCoords(playerPed)
	local PlayerCoords = {x = PedPosition.x, y = PedPosition.y, z = PedPosition.z}

	TriggerServerEvent(
		"esx_addons_gcphone:startCall",
		"police",
		(Config.CarboostWalertMessage),
		PlayerCoords,
		{PlayerCoords = {x = PedPosition.x, y = PedPosition.y, z = PedPosition.z}}
	)
end

function lockdispatch()
	local playerPed = PlayerPedId()
	local PedPosition = GetEntityCoords(playerPed)
	local PlayerCoords = {x = PedPosition.x, y = PedPosition.y, z = PedPosition.z}

	TriggerServerEvent(
		"esx_addons_gcphone:startCall",
		"police",
		(Config.CarLockWalertMessage),
		PlayerCoords,
		{PlayerCoords = {x = PedPosition.x, y = PedPosition.y, z = PedPosition.z}}
	)
end

function lspdcountdispatch()
	local playerPed = PlayerPedId()
	local PedPosition = GetEntityCoords(playerPed)
	local PlayerCoords = {x = PedPosition.x, y = PedPosition.y, z = PedPosition.z}

	TriggerServerEvent(
		"esx_addons_gcphone:startCall",
		"police",
		(Config.LspdWalertMessage),
		PlayerCoords,
		{PlayerCoords = {x = PedPosition.x, y = PedPosition.y, z = PedPosition.z}}
	)
end

function carbreakwalert()
	local playerPed = PlayerPedId()
	local PedPosition = GetEntityCoords(playerPed)
	local PlayerCoords = {x = PedPosition.x, y = PedPosition.y, z = PedPosition.z}

	TriggerServerEvent(
		"esx_addons_gcphone:startCall",
		"police",
		(Config.CarBreakWalertMessage),
		PlayerCoords,
		{PlayerCoords = {x = PedPosition.x, y = PedPosition.y, z = PedPosition.z}}
	)
end

function bankhackwalert()
	local playerPed = PlayerPedId()
	local PedPosition = GetEntityCoords(playerPed)
	local PlayerCoords = {x = PedPosition.x, y = PedPosition.y, z = PedPosition.z}

	TriggerServerEvent(
		"esx_addons_gcphone:startCall",
		"police",
		(Config.BankHackWalertMessage),
		PlayerCoords,
		{PlayerCoords = {x = PedPosition.x, y = PedPosition.y, z = PedPosition.z}}
	)
end

function hackv1walert()
	local playerPed = PlayerPedId()
	local PedPosition = GetEntityCoords(playerPed)
	local PlayerCoords = {x = PedPosition.x, y = PedPosition.y, z = PedPosition.z}
	TriggerServerEvent(
		"esx_addons_gcphone:startCall",
		"police",
		(Config.HackV1WalertMessage),
		PlayerCoords,
		{PlayerCoords = {x = PedPosition.x, y = PedPosition.y, z = PedPosition.z}}
	)
end

function hackv2walert()
	local playerPed = PlayerPedId()
	local PedPosition = GetEntityCoords(playerPed)
	local PlayerCoords = {x = PedPosition.x, y = PedPosition.y, z = PedPosition.z}
	TriggerServerEvent(
		"esx_addons_gcphone:startCall",
		"police",
		(Config.HackV2WalertMessage),
		PlayerCoords,
		{PlayerCoords = {x = PedPosition.x, y = PedPosition.y, z = PedPosition.z}}
	)
end

RegisterCommand("amcik", function()
	local playerPed = PlayerPedId()
	local PedPosition = GetEntityCoords(playerPed)
	local PlayerCoords = {x = PedPosition.x, y = PedPosition.y, z = PedPosition.z}
	TriggerServerEvent(
		"esx_addons_gcphone:startCall",
		"police",
		(Config.HackV3WalertMessage),
		PlayerCoords,
		{PlayerCoords = {x = PedPosition.x, y = PedPosition.y, z = PedPosition.z}}
	)
end)

function hackv3walert()
	local playerPed = PlayerPedId()
	local PedPosition = GetEntityCoords(playerPed)
	local PlayerCoords = {x = PedPosition.x, y = PedPosition.y, z = PedPosition.z}
	TriggerServerEvent(
		"esx_addons_gcphone:startCall",
		"police",
		(Config.HackV3WalertMessage),
		PlayerCoords,
		{PlayerCoords = {x = PedPosition.x, y = PedPosition.y, z = PedPosition.z}}
	)
end


function DrawText3D(x, y, z, text, scale)
	SetTextScale(0.30, 0.30)
	SetTextFont(0)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	SetDrawOrigin(x,y,z, 0)
	DrawText(0.0, 0.0)
	local factor = (string.len(text)) / 370
	DrawRect(0.0, 0.0+0.0125, 0.025+ factor, 0.03, 15, 16, 17, 100)
end

RegisterNetEvent('bros_hacking:buydevicemenu', function()
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "Hacker Timmy",
            txt = ""
        },
		{
            id = 2,
            header = "< Go Back",
            txt = "",
            params = {
                event = "bros_hacking:sellermainmenu"
            }
        },
        {
            id = 3,
            header = Config.HackTabletHeader,
            txt = Config.HackTabletText,
            params = {
                event = "hackt:tabletbuy",
				args = {
                    number = 1,
                    id = 2
                }
            }
        },
		{
            id = 4,
            header = Config.HackV1TabletHeader,
            txt = Config.HackV1TabletText,
            params = {
                event = "hack:v1buy",
				args = {
                    number = 1,
                    id = 3
                }
            }
        },
		{
            id = 5,
            header = Config.HackV2TabletHeader,
            txt = Config.HackV2TabletText,
            params = {
                event = "hack:v2buy",
				args = {
                    number = 1,
                    id = 4
                }
            }
        },
		{
            id = 6,
            header = Config.HackV3TabletHeader,
            txt = Config.HackV3TabletText,
            params = {
                event = "hack:v3buy",
				args = {
                    number = 1,
                    id = 5
                }
            }
        },
    })
end)

RegisterNetEvent('bros_hacking:sellermainmenu', function(data)
    TriggerEvent('nh-context:sendMenu', {
        {
            id = 1,
            header = "Hacker Timmy",
            txt = ""
        },
		{
            id = 2,
            header = Config.BuyDeviceMenuHeader,
            txt = Config.BuyDeviceMenuText,
            params = {
                event = "bros_hacking:buydevicemenu",
				args = {
                    number = 1,
                    id = 5
                }
            }
        },

		{
            id = 3,
            header = Config.SellBitcoinHeader,
            txt = Config.SellBitcoinText,
            params = {
                event = "bros_hacking:sellbitcoin",
				args = {
                    number = 1,
                    id = 5
                }
            }
        },
    })
end)