# callbacks

Network callbacks for FiveM and RedM, allowing data to be sent between server and client more conveniently and even in a synchronous manner.

# Usage

## Server callbacks

```lua
-- server.lua
exports.callbacks:registerServerCallback("getPlayers", function(source)
  return GetPlayers()
end)
```

### Asynchronous

```lua
-- client.lua
exports.callbacks:triggerServerCallback("getPlayers", function(players)
	print(#players)
end)
```

### Synchronous

```lua
-- client.lua
local players = exports.callbacks:awaitServerCallback("getPlayers")
print(#players)
```

### Promise-based

```lua
-- client.lua
exports.callbacks:deferServerCallback("getPlayers"):next(function(players)
	print(#players)
end)
```

## Client callbacks

```lua
-- client.lua
exports.callbacks:registerClientCallback("getCoords", function()
  return GetEntityCoords(PlayerPedId())
end)
```

### Asynchronous

```lua
-- server.lua
exports.callbacks:triggerClientCallback("getCoords", 1, function(coords)
	print(coords)
end)
```

### Synchronous

```lua
-- server.lua
local coords = exports.callbacks:awaitClientCallback("getCoords", 1)
print(coords)
```

### Promise-based

```lua
-- server.lua
exports.callbacks:deferClientCallback("getCoords", 1):next(function(coords)
	print(coords)
end)
```
