RegisterServerEvent('dispatch:createDispatch')
AddEventHandler('dispatch:createDispatch', function(config)
    TriggerClientEvent("dispatch:createAOEListener", -1, config)
end)

RegisterServerEvent('dispatch:stopDispatch')
AddEventHandler('dispatch:stopDispatch', function(names)
    TriggerClientEvent("dispatch:stopAOEListener", -1, names)
end)

RegisterServerEvent('dispatch:getEntitiesFromClient')
AddEventHandler('dispatch:getEntitiesFromClient', function(entities)
    TriggerClientEvent("dispatch:deleteEntitiesFromServer", -1, entities)
end)