local modified_speed = nil

local GetPlayerSpeedPercentLoseFromWeight

if Config.Framework == 'qbcore' then
    GetPlayerSpeedPercentLoseFromWeight = function()
        local speed = 1.0
        local weight = 0
        local close_weight_index = nil

        local items = PlayerData.items
        for i, v in pairs(items) do
            if v.weight then
                weight += v.weight * v.amount
            end
        end

        for i = 1, #Config.Weight_Effects, 1 do
            if weight >= Config.Weight_Effects[i].weight then
                close_weight_index = i
            else
                break
            end
        end

        if close_weight_index == nil then return 1.0 end
        if Config.Weight_Effects[close_weight_index].slow_percent > 9 then speed -= tonumber('0.'..Config.Weight_Effects[close_weight_index].slow_percent) else speed -= tonumber('0.0'..Config.Weight_Effects[close_weight_index].slow_percent) end
        if speed <= 0.0 then speed = 0.01 end

        return speed
    end
elseif Config.Framework == 'esxlegacy' then
    GetPlayerSpeedPercentLoseFromWeight = function()
        local speed = 1.0
        local weight = 0
        local close_weight_index = nil

        local items = PlayerData.inventory
        for i, v in pairs(items) do
            if v.weight then
                weight += v.weight * v.count
            end
        end

        for i = 1, #Config.Weight_Effects, 1 do
            if weight >= Config.Weight_Effects[i].weight then
                close_weight_index = i
            else
                break
            end
        end

        if close_weight_index == nil then return 1.0 end
        if Config.Weight_Effects[close_weight_index].slow_percent > 9 then speed -= tonumber('0.'..Config.Weight_Effects[close_weight_index].slow_percent) else speed -= tonumber('0.0'..Config.Weight_Effects[close_weight_index].slow_percent) end
        if speed <= 0.0 then speed = 0.01 end

        return speed
    end
end

local function MakePlayerMoveSlower(speed)
    while modified_speed == speed do
        SetPedMoveRateOverride(PlayerPedId(), modified_speed);
        Citizen.Wait(1)
    end
end

Citizen.CreateThread(function()
    while true do
        modified_speed = GetPlayerSpeedPercentLoseFromWeight()
        if modified_speed ~= 1.0 then MakePlayerMoveSlower(modified_speed) end
        Citizen.Wait(Config.check_interval)
    end
end)