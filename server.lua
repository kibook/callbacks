RegisterNetEvent("callbacks:triggerCallback", function(eventName, ticket, ...)
	local source = source
	local p = promise.new()

	TriggerEvent(("callbacks:startCallback:%s"):format(eventName), function(...)
		p:resolve({...})
	end, source, ...)

	local result = Citizen.Await(p)
	TriggerClientEvent(("callbacks:endCallback:%s:%s"):format(eventName, ticket), source, table.unpack(result))
end)

exports("triggerClientCallback", function(eventName, src, ...)
	src = tonumber(src)

	local p = promise.new()
	local ticket = GetGameTimer()

	local e = RegisterNetEvent(("callbacks:endCallback:%s:%s"):format(eventName, ticket), function(...)
		if src == source then
			p:resolve({...})
		end
	end)

	TriggerClientEvent("callbacks:triggerCallback", src, eventName, ticket, ...)

	local result = Citizen.Await(p)
	RemoveEventHandler(e)
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
