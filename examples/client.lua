exports.callbacks:registerClientCallback("getSpeed", function()
	return GetEntitySpeed(PlayerPedId())
end)

RegisterCommand("playercount", function(source, args, raw)
	local count = exports.callbacks:awaitServerCallback("getPlayerCount")
	TriggerEvent("chat:addMessage", {args = {"Player count: " .. count}})
end, false)
