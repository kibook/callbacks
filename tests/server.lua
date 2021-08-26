exports.callbacks:registerServerCallback("echo", function(source, ...)
	return ...
end)

exports.callbacks:registerServerCallback("getPlayers", function(source)
	return GetPlayers()
end)

exports.callbacks:registerServerCallback("getIdentifiers", function(source)
	return GetPlayerIdentifiers(source)
end)

RegisterCommand("sv_callbacks_test", function()
	local target = GetPlayers()[1]

	for i = 1, 10 do
		if i == exports.callbacks:awaitClientCallback("echo", target, i) then
			print("awaitClientCallback", i, "passed")
		else
			print("awaitClientCallback", i, "failed")
		end
	end

	for i = 1, 3 do
		exports.callbacks:triggerClientCallback("getCoords", target, function(coords)
			print("triggerClientCallback", i, coords)
		end)
	end

	for i = 1, 3 do
		exports.callbacks:deferClientCallback("getIngameTime", target):next(function(values)
			print("newClientPromise", i, values[1])
		end)
	end
end, true)
