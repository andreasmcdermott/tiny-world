input = {}
input.keyCallbacks = {}
input.mouseCallbacks = {}

local nextEventId = 1

function input:addKeyListener(func, id)
	if id == nil or id <= 0 then
		id = nextEventId
		nextEventId = nextEventId + 1
	end
	
	self.keyCallbacks[id] = func

	return id
end

function input:removeKeyListener(id)
	self.keyCallbacks[id] = nil
end

function input:addMouseListener(func, id)
	if id == nil or id <= 0 then
		id = nextEventId
		nextEventId = nextEventId + 1
	end

	self.mouseCallbacks[id] = func

	return id
end

function input:removeMouseListener(id)
	self.mouseCallbacks[id] = nil
end

function love.mousepressed(x, y, btn)
	for i = 1, nextEventId - 1 do
		if input.mouseCallbacks[i] ~= nil then
			input.mouseCallbacks[i](x, y, btn, true)
		end
	end
end

function love.mousereleased(x, y, btn)
	for i = 1, nextEventId - 1 do
		if input.mouseCallbacks[i] ~= nil then
			input.mouseCallbacks[i](x, y, btn, false)
		end
	end
end

function love.keypressed(key, unicode)
	for i = 1, nextEventId - 1 do
		if input.keyCallbacks[i] ~= nil then
			input.keyCallbacks[i](key, true)
		end
	end
end

function love.keyreleased(key, unicode)
	for i = 1, nextEventId - 1 do
		if input.keyCallbacks[i] ~= nil then
			input.keyCallbacks[i](key, false)
		end
	end
end