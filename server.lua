local QBCore = exports['qb-core']:GetCoreObject()

-- Register the 'stats' command
QBCore.Commands.Add('stats', 'Show player stats', {}, false, function(source, args)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local health = Player.PlayerData.metadata.health or 100
    local hygiene = Player.PlayerData.metadata.hygiene or 100
    local stress = Player.PlayerData.metadata.stress or 0

    -- Send stats to the client
    TriggerClientEvent('showStats', src, health, hygiene, stress)
end)

-- Register the 'read' command
QBCore.Commands.Add('read', 'Read a book to reduce stress', {}, false, function(source, args)
    TriggerClientEvent('startReading', source)
end)

-- Server event to update player metadata
RegisterServerEvent('updatePlayerMetadata')
AddEventHandler('updatePlayerMetadata', function(key, value)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.SetMetaData(key, value)
        print('Server: Updated ' .. key .. ' to ' .. value)
    end
end)
