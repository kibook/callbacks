RegisterNetEvent("callbacks:triggerCallback", function(eventName, ticket, ...)
	local p = promise.new()

	TriggerEvent(("callbacks:startCallback:%s"):format(eventName), function(...)
		p:resolve({...})
	end, ...)

	local result = Citizen.Await(p)
	TriggerServerEvent(("callbacks:endCallback:%s:%s"):format(eventName, ticket), table.unpack(result))
end)

exports("triggerServerCallback", function(eventName, ...)
	local p = promise.new()
	local ticket = GetGameTimer()

	local e = RegisterNetEvent(("callbacks:endCallback:%s:%s"):format(eventName, ticket), function(...)
		p:resolve({...})
	end)

	TriggerServerEvent("callbacks:triggerCallback", eventName, ticket, ...)

	local result = Citizen.Await(p)
	RemoveEventHandler(e)
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
