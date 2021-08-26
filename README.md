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

### Asynchronous (`triggerServerCallback`)

```lua
-- client.lua
exports.callbacks:triggerServerCallback("getPlayers", function(players)
	print(#players)
end)
```

### Synchronous (`awaitServerCallback`)

```lua
-- client.lua
local players = exports.callbacks:awaitServerCallback("getPlayers")
print(#players)
```

### Promise-based (`deferServerCallback`)

```lua
-- client.lua
exports.callbacks:deferServerCallback("getPlayers"):next(function(results)
	local players = table.unpack(results)
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

### Asynchronous (`triggerClientCallback`)

```lua
-- server.lua
exports.callbacks:triggerClientCallback("getCoords", 1, function(coords)
	print(coords)
end)
```

### Synchronous (`awaitClientCallback`)

```lua
-- server.lua
local coords = exports.callbacks:awaitClientCallback("getCoords", 1)
print(coords)
```

### Promise-based (`deferClientCallback`)

```lua
-- server.lua
exports.callbacks:deferClientCallback("getCoords", 1):next(function(results)
	local coords = table.unpack(results)
	print(coords)
end)
```
