ESX = nil
IsLocked = false
ThreadIds = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('dispatch:createAOEListener')
AddEventHandler('dispatch:createAOEListener', function(config)
  for i, squad in pairs(config.DispatchSquads) do
    if config.DebugMode then
      CreateDebugMarker(squad)
    end
    Citizen.CreateThread(function()
      -- ensure mutual exclusion :-)
      while IsLocked do Citizen.Wait(1) end
      Lock = true
      table.insert(ThreadIds, {squad.Name, GetIdOfThisThread()})
      Lock = false

      while true do
        local plyPed = GetPlayerPed(-1)
        local plyPos = GetEntityCoords(plyPed)
        Citizen.Wait(1)
        if ESX.PlayerData.job ~= nil and table.contains( squad.EnemiesWith, ESX.PlayerData.job.name) and (GetVecDist(plyPos, squad.CentralPos) < squad.TriggerDistance) and IsShockingEventInSphere(squad.Event, squad.CentralPos.x, squad.CentralPos.y, squad.CentralPos.z, squad.TriggerDistance) then
          SpawnEnemyDispatch(squad)
          Citizen.Wait(squad.TimeBeforeUpAgain)
        end
      end
    end)
  end
end)

RegisterNetEvent('dispatch:stopAOEListener')
AddEventHandler('dispatch:stopAOEListener', function(names)
  for i, name in pairs(names) do
    for i, threadInfo in pairs(ThreadIds) do
      if name == threadInfo[0] then
        TerminateThread(threadInfo[1])
      end
    end
  end
end)

RegisterNetEvent('dispatch:deleteEntitiesFromServer')
AddEventHandler('dispatch:deleteEntitiesFromServer', function(entities)
  for i, entity in pairs(entities) do
    SetEntityAsNoLongerNeeded(entity)
    DeleteEntity(entity)
    Citizen.Wait(math.random(500, 2000))
  end
end)

-- Draw marker for dev testing
function CreateDebugMarker(squad)
  Citizen.CreateThread(function()
    while true do
      Citizen.Wait(0)
      DrawMarker(25, squad.CentralPos.x, squad.CentralPos.y, squad.CentralPos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 50.0, 50.0, 50.0, 0, 0, 250, 100, false, true, 2, false, false, false, false)
    end
  end)
end

function SpawnEnemyDispatch(squad)
  plyPed = GetPlayerPed(-1)
  plyPos = GetEntityCoords(plyPed)

  for i=1,squad.NumberOfWaves do
    -- if player died or left radius, stop
    if IsEntityDead(plyPed) or (GetVecDist(plyPos, squad.CentralPos) > squad.TriggerDistance)then
      break
    end
    for j=1,squad.NumberPerWave do
      CreateNPCThread(squad, plyPed)
    end
    Citizen.Wait(squad.TimeBetweenWaves)
  end
end

function CreateNPCThread(squad, plyPed)
  if table.contains( squad.EnemiesWith, ESX.PlayerData.job.name) then
    Citizen.CreateThread(function()
      Citizen.Wait(0)
      local npcIndex = math.random(table.length(squad.NPCs))
      local npcWepIndex = math.random(table.length(squad.NPCWeapons))
      local npcSpawnIndex = math.random(table.length(squad.NPCSpawnPoints))

      local npc = squad.NPCs[npcIndex]
      local spawnPoint = squad.NPCSpawnPoints[npcSpawnIndex]
      if not HasModelLoaded(npc) then RequestModel(npc); end
      while not HasModelLoaded(npc) do RequestModel(npc); Citizen.Wait(0); end

      -- Randomly spawn in npc
      Citizen.Wait(math.random(1000, 2000))
      local createdNPC = CreatePed(4, npc, spawnPoint.x, spawnPoint.y, spawnPoint.z, spawnPoint.h, true, false)
      SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(createdNPC), true)

      SetPedAccuracy(createdNPC, 60)
      SetPedRelationshipGroupHash(createdNPC, GetHashKey("AMBIENT_GANG_WEICHENG"))
      SetPedRelationshipGroupDefaultHash(createdNPC, GetHashKey("AMBIENT_GANG_WEICHENG"))

      -- set npc relationship with local gang npcs
      for i, ally in pairs(squad.AlliesWith) do
        SetRelationshipBetweenGroups(0, GetHashKey("AMBIENT_GANG_WEICHENG"), ally)
        SetRelationshipBetweenGroups(0, ally, GetHashKey("AMBIENT_GANG_WEICHENG"))
      end

      -- make npc not flee and give weapon
      SetPedCombatAttributes(createdNPC, 46, true)
      GiveWeaponToPed(createdNPC, squad.NPCWeapons[npcWepIndex].wep, 300, false, true)
      SetPedDropsWeaponsWhenDead(createdNPC, false)

      -- throw up gang signs
      if squad.RepSet then
        LoadAnimDict( "mp_player_int_uppergang_sign_a" )
        TaskPlayAnim(createdNPC, "mp_player_int_uppergang_sign_a", "mp_player_int_gang_sign_a", 8.0, -8.0, -1, 5, 0, 0, 0, 0 )
        Citizen.Wait(math.random(1500, 2500))
      end

      -- start attacking
      TaskCombatPed(createdNPC, plyPed, 0, 16)
      Citizen.Wait(1)
      TaskGotoEntityAiming(createdNPC, plyPed, 8.0, 10.0)

      local dist = GetVecDist(GetEntityCoords(plyPed), GetEntityCoords(createdNPC))
      local minDist = 20.0
      local wepType = squad.NPCWeapons[npcWepIndex].type

      if wepType == 'melee' then
        minDist = 2.0
      end

      -- while player alive and in area, and npc isnt dead, continue to attack
      while (not IsEntityDead(plyPed)) and (GetVecDist(GetEntityCoords(plyPed), squad.CentralPos) < squad.TriggerDistance) and (not IsPedDeadOrDying(createdNPC, 1)) do        
        if dist > minDist then
          plyPos = GetEntityCoords(plyPed)
          dist = GetVecDist(plyPos, GetEntityCoords(createdNPC))
          TaskGotoEntityAiming(createdNPC, plyPed, 3.0, 5.0)
          Citizen.Wait(1000)
        else
          if wepType == 'gun' then
            TaskShootAtEntity(createdNPC, plyPed, -1, GetHashKey("FIRING_PATTERN_BURST_FIRE"))
            Citizen.Wait(1000)
          else
            TaskPutPedDirectlyIntoMelee(createdNPC, plyPed, 0.0, -1.0, 0.0, 0);
            Citizen.Wait(1000)
          end
        end
      end

      -- player has now died or left area
      if not IsEntityDead(createdNPC) then
        ClearPedTasksImmediately(createdNPC)

        -- take pictures lol
        if squad.TauntOnKill then
          MakeEntityFaceEntity(createdNPC, plyPed)
          Citizen.Wait(math.random(500, 2000))
          TaskStartScenarioInPlace(createdNPC, "WORLD_HUMAN_PAPARAZZI", 0, false)
          Citizen.Wait(math.random(10000, 20000))
        end

        TaskGoToCoordAnyMeans(createdNPC, spawnPoint.x, spawnPoint.y, spawnPoint.z, 5.0, 0, 0, 1, 10.0)
        Citizen.Wait(math.random(3000, 8000))
      end

      DeleteNPC(createdNPC)
    end)
  end
end

function DeleteNPC(entity)
  TriggerServerEvent("dispatch:getEntitiesFromClient", {entity})
end

function LoadAnimDict(dict)
	RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		Citizen.Wait(500)
	end
end

function GetVecDist(v1,v2)
    if not v1 or not v2 or not v1.x or not v2.x then return 0; end
    return math.sqrt(  ( (v1.x or 0) - (v2.x or 0) )*(  (v1.x or 0) - (v2.x or 0) )+( (v1.y or 0) - (v2.y or 0) )*( (v1.y or 0) - (v2.y or 0) )+( (v1.z or 0) - (v2.z or 0) )*( (v1.z or 0) - (v2.z or 0) )  )
end

function MakeEntityFaceEntity( entity1, entity2 )
  local p1 = GetEntityCoords(entity1, true)
  local p2 = GetEntityCoords(entity2, true)

  local dx = p2.x - p1.x
  local dy = p2.y - p1.y

  local heading = GetHeadingFromVector_2d(dx, dy)
  SetEntityHeading( entity1, heading )
end

function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function table.length(table)
  local count = 0
  for _ in pairs(table) do count = count + 1 end
  return count
end