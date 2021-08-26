local callbackHandlers = {}

function addCallbackHandler(callbackName, fn)
	callbackHandlers[callbackName] = fn
end

function removeCallbackHandler(callbackName)
	callbackHandlers[callbackName] = nil
end

function getCallbackHandler(callbackName)
	return callbackHandlers[callbackName]
end

local callbackResolutions = {}

local function getKey(callbackName, ticket)
	return ("%s:%s"):format(callbackName, ticket)
end

function addCallbackResolution(callbackName, ticket, fn)
	callbackResolutions[getKey(callbackName, ticket)] = fn
end

function removeCallbackResolution(callbackName, ticket)
	callbackResolutions[getKey(callbackName, ticket)] = nil
end

function getCallbackResolution(callbackName, ticket)
	return callbackResolutions[getKey(callbackName, ticket)]
end

function generateTicket()
	return ("%s:%s"):format(GetGameTimer(), math.random(0, 2^32))
end
