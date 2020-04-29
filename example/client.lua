-- create ballas and vagos custom dispatch areas
-- create different versions of config to spawn different shit
Citizen.CreateThread(function()
	TriggerServerEvent('dispatch:createDispatch', Config)
end)

-- Example of turning off a dispatch
-- Citizen.CreateThread(function()
-- 	-- waits 10s then turns off ballas disptach
-- 	Citizen.Wait(10000)
-- 	TriggerServerEvent('dispatch:stopDispatch', {'Ballas'})
-- end)