ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent("bros-fallouthacker:givemoney")
AddEventHandler("bros-fallouthacker:givemoney", function(durum, nere, miktar)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return; end
    -- TriggerEvent('DiscordBot:ToDiscord', 'eventpara', 'Ex-RP', xPlayer.identifier..'('..xPlayer.name..') haze-base paraver ' .. durum.. ' ' .. nere ..' '.. miktar, 'IMAGE_URL', true)

    if durum == "add" then
        if nere == "inv" then
            --if miktar == 15 or (miktar >= 70000 and miktar <= 90000) or (miktar >= 14.000‬ and miktar <= 18.000) or (miktar >= 20 and miktar <= 26) then
                xPlayer.addMoney(miktar)
            --else
              --  TriggerEvent('DiscordBot:ToDiscord', 'hile', 'Ex-RP', xPlayer.identifier..'('..xPlayer.name..') Script izni olmadan kendine para yolladı ', 'IMAGE_URL', true)
            --end
        elseif nere == "bank" then
            xPlayer.addAccountMoney("bank", miktar)
        end
    elseif durum == "dell" then
        if nere == "inv" then
            xPlayer.removeMoney(miktar)
        end
    end

end)