if Config.Framework == 'qbcore' then
    Framework = exports['qb-core']:GetCoreObject()
    PlayerData = Framework.Functions.GetPlayerData()

    RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        PlayerData = Framework.Functions.GetPlayerData()
    end)

    RegisterNetEvent('QBCore:Player:SetPlayerData', function(val)
        PlayerData = val
    end)

    RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
        PlayerData = {}
    end)
end

if Config.Framework == 'esxlegacy' then
    Framework = exports['es_extended']:getSharedObject()
    PlayerData = Framework.GetPlayerData()

    AddEventHandler('esx:setPlayerData', function(key, val, last)
        if GetInvokingResource() == 'es_extended' then
            PlayerData[key] = val
            if OnPlayerData then
                OnPlayerData(key, val, last)
            end
        end
    end)

    RegisterNetEvent('esx:playerLoaded', function(xPlayer)
        PlayerData = xPlayer
        Framework.PlayerLoaded = true
    end)

    RegisterNetEvent('esx:onPlayerLogout', function()
        Framework.PlayerLoaded = false
        PlayerData = {}
    end)
end