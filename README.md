# hackee-dispatch ([original forum post](https://forum.cfx.re/t/release-esx-hackee-dispatch-configure-custom-npc-dispatches/1176475))



## What is it?
This is a utility that makes creating custom "dispatches" of NPCs a little easier. What is a dispatch you might ask? An example would be the random NPCs that start spawning if you shoot in a gang area (like near grove street): ![example](https://i.imgur.com/mLj9K4d.png)

The idea is that if you are going to make your own resource involving NPCs, maybe a raid, or maybe just setting up some gang terf, you can use this utility to more easily setup how the NPCs will behave. **With this utility, you can now create a custom dispatch consisting of whatever NPCs you want, that get triggered based on whatever you want, with whatever weapons you want, in whatever area you want, etc. You can also make NPCs allies or enemies with players based on the player's job type (ESX)!**

When all said and done, your resources should look like this:
```
ensure hackee-dispatch
ensure my-gangs
ensure my-special-raid
etc.
```

## How do I use it?
First off, it is highly recommended you turn off the existing dispatches prior to using mine (get [disabledispatch](https://forum.cfx.re/t/release-disable-all-emergency-service-and-military-dispatching/23823) AND [Calm-AI](https://github.com/NickThe0ne/Calm-AI)). Next you have two events you can use to control your dispatches:

### dispatch:createDispatch
```lua
Citizen.CreateThread(function()
	TriggerServerEvent('dispatch:createDispatch', Config)
end)
```
This event takes a `Config`, which you would have to define for your resource. The `Config` can consist of a singular dispatch squad or multiple dispatch squads, the choice is yours! See the [example resource config](https://github.com/Henry12116/hackee-dispatch/blob/master/example/config.lua) for more info.

### dispatch:stopDispatch
```lua
Citizen.CreateThread(function()
	TriggerServerEvent('dispatch:stopDispatch', {'Ballas'})
end)
```
This event takes a table of `Names`. These names should correspond with the names inside your `Config`. What this does is essentially stop an area from listeining for triggering events, so NPCs won't spawn.

## Configuration
`Config.DebugMode` - Show aoe markers or not.

`Config.DispatchSquads` - Table of configured dispatch squads.

### Within Each `DispatchSquad` You Can Configure
`Name` - Name of the squad

`AlliesWith` - Group hash they will be allies with

`EnemiesWith` - player job (ESX) they will be enemies with

`Event` - What event will trigger the squad to spawn. Examples include gun shots, has weapon out, honks horn, etc. [See full list here](https://runtime.fivem.net/doc/natives/?_0x1374ABB7C15BAB92).

`NumberOfWaves` - # waves of npcs

`NumberPerWave` - # npcs per wave

`TimeBetweenWaves` - time in ms between waves

`TimeBeforeUpAgain` - time before dispatch is up again

`TriggerDistance` - distance can be triggered

`CentralPos` - Central position of dispatch

`RepSet` - throw up gang signs before attacking

`TauntOnKill` - take pictures if player dies or leaves

`NPCs` - table of npc hashes

`NPCWeapons` - table contianing weapon hash and type

`NPCSpawnPoints` - spawn points for npcs

## Pictures
![example1](https://i.imgur.com/Xy2gfjt.png)
Notice here because my job is Vagos and im shooting in the Ballas area, the NPCs start spawning and attacking me.

![example2](https://i.imgur.com/ca9ed2L.png)
Since my job is Vagos, no NPCs spawn when I shoot because they are allied with me.

![example3](https://i.imgur.com/AV09ypw.png)
You also have the option for the NPCs to take pictures of you if you die or leave the area :-)

## Things to note
If there is a shocking event in the AOE, a dispatch will spawn for every player in the aoe (that's configured as an enemy). So for example, if you had a dispatch configured to spawn 2 waves with 2 enemies each wave, but there were 3 enemy players in the AOE when it was triggered... then 6 waves with 6 enemies each wave will spawn. This can become very difficult very quick, so I'm currently looking at ways to make it not scale linearaly.