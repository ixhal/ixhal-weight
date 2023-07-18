Config = {
    Framework = 'esxlegacy',--Supports 'qbcore' and 'esxlegacy'

    --This is how often to check the players items to see how much they should be slowed by.
    check_interval = 1000,

    --slow_percent can be 0 - 99.
    --I actually hard coded it to not go below 0.01 move speed.
    --Change these to the values that suit you.
    Weight_Effects = {
        {weight = 10000, slow_percent = 1},
        {weight = 20000, slow_percent = 2},
        {weight = 40000, slow_percent = 3},
        {weight = 80000, slow_percent = 5},
        {weight = 160000, slow_percent = 10},
        {weight = 320000, slow_percent = 15},
    },
}