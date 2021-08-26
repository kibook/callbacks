exports.callbacks:registerServerCallback("echo", function(source, ...)
	return ...
end)

exports.callbacks:registerServerCallback("getPlayers", function(source, ...)
	return GetPlayers(), ...
end)

exports.callbacks:registerServerCallback("getIdentifiers", function(source, ...)
	return GetPlayerIdentifiers(source), ...
end)

RegisterCommand("callbacks_test", function(source)
	local target = source == 0 and GetPlayers()[1] or source

	for i = 1, 10 do
		local status = i == exports.callbacks:awaitClientCallback("echo", target, i) and "passed" or "failed"
		print("awaitClientCallback", i, status)
	end

	for i = 1, 10 do
		exports.callbacks:triggerClientCallback("getCoords", target, function(coords, n)
			local status = n == i and "passed" or "failed"
			print("triggerClientCallback", i, coords, status)
		end, i)
	end

	for i = 1, 10 do
		exports.callbacks:deferClientCallback("getIngameTime", target, i):next(function(values)
			local coords, n = table.unpack(values)
			local status = n == i and "passed" or "failed"
			print("newClientPromise", i, coords, status)
		end)
	end

	TriggerClientEvent("callbacks_test", target)
end, true)
