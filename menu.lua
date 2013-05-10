local menu = { name = "menu" }

function menu:init()
	self.entities = {}

	table.insert(self.entities, entitymgr:createEntity{
		[cPos.name] = cPos.new(size.x - 128, 64),
		[cDraw.name] = cDraw.new("res/bird.png"),
		[cAnim.name] = cAnim.new(8, 8)
	})

	table.insert(self.entities, entitymgr:createEntity{
		[cPos.name] = cPos.new(128, size.y - 32),
		[cDraw.name] = cDraw.new("res/zombie.png"),
		[cAnim.name] = cAnim.new(8, 8)
	})

	table.insert(self.entities, entitymgr:createEntity{
		[cPos.name] = cPos.new(64,  96),
		[cDraw.name] = cDraw.new("res/balloon.png")
	})

	table.insert(self.entities, entitymgr:createEntity{
		[cPos.name] = cPos.new(0, size.y / 2 - 60),
		[cText.name] = cText.new(font, "Tiny World", "center", size.x, {r=255,g=255,b=255})
	})

	table.insert(self.entities, entitymgr:createEntity{
		[cPos.name] = cPos.new(0, size.y / 2 - 40),
		[cText.name] = cText.new(font, "Press escape to exit", "center", size.x, {r=255,g=255,b=255})
	})

	table.insert(self.entities, entitymgr:createEntity{
		[cPos.name] = cPos.new(0, size.y / 2 - 20),
		[cText.name] = cText.new(font, "Press spacebar to start", "center", size.x, {r=255,g=255,b=255})
	})

	table.insert(self.entities, entitymgr:createEntity{
		[cPos.name] = cPos.new(0, size.y / 2),
		[cText.name] = cText.new(font, "Game by Andreas Hedin", "center", size.x, {r=255,g=255,b=255})
	})

	table.insert(self.entities, entitymgr:createEntity{
		[cPos.name] = cPos.new(10, size.y - 146),
		[cText.name] = cText.new(font, "How to play:", "left", size.x, {r=255,g=255,b=255})
	})

	table.insert(self.entities, entitymgr:createEntity{
		[cPos.name] = cPos.new(10, size.y - 128),
		[cText.name] = cText.new(font, "F: Switch between tower and balloon", "left", size.x, {r=255,g=255,b=255})
	})

	table.insert(self.entities, entitymgr:createEntity{
		[cPos.name] = cPos.new(10, size.y - 110),
		[cText.name] = cText.new(font, "WASD: Control the balloon", "left", size.x, {r=255,g=255,b=255})
	})

	table.insert(self.entities, entitymgr:createEntity{
		[cPos.name] = cPos.new(10, size.y - 92),
		[cText.name] = cText.new(font, "LMB: Primary fire", "left", size.x, {r=255,g=255,b=255})
	})

	table.insert(self.entities, entitymgr:createEntity{
		[cPos.name] = cPos.new(10, size.y - 74),
		[cText.name] = cText.new(font, "RMB: Secondary fire", "left", size.x, {r=255,g=255,b=255})
	})
end

function menu:onActivate()
	entitymgr:addEntities(self.entities)
	self.eventId = input:addKeyListener(function (key, down)
		if down then return end
		if key == "escape" then
			love.event.push("quit")
		elseif key == " " then
			eventmgr:push("changeScene", { goto = "game" }) 
		end
	end, self.eventId)
end

function menu:onDeactivate()
	self.entities = entitymgr:removeAll()
	input:removeKeyListener(self.eventId)
end

return menu