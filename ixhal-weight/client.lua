local modified_speed = nil
local last_modified_speed = nil

local GetClosestWeightIndex = function(weight)
    local close_weight_index = nil
    if Config.Inventory == 'ox-inventory' then weight = exports.ox_inventory:GetPlayerWeight() end
    for i = 1, #Config.weight_effects, 1 do
        if weight >= Config.weight_effects[i].weight then
            close_weight_index = i
        else
            break
        end
    end

    return close_weight_index
end

local GetSpeedFromWeightIndex = function(index)
    if index == nil then return 1.0 end
    local speed = 1.0 - Config.weight_effects[index].slow_percent / 100
    if speed <= 0.0 then speed = 0.01 end

    return speed
end

local GetPlayerWeight = function()
    if Config.Inventory == 'ox-inventory' then 
        local weight = 0
        local items = exports.ox_inventory:GetPlayerItems()
        for k, v in pairs(items) do weight += v.weight * v.amount end
        return weight
    end
    return 0
end

local GetPlayerSpeedPercentLoseFromWeight = function()
    return GetSpeedFromWeightIndex(GetClosestWeightIndex(GetPlayerWeight()))
end

if Config.Framework == 'qbcore' then
    if Config.Inventory == 'default' then
        GetPlayerWeight = function()
            local weight = 0
            if PlayerData == nil then return 1.0 end
            local items = PlayerData.items
            if items == nil then return 1.0 end
            for i, v in pairs(items) do
                if v.weight then
                    weight += v.weight * v.amount
                end
            end
            return weight
        end
    end
elseif Config.Framework == 'esxlegacy' then
    if Config.Inventory == 'default' then
        GetPlayerWeight = function()
            local weight = 0

            if PlayerData == nil then return 1.0 end
            local items = PlayerData.inventory
            if items == nil then return 1.0 end

            for i, v in pairs(items) do
                if v.weight then
                    weight += v.weight * v.count
                end
            end

            return weight
        end
    end
end

local function MakePlayerMoveSlower(PlayerPed, speed)
    if last_modified_speed == speed then return end
    last_modified_speed = speed
    Citizen.CreateThread(function()
        while modified_speed == speed do
            if Config.effect_sprint_only == true and (IsPedSprinting(PlayerPed) or IsPedRunning(PlayerPed)) or Config.effect_sprint_only == false then
                SetPedMoveRateOverride(PlayerPed, modified_speed);
            end
            Citizen.Wait(0)
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        modified_speed = GetPlayerSpeedPercentLoseFromWeight()
        if modified_speed ~= 1.0 then MakePlayerMoveSlower(PlayerPedId(), modified_speed) else last_modified_speed = 1.0 end
        Citizen.Wait(Config.check_interval)
    end
end)
