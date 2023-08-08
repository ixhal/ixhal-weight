local modified_speed = nil
local last_modified_speed = nil
local PlayerPed = nil

local GetClosestWeightIndex = function(weight)
    local close_weight_index = nil

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

local GetPlayerWeight

if Config.Framework == 'qbcore' then
    if Config.Inventory == 'default' then
        GetPlayerWeight = function()
            local weight = 0

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

if Config.Inventory == 'ox_inventory' then
    GetPlayerWeight = function()
        local weight = 0
        local items = exports.ox_inventory:GetPlayerItems()
        for k, v in pairs(items) do weight += v.weight * v.count end
        return weight
    end
end

local function MakePlayerMoveSlower(speed)
    PlayerPed = PlayerPedId()
    if last_modified_speed == speed then return end
    last_modified_speed = speed
    Citizen.CreateThread(function()
        while modified_speed == speed do
            if Config.effect_sprint_only == true and (IsPedJumping(PlayerPed) or IsPedSprinting(PlayerPed) or IsPedRunning(PlayerPed)) or Config.effect_sprint_only == false then
                SetPedMoveRateOverride(PlayerPed, modified_speed);
            end
            Citizen.Wait(0)
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        modified_speed = GetSpeedFromWeightIndex(GetClosestWeightIndex(GetPlayerWeight()))
        if modified_speed ~= 1.0 then MakePlayerMoveSlower(modified_speed) else last_modified_speed = 1.0 end
        Citizen.Wait(Config.check_interval)
    end
end)