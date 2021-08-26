exports.callbacks:registerClientCallback("echo", function(...)
	return ...
end)

exports.callbacks:registerClientCallback("getCoords", function()
	return GetEntityCoords(PlayerPedId())
end)

exports.callbacks:registerClientCallback("getIngameTime", function()
	return ("%d:%d:%d"):format(GetClockHours(), GetClockMinutes(), GetClockSeconds())
end)

RegisterCommand("cl_callbacks_test", function()
	for i = 1, 10 do
		if i == exports.callbacks:awaitServerCallback("echo", i) then
			print("awaitServerCallback", i, "passed")
		else
			print("awaitServerCallback", i, "failed")
		end
	end

	for i = 1, 3 do
		exports.callbacks:triggerServerCallback("getPlayers", function(players)
			print("triggerServerCallback", i, json.encode(players))
		end)
	end

	for i = 1, 3 do
		exports.callbacks:deferServerCallback("getIdentifiers"):next(function(values)
			print("deferServerCallback", i, json.encode(values[1]))
		end)
	end
end, false)
