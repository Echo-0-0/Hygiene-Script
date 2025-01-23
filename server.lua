QBCore = exports['qb-core']:GetCoreObject()
local playerHygiene = {}

AddEventHandler('QBCore:Server:PlayerLoaded', function(playerId)
    local Player = QBCore.Functions.GetPlayer(playerId)
    if Player then
        local hygiene = Player.Functions.GetMetaData('hygiene')
        if hygiene == nil then
            hygiene = Config.DefaultHygiene
        end
        playerHygiene[playerId] = hygiene
        TriggerClientEvent('hygiene:update', playerId, hygiene)
    end
end)

AddEventHandler('QBCore:Server:PlayerDropped', function(playerId)
    if playerHygiene[playerId] ~= nil then
        local Player = QBCore.Functions.GetPlayer(playerId)
        if Player then
            Player.Functions.SetMetaData('hygiene', playerHygiene[playerId])
        end
        playerHygiene[playerId] = nil
    end
end)

CreateThread(function()
    while true do
        Wait(1000)
        for playerId, hygiene in pairs(playerHygiene) do
            if hygiene > 0 then
                playerHygiene[playerId] = math.max(hygiene - Config.HygieneDecreaseRate, 0)
                TriggerClientEvent('hygiene:update', playerId, playerHygiene[playerId])
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(Config.HygieneEffectsInterval * 1000)
        for playerId, hygiene in pairs(playerHygiene) do
            if hygiene <= Config.LowHygieneThreshold then
                local Player = QBCore.Functions.GetPlayer(playerId)
                if Player then
                    Player.Functions.RemoveStress(1)
                    Player.Functions.SetMetaData('health', Player.PlayerData.metadata.health - 1)
                    TriggerClientEvent('QBCore:Notify', playerId, "Your hygiene is very low! Take care of yourself!", "error")
                end
            end
        end
    end
end)

RegisterNetEvent('hygiene:restoreHygiene')
AddEventHandler('hygiene:restoreHygiene', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        playerHygiene[src] = Config.DefaultHygiene
        TriggerClientEvent('hygiene:update', src, Config.DefaultHygiene)
        TriggerClientEvent('QBCore:Notify', src, "You feel refreshed!", "success")
    end
end)

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
