local callbackResolutions = {}

local function getKey(eventName, ticket)
	return ("%s:%s"):format(eventName, ticket)
end

function addCallbackResolution(eventName, ticket, fn)
	callbackResolutions[getKey(eventName, ticket)] = fn
end

function removeCallbackResolution(eventName, ticket)
	callbackResolutions[getKey(eventName, ticket)] = nil
end

function getCallbackResolution(eventName, ticket)
	return callbackResolutions[getKey(eventName, ticket)]
end

function generateTicket()
	return ("%s:%s"):format(GetGameTimer(), math.random(0, 2^32))
end
