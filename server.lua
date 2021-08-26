RegisterNetEvent("callbacks:triggerCallback", function(eventName, ticket, ...)
	local source = source
	local p = promise.new()

	TriggerEvent(("callbacks:startCallback:%s"):format(eventName), function(...)
		p:resolve{...}
	end, source, ...)

	local result = Citizen.Await(p)
	TriggerClientEvent("callbacks:endCallback", source, eventName, ticket, table.unpack(result))
end)

RegisterNetEvent("callbacks:endCallback", function(eventName, ticket, ...)
	local fn = getCallbackResolution(eventName, ticket)

	if fn then
		fn(source, ...)
	end
end)

exports("triggerClientCallback", function(eventName, src, cb, ...)
	src = tonumber(src)

	local ticket = generateTicket()

	addCallbackResolution(eventName, ticket, function(source, ...)
		if src == source then
			cb(...)
			removeCallbackResolution(eventName, ticket)
		end
	end)

	TriggerClientEvent("callbacks:triggerCallback", src, eventName, ticket, ...)
end)

local function deferClientCallback(eventName, src, ...)
	src = tonumber(src)

	local ticket = generateTicket()

	local p = promise.new()

	addCallbackResolution(eventName, ticket, function(source, ...)
		if src == source then
			p:resolve{...}
			removeCallbackResolution(eventName, ticket)
		end
	end)

	TriggerClientEvent("callbacks:triggerCallback", src, eventName, ticket, ...)

	return p
end

exports("deferClientCallback", deferClientCallback)

exports("awaitClientCallback", function(eventName, src, ...)
	local p = deferClientCallback(eventName, src, ...)
	local result = Citizen.Await(p)
	return table.unpack(result)
end)

exports("registerServerCallback", function(eventName, fn)
	return AddEventHandler(("callbacks:startCallback:%s"):format(eventName), function(cb, source, ...)
		local result = {fn(source, ...)}
		cb(table.unpack(result))
	end)
end)

exports("removeServerCallback", function(eventHandler)
	RemoveEventHandler(eventHandler)
end)
