--- Server -> client callbacks

RegisterNetEvent("callbacks:triggerCallback", function(callbackName, ticket, ...)
	local source = source
	local fn = getCallbackHandler(callbackName)

	if fn then
		fn(function(...)
			TriggerClientEvent("callbacks:endCallback", source, callbackName, ticket, ...)
		end, source, ...)
	end
end)

RegisterNetEvent("callbacks:endCallback", function(callbackName, ticket, ...)
	local fn = getCallbackResolution(callbackName, ticket)

	if fn then
		fn(source, ...)
	end
end)

--- Execute a client callback asynchronously
-- @function triggerClientCallback
-- @param callbackName The name of the client callback
-- @param source The client to execute the callback on
-- @param cb A callback function to execute when the client callback completes
-- @param ... Additonal parameters passed to the client callback
-- @usage exports.callbacks:triggerClientCallback("getCoords", 1, function(coords) print(coords) end)
exports("triggerClientCallback", function(callbackName, src, cb, ...)
	src = tonumber(src)

	local ticket = generateTicket()

	addCallbackResolution(callbackName, ticket, function(source, ...)
		if src == source then
			cb(...)
			removeCallbackResolution(callbackName, ticket)
		end
	end)

	TriggerClientEvent("callbacks:triggerCallback", src, callbackName, ticket, ...)
end)

local function deferClientCallback(callbackName, src, ...)
	src = tonumber(src)

	local ticket = generateTicket()

	local p = promise.new()

	addCallbackResolution(callbackName, ticket, function(source, ...)
		if src == source then
			p:resolve{...}
			removeCallbackResolution(callbackName, ticket)
		end
	end)

	TriggerClientEvent("callbacks:triggerCallback", src, callbackName, ticket, ...)

	return p
end

--- Create a promise for a client callback
-- @function deferClientCallback
-- @param callbackName The name of the client callback
-- @param source The client to execute the callback on
-- @param ... Additional parameters passed to the client callback
-- @return A new promise that will be resolved when the client callback completes. If the callback returns multiple values, they will be wrapped in a table.
-- @usage exports.callbacks:deferClientCallback("getCoords", 1):next(function(coords) print(coords) end)
exports("deferClientCallback", function(callbackName, ...)
	local p = promise.new()

	deferClientCallback(callbackName, ...):next(function(results)
		if #results < 2 then
			p:resolve(results[1])
		else
			p:resolve(results)
		end
	end)

	return p
end)

--- Execute a client callback synchronously
-- @function awaitClientCallback
-- @param callbackName The name of the client callback
-- @param source The client to execute the callback on
-- @param ... Additional parameters passed to the client callback
-- @return Any value(s) returned by the client callback
-- @usage local coords = exports.callbacks:awaitClientCallback("getCoords", 1)
exports("awaitClientCallback", function(callbackName, src, ...)
	local p = deferClientCallback(callbackName, src, ...)
	local result = Citizen.Await(p)
	return table.unpack(result)
end)

--- Register a new server callback
-- @function registerServerCallback
-- @param callbackName The name of the new server callback
-- @param fn The function to execute when this server callback is executed
-- @usage exports.callbacks:registerServerCallback("getNumPlayers", function(source) return #GetPlayers() end)
exports("registerServerCallback", function(callbackName, fn)
	addCallbackHandler(callbackName, function(cb, source, ...)
		cb(fn(source, ...))
	end)
end)

--- Remove a registered server callback
-- @function removeServerCallback
-- @param callbackName The name of the registered server callback
-- @usage exports.callbacks:removeServerCallback("getNumPlayers")
exports("removeServerCallback", function(callbackName)
	removeCallbackHandler(callbackName)
end)
