RegisterNetEvent("callbacks:triggerCallback", function(eventName, ticket, ...)
	local p = promise.new()

	TriggerEvent(("callbacks:startCallback:%s"):format(eventName), function(...)
		p:resolve{...}
	end, ...)

	local result = Citizen.Await(p)
	TriggerServerEvent("callbacks:endCallback", eventName, ticket, table.unpack(result))
end)

RegisterNetEvent("callbacks:endCallback", function(eventName, ticket, ...)
	local fn = getCallbackResolution(eventName, ticket)

	if fn then
		fn(...)
	end
end)

exports("triggerServerCallback", function(eventName, cb, ...)
	local ticket = generateTicket()

	addCallbackResolution(eventName, ticket, function(...)
		cb(...)
		removeCallbackResolution(eventName, ticket)
	end)

	TriggerServerEvent("callbacks:triggerCallback", eventName, ticket, ...)
end)

local function deferServerCallback(eventName, ...)
	local ticket = generateTicket()

	local p = promise.new()

	addCallbackResolution(eventName, ticket, function(...)
		p:resolve{...}
		removeCallbackResolution(eventName, ticket)
	end)

	TriggerServerEvent("callbacks:triggerCallback", eventName, ticket, ...)

	return p
end

exports("deferServerCallback", deferServerCallback)

exports("awaitServerCallback", function(eventName, ...)
	local p = deferServerCallback(eventName, ...)
	local result = Citizen.Await(p)
	return table.unpack(result)
end)

exports("registerClientCallback", function(eventName, fn)
	return AddEventHandler(("callbacks:startCallback:%s"):format(eventName), function(cb, ...)
		cb(fn(...))
	end)
end)

exports("removeClientCallback", function(eventHandler)
	RemoveEventHandler(eventHandler)
end)
