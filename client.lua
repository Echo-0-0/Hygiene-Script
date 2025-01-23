local function showStats()
    local ped = PlayerPedId()
    local health = GetEntityHealth(ped) / 2 -- Convert health to percentage
    local hygiene = 0
    local stress = 0

    if QBCore then
        local Player = QBCore.Functions.GetPlayerData()
        if Player then
            hygiene = Player.metadata.hygiene or Config.DefaultHygiene
            stress = Player.metadata.stress or 0
        end
    end

    exports['ox_lib']:notify({
        title = "Your Stats",
        description = string.format("Hygiene: %d%%\nStress: %d%%\nHealth: %d%%", hygiene, stress, math.floor(health)),
        type = "info"
    })
end

RegisterCommand('stats', function()
    showStats()
end, false)

local function setupPolyzones()
    for _, model in ipairs(Config.SinkAndShowerModels) do
        exports['qb-target']:AddTargetModel(model, {
            options = {
                {
                    icon = "fas fa-hand-holding-water",
                    label = "Wash Yourself",
                    action = function()
                        local ped = PlayerPedId()
                        local animDict = Config.WashAnimation.dict
                        local animName = Config.WashAnimation.anim
                        local animDuration = Config.WashAnimation.duration

                        QBCore.Functions.Progressbar("wash_hygiene", "Washing...", animDuration, false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = animDict,
                            anim = animName,
                            flags = 1,
                        }, {}, {}, function()
                            -- On success
                            TriggerServerEvent('hygiene:restoreHygiene')
                            print("Hygiene restored via wash")
                        end, function()
                            -- On cancel
                            ClearPedTasks(ped)
                            TriggerEvent('QBCore:Notify', "You stopped washing yourself!", "error")
                            print("Wash action canceled")
                        end)
                    end
                }
            },
            distance = Config.PolyzoneRadius
        })
    end

    CreateThread(function()
        for _, model in ipairs(Config.SinkAndShowerModels) do
            local coords = GetEntityCoords(model)
            if coords then
                exports['PolyZone']:CreateCircleZone("hygiene_zone_" .. model, coords, Config.PolyzoneRadius, {
                    name = "hygiene_zone_" .. model,
                    debugPoly = true,
                })
                print("PolyZone created for model: " .. tostring(model))
            else
                print("Error: Could not retrieve coordinates for model: " .. tostring(model))
            end
        end
    end)
end

CreateThread(setupPolyzones)

RegisterNetEvent('hygiene:update')
AddEventHandler('hygiene:update', function(hygiene)
    -- Update client-side hygiene level (implementation depends on your UI)
    print("Hygiene updated: " .. tostring(hygiene))
end)
