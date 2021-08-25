# callbacks

Network callbacks for FiveM and RedM, allowing data to be sent between server and client in a synchronous manner.

# Usage

## Server callbacks
```lua
-- server.lua
exports.callbacks:registerServerCallback("getPlayers", function(source)
  return GetPlayers()
end)
```
```lua
-- client.lua
local players = exports.callbacks:triggerServerCallback("getPlayers")
```

## Client callbacks
```lua
-- client.lua
exports.callbacks:registerClientCallback("getCoords", function()
  return GetEntityCoords(PlayerPedId())
end)
```
```lua
-- server.lua
local player1Coords = exports.callbacks:triggerClientCallback("getCoords", 1)
```
