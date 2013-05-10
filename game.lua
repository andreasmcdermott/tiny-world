local game = { name = "game" }

function game:init()
	self.entities = {}

	for i = 1, (size.x + 64) / 32 do
		table.insert(self.entities, entitymgr:createEntity{
			[cPos.name] = cPos.new(i * 32 - 32, size.y - 32),
			[cDraw.name] = cDraw.new("res/ground.png"),
			[cBkgd.name] = cBkgd.new(8, 32, 32, 16)
		})
	end

	for i = 1, 8 do
		table.insert(self.entities, entitymgr:createEntity{
			[cPos.name] = cPos.new(math.random(size.x), math.random(32, size.y / 2 - 32)),
			[cDraw.name] = cDraw.new("res/cloud.png"),
			[cBkgd.name] = cBkgd.new(4, 32, 32, math.random(15, 45))
		})
	end

	for i = 1, 6 do
		table.insert(self.entities, entitymgr:createEntity{
			[cPos.name] = cPos.new(math.random(size.x), size.y - 64),
			[cDraw.name] = cDraw.new("res/bkgditems.png"),
			[cBkgd.name] = cBkgd.new(4, 32, 32, 16)
		})
	end

	table.insert(self.entities, entitymgr:createEntity{
		[cPos.name] = cPos.new(size.x - 64, size.y - 64),
		[cDraw.name] = cDraw.new("res/turtle.png"),
		[cAnim.name] = cAnim.new(8, 8),
		[cHealth.name] = cHealth.new(250, 8),
		[cTurtle.name] = cTurtle.new()
	})

	table.insert(self.entities, entitymgr:createEntity{
		[cPos.name] = cPos.new(size.x - 110, size.y - 64),
		[cDraw.name] = cDraw.new("res/cart.png", 0, 0, 64, 32),
		[cAnim.name] = cAnim.new(4, 4),
		[cControl.name] = cControl.new(),
		[cTower.name] = cTower.new(),
		[cHealth.name] = cHealth.new(1000, 16)
	})

	table.insert(self.entities, entitymgr:createEntity{
		[cPos.name] = cPos.new(size.x - 76, size.y - 50),
		[cParticle.name] = cParticle.new("res/particle.png", "smoke", -1),
	})

	table.insert(self.entities, entitymgr:createEntity{
		[cPos.name] = cPos.new(size.x - 82, size.y - 52),
		[cParticle.name] = cParticle.new("res/particle.png", "smoke", -1),
	})

	table.insert(self.entities, entitymgr:createEntity{
		[cPos.name] = cPos.new(size.x / 2 - 16, 128),
		[cDraw.name] = cDraw.new("res/balloon.png", 0, 0, 32, 32),
		[cBalloon.name] = cBalloon.new(),
		[cControl.name] = cControl.new(),
		[cHealth.name] = cHealth.new(100, 16)
	})

	table.insert(self.entities, entitymgr:createEntity{
		[cPos.name] = cPos.new(size.x / 2, 128),
		[cDraw.name] = cDraw.new("res/aim.png", 0, 0, 32, 32),
		[cControl.name] = cControl.new(),
		[cAim.name] = cAim.new()
	})
end

function game:onActivate()
	entitymgr:addEntities(self.entities)
	self.eventId = input:addKeyListener(function (key, down)
		if down then return end
		if key == "escape" then
			eventmgr:push("changeScene", {goto="menu"})
		elseif key == " " and table.getn(entitymgr:getEntitiesByComponent(cControl.name)) == 0 then
			restart()
		elseif key == "p" then
			eventmgr:push("print", {})
		end
	end, self.eventId)
end

function game:onDeactivate()
	self.entities = entitymgr:removeAll()
	input:removeKeyListener(self.eventId)
end

return game