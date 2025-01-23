local QBCore = exports['qb-core']:GetCoreObject()

local health = 100
local hygiene = 100
local stress = 0

-- Function to display notifications
function notify(message)
    QBCore.Functions.Notify(message, 'error')
end

-- Function to display player stats menu
function showStatsMenu(health, hygiene, stress)
    lib.registerContext({
        id = 'player_stats_menu',
        title = 'Player Stats',
        options = {
            {
                title = 'Health',
                description = health .. '%',
            },
            {
                title = 'Hygiene',
                description = hygiene .. '%',
            },
            {
                title = 'Stress',
                description = stress .. '%',
            }
        }
    })
    lib.showContext('player_stats_menu')
end

-- Add the stats menu to the QB radial menu in the top left space
RegisterNetEvent('qb-radialmenu:client:openMenu')
AddEventHandler('qb-radialmenu:client:openMenu', function()
    exports['qb-radialmenu']:AddOption({
        id = 'player_stats',
        title = 'Player Stats',
        icon = 'fa-solid fa-chart-bar',
        type = 'client',
        event = 'showStatsRadialMenu',
        shouldClose = true
    }, {
        menu = 'main',
        id = 'top_left',
    })
end)

-- Event to display player stats when using the radial menu
RegisterNetEvent('showStatsRadialMenu')
AddEventHandler('showStatsRadialMenu', function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    local currentHealth = PlayerData.metadata.health or 100
    local currentHygiene = PlayerData.metadata.hygiene or 100
    local currentStress = PlayerData.metadata.stress or 0
    showStatsMenu(currentHealth, currentHygiene, currentStress)
end)

-- Decrease hygiene every 15 minutes if player is not in water
CreateThread(function()
    while QBCore == nil do
        Wait(100)
    end
    while true do
        Wait(900000) -- 15 minutes
        if not IsPedSwimming(PlayerPedId()) then
            hygiene = math.max(hygiene - 10, 0)
        end
        -- Notify player if hygiene is low
        if hygiene <= 20 then
            notify("Your hygiene is very low!")
        end
        -- Notify player if health is low
        if health <= 20 then
            notify("Your health is very low!")
        end
        -- Notify player if stress is high
        if stress >= 80 then
            notify("Your stress level is very high!")
        end
    end
end)

-- Increase hygiene every 5 minutes if player is in water
CreateThread(function()
    while QBCore == nil do
        Wait(100)
    end
    while true do
        Wait(300000) -- 5 minutes
        if IsPedSwimming(PlayerPedId()) then
            hygiene = math.min(hygiene + 10, 100)
        end
    end
end)

-- Event to display player stats
RegisterNetEvent('showStats')
AddEventHandler('showStats', function(currentHealth, currentHygiene, currentStress)
    showStatsMenu(currentHealth, currentHygiene, currentStress)
end)

-- Event to start reading
RegisterNetEvent('startReading')
AddEventHandler('startReading', function()
    -- Play reading animation
    local playerPed = PlayerPedId()
    TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_BOOK_READER', 0, true)
    
    -- Start progress bar
    QBCore.Functions.Progressbar('reading', 'Reading a book...', 10000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        -- Progress bar complete
        ClearPedTasksImmediately(playerPed)
        -- Relieve stress using QBcore function
        TriggerEvent('qb-stress:client:RelieveStress', 5)
        -- Update stress locally
        local PlayerData = QBCore.Functions.GetPlayerData()
        local currentStress = PlayerData.metadata.stress or 0
        currentStress = math.max(currentStress - 5, 0)
        QBCore.Functions.SetMetaData('stress', currentStress)
        -- Update ox_lib menu with new stress level
        showStatsMenu(health, hygiene, currentStress)
        notify("You feel more relaxed after reading.")
        print('Client: Stress relieved by 5')
    end, function()
        -- Progress bar cancelled
        ClearPedTasksImmediately(playerPed)
        notify("You stopped reading.")
    end)
end)
