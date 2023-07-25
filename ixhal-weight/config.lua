Config = {
    --Specify your framework.
    Framework = 'qbcore',--Supports 'qbcore' and 'esxlegacy'

    Inventory = 'default', --Supports 'default' or 'ox_inventory' default is qb-inventory/esx-inventory.

    --This is how often to check the players items to see how much they should be slowed by.
    check_interval = 1000,

    --Should this only take effect when the player is sprinting/jogging?
    --I would recommend this being set to true, it look so much more natural and it will be less annoying for your players.
    effect_sprint_only = true,

    --slow_percent can be 0 - 99.
    --hard coded to not go below 0.01 move speed.
    --Change these to the values that suit you.
    weight_effects = {
        {weight = 2000, slow_percent = 60},
        {weight = 10000, slow_percent = 25},
        {weight = 20000, slow_percent = 50},
    },
}