exports.callbacks:registerServerCallback("getPlayerCount", function(source)
	return #GetPlayers()
end)

RegisterCommand("playerspeeds", function(source, args, raw)
	for _, player in ipairs(GetPlayers()) do
		local speed = exports.callbacks:awaitClientCallback("getSpeed", player)
		print(GetPlayerName(player) .. " is moving at " .. speed .. " m/s")
	end
end, true)
