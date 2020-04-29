Config = {}
Config.DebugMode = true
Config.DispatchSquads = {
    Ballas = {
        Name = "Ballas",
        AlliesWith = {
            GetHashKey("AMBIENT_GANG_BALLAS")
        },
        EnemiesWith = { -- corresponds with esx player job
            'vagos',
            'unemployed',
            'police',
            'cardealer',
            'mechanic',
            'taxi'
        },
        Event = 89, -- number cooresponts to https://runtime.fivem.net/doc/natives/?_0x1374ABB7C15BAB92
        NumberOfWaves = 3,
        NumberPerWave = 2,
        TimeBetweenWaves = math.random(5000, 8000), -- in ms
        TimeBeforeUpAgain = math.random(60000, 80000), -- time here minus time between waves = total wait
        TriggerDistance = 20.78,
        CentralPos = vector3(108.48, -1946.71, 20.78),
        RepSet = true,
        TauntOnKill = true,
        NPCs = {
            GetHashKey('g_m_y_ballaeast_01'),
            GetHashKey('g_m_y_ballaorig_01'),
            GetHashKey('g_m_y_ballasout_01'),
            GetHashKey('csb_ballasog')
        },
        NPCWeapons = {
            {wep = GetHashKey('weapon_pistol'), type='gun'},
            {wep = GetHashKey('weapon_bat'), type='melee'}
        },
        NPCSpawnPoints = {
            {x=85.85, y=-1958.51, z=21.53, h=317.02},
            {x=78.85, y=-1947.51, z=21.53, h=280.02},
            {x=81.85, y=-1942.51, z=20.53, h=289.02},
            {x=97.85, y=-1916.51, z=20.53, h=154.02},
            {x=116.85, y=-1922.51, z=20.53, h=140.02},
            {x=124.85, y=-1929.64, z=20.53, h=110.02},
            {x=126.85, y=-1942.64, z=20.53, h=86.02},
            {x=112.85, y=-1959.64, z=20.53, h=18.02},
            {x=108.65, y=-1971.64, z=20.53, h=107.02},
            {x=93.65, y=-1976.64, z=20.53, h=64.02},
            {x=85.65, y=-1967.64, z=20.53, h=228.02},
            {x=74.65, y=-1936.64, z=20.53, h=310.02},
            {x=121.65, y=-1935.64, z=20.53, h=104.02}
        },
    },
    Vagos = {
        Name = "Vagos",
        AlliesWith = {
            GetHashKey("AMBIENT_GANG_MEXICAN"),
            GetHashKey("AMBIENT_GANG_SALVA")
        },
        EnemiesWith = {
            'ballas',
            'unemployed',
            'police',
            'cardealer',
            'mechanic',
            'taxi'
        },
        Event = 89,
        NumberOfWaves = 3,
        NumberPerWave = 2,
        TimeBetweenWaves = math.random(5000, 8000), -- in ms
        TimeBeforeUpAgain = math.random(60000, 80000), -- time here minus time between waves = total wait
        TriggerDistance = 20.78,
        CentralPos = vector3(332.86, -2039.41, 20.78),
        RepSet = true,
        TauntOnKill = true,
        NPCs = {
            GetHashKey('g_f_y_vagos_01'),
            GetHashKey('ig_ramp_mex'),
            GetHashKey('ig_ortega'),
            GetHashKey('g_m_y_mexgoon_02')
        },
        NPCWeapons = {
            {wep = GetHashKey('weapon_pistol'), type='gun'},
            {wep = GetHashKey('weapon_bat'), type='melee'}
        },
        NPCSpawnPoints = {
            {x=326.17, y=-2049.51, z=20.02, h=317.13},
            {x=317.17, y=-2042.51, z=20.02, h=325.13},
            {x=314.17, y=-2039.51, z=20.02, h=317.13},
            {x=299.17, y=-2034.51, z=19.02, h=317.13},
            {x=331.17, y=-2020.51, z=21.02, h=151.13},
            {x=334.17, y=-2023.51, z=21.02, h=136.13},
            {x=342.17, y=-2028.51, z=21.02, h=140.13},
            {x=343.17, y=-2030.51, z=21.02, h=138.13},
            {x=351.17, y=-2036.51, z=22.02, h=138.13},
            {x=359.17, y=-2043.51, z=22.02, h=133.13},
            {x=363.17, y=-2046.51, z=22.02, h=125.13},
            {x=370.17, y=-2055.51, z=21.02, h=49.13},
            {x=363.17, y=-2064.51, z=21.02, h=45.13},
            {x=356.17, y=-2073.51, z=21.02, h=47.13},
            {x=356.17, y=-2073.51, z=21.02, h=47.13},
            {x=346.17, y=-2066.51, z=20.02, h=322.13},
            {x=343.17, y=-2063.51, z=20.02, h=314.13}
        },
    }
}