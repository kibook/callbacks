--- Client -> server callbacks

RegisterNetEvent("callbacks:triggerCallback", function(callbackName, ticket, ...)
	local fn = getCallbackHandler(callbackName)

	if fn then
		fn(function(...)
			TriggerServerEvent("callbacks:endCallback", callbackName, ticket, ...)
		end, ...)
	end
end)

RegisterNetEvent("callbacks:endCallback", function(callbackName, ticket, ...)
	local fn = getCallbackResolution(callbackName, ticket)

	if fn then
		fn(...)
	end
end)

--- Execute a server callback asynchronously
-- @function triggerServerCallback
-- @param callbackName The name of the server callback
-- @param cb A callback function to execute when the server callback completes
-- @param ... Additional parameters passed to the server callback
-- @usage exports.callbacks:triggerServerCallback("getNumPlayers", function(numPlayers) print(numPlayers) end)
exports("triggerServerCallback", function(callbackName, cb, ...)
	local ticket = generateTicket()

	addCallbackResolution(callbackName, ticket, function(...)
		cb(...)
		removeCallbackResolution(callbackName, ticket)
	end)

	TriggerServerEvent("callbacks:triggerCallback", callbackName, ticket, ...)
end)

local function deferServerCallback(callbackName, ...)
	local ticket = generateTicket()

	local p = promise.new()

	addCallbackResolution(callbackName, ticket, function(...)
		p:resolve{...}
		removeCallbackResolution(callbackName, ticket)
	end)

	TriggerServerEvent("callbacks:triggerCallback", callbackName, ticket, ...)

	return p
end

--- Create a promise for a server callback
-- @function deferServerCallback
-- @param callbackName The name of the server callback
-- @param ... Additional parameters passed to the server callback
-- @return A new promise that will be resolved when the server callback completes
-- @usage exports.callbacks:deferServerCallback("getNumPlayers"):next(function(numPlayers) print(numPlayers) end)
exports("deferServerCallback", deferServerCallback)

--- Execute a server callback synchronously
-- @function awaitServerCallback
-- @param callbackName The name of the server callback
-- @param ... Additional parameters passed to the server callback
-- @return Any value(s) returned by the server callback
-- @usage local numPlayers = exports.callbacks:awaitServerCallback("getNumPlayers")
exports("awaitServerCallback", function(callbackName, ...)
	local p = deferServerCallback(callbackName, ...)
	local result = Citizen.Await(p)
	return table.unpack(result)
end)

--- Register a new client callback
-- @function registerClientCallback
-- @param callbackName The name of the new client callback
-- @param fn The function to execute when this client callback is executed
-- @usage exports.callbacks:registerClientCallback("getCoords", function() return GetEntityCoords(PlayerPedId()) end)
exports("registerClientCallback", function(callbackName, fn)
	addCallbackHandler(callbackName, function(cb, ...)
		cb(fn(...))
	end)
end)

--- Remove a registered client callback
-- @function removeClientCallback
-- @param callbackName The name of the registered client callback
-- @usage exports.callbacks:removeClientCallback("getCoords")
exports("removeClientCallback", function(callbackName)
	removeCallbackHandler(callbackName)
end)
