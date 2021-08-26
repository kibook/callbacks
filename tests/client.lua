exports.callbacks:registerClientCallback("echo", function(...)
	return ...
end)

exports.callbacks:registerClientCallback("getCoords", function(...)
	return GetEntityCoords(PlayerPedId()), ...
end)

exports.callbacks:registerClientCallback("getIngameTime", function(...)
	return ("%d:%d:%d"):format(GetClockHours(), GetClockMinutes(), GetClockSeconds()), ...
end)

RegisterNetEvent("callbacks_test", function()
	for i = 1, 10 do
		local status = i == exports.callbacks:awaitServerCallback("echo", i) and "passed" or "failed"
		print("awaitServerCallback", i, status)
	end

	for i = 1, 10 do
		exports.callbacks:triggerServerCallback("getPlayers", function(players, n)
			local status = n == i and "passed" or "failed"
			print("triggerServerCallback", i, json.encode(players), status)
		end, i)
	end

	for i = 1, 10 do
		exports.callbacks:deferServerCallback("getIdentifiers", i):next(function(values)
			local identifiers, n = table.unpack(values)
			local status = n == i and "passed" or "failed"
			print("deferServerCallback", i, json.encode(identifiers), status)
		end)
	end
end)
