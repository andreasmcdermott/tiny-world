enemy = {}

function enemy:init()
	enemy.timeSinceLast = 0
	enemy.killed = 0
	enemy.created = 0
	enemy.freq = 2
	enemy.nextLevel = 5
	enemy.level = 0
	enemy.bonus = false
end

function enemy:handle(dt)
	local enemies = entitymgr:getEntitiesByComponent(cEnemy.name)

	local balloon = entitymgr:getEntitiesByComponent(cBalloon.name)[1]
	local tower = entitymgr:getEntitiesByComponent(cTower.name)[1]
	local turtle = entitymgr:getEntitiesByComponent(cTurtle.name)[1]
	local player = {}
	table.insert(player, { e = balloon, p = entitymgr:getComponent(balloon.uid, cPos.name)})
	table.insert(player, { e = tower,   p = entitymgr:getComponent(tower.uid,   cPos.name)})
	table.insert(player, { e = turtle,  p = entitymgr:getComponent(turtle.uid,  cPos.name)})

	for i, v in ipairs(enemies) do
		local pos = entitymgr:getComponent(v.uid, cPos.name)
		local monster = entitymgr:getComponent(v.uid, cEnemy.name)
		local h = entitymgr:getComponent(v.uid, cHealth.name)

		if pos and monster and h then
			for i2, v2 in ipairs(player) do
				local pH = entitymgr:getComponent(v2.e.uid, cHealth.name)
				if pH then
					local l = weapon.getLen(pos.x - v2.p.x, pos.y - v2.p.y)
					if l < h.r and monster.delay <= 0 then
						pH.hp = pH.hp - (monster.damage + self.level * 1)

						if monster.eType == "zombie" then
							monster.delay = monster.resetDelay
							entitymgr:removeComponent(v.uid, cMove.name)
						elseif monster.eType == "monster" then
							monster.delay = monster.resetDelay
							entitymgr:removeComponent(v.uid, cMove.name)
						elseif monster.eType == "bird" then
							self:die(v.uid)
						end
						entitymgr:addEntity(entitymgr:createEntity{
							[cPos.name] = cPos.new(v2.p.x + math.random(50) - 25, v2.p.y - 10),
							[cText.name] = cText.new(font, "-" .. (monster.damage + self.level * 1), "center", 50, {r=255,g=0,b=0}),
							[cMove.name] = cMove.new({x = 0, y = -1}, 30),
							[cTimeout.name] = cTimeout.new(1)
						})
					end
				end
			end

			if monster.delay > 0 then monster.delay = monster.delay - dt end
		end
	end

	self.timeSinceLast = self.timeSinceLast + dt

	if self.timeSinceLast > self.freq and not isGameover then
		self.timeSinceLast = 0
		self.created = enemy.created + 1
		local newType = self:getEnemyType()
		if newType == "zombie" then
			entitymgr:addEntity(entitymgr:createEntity{
				[cPos.name] = cPos.new(-32, size.y - 64),
				[cEnemy.name] = cEnemy.new("zombie"),
				[cHealth.name] = cHealth.new(15 + self.level * 5, 16),
				[cDraw.name] = cDraw.new("res/zombie.png"),
				[cAnim.name] = cAnim.new(8, 8),
				[cMove.name] = cMove.new({x = 1, y = 0}, 30)
			})
		elseif newType == "bird" then
			local balloon = entitymgr:getEntitiesByComponent(cBalloon.name)[1]
			local bPos = entitymgr:getComponent(balloon.uid, cPos.name)
			entitymgr:addEntity(entitymgr:createEntity{
				[cPos.name] = cPos.new(size.x + 32, bPos.y + math.random(0, 64) - 32),
				[cEnemy.name] = cEnemy.new("bird"),
				[cHealth.name] = cHealth.new(15 + self.level * 5, 16),
				[cDraw.name] = cDraw.new("res/bird.png"),
				[cAnim.name] = cAnim.new(8, 8),
				[cMove.name] = cMove.new({x = -1, y = 0}, 100)
			})
		elseif newType == "monster" then
			entitymgr:addEntity(entitymgr:createEntity{
				[cPos.name] = cPos.new(-32, size.y - 64),
				[cEnemy.name] = cEnemy.new("monster"),
				[cHealth.name] = cHealth.new(35 + self.level * 5, 16),
				[cDraw.name] = cDraw.new("res/monster.png"),
				[cAnim.name] = cAnim.new(8, 12),
				[cMove.name] = cMove.new({x = 1, y = 0}, 100)
			})
		end
	elseif isGameover then
		self.timeSinceLast = 0
		self.killed = 0
		self.created = 0
		self.freq = 1
	end
end

function enemy:getEnemyType() 
	local rand = math.random(100)

	if (rand > 95 and self.level > 1) or (rand > 85 and self.level > 2) or (rand > 75 and self.level > 3) and not self.bonus then
		return "monster"
	elseif (rand > 65 and self.level > 0) or (rand > 55 and self.level > 1) or (rand > 45 and self.level > 2) and not self.bonus then
		if (rand > 98 and self.level > 0) or (rand > 93 and self.level > 1) or (rand > 88 and self.level > 2) then
			self.bonus = true
			self.timeSinceLast = self.freq
		end
		return "bird"
	else
		if self.bonus == true then self.bonus = false end
		return "zombie"
	end
end

function enemy:die(uid)
	self.killed = self.killed + 1
	kills = kills + 1
	local pos = entitymgr:getComponent(uid, cPos.name)
	local eType = entitymgr:getComponent(uid, cEnemy.name).eType

	entitymgr:removeComponent(uid, cDraw.name)
	entitymgr:removeComponent(uid, cAnim.name)
	entitymgr:removeComponent(uid, cEnemy.name)
	entitymgr:removeComponent(uid, cMove.name)
	entitymgr:removeComponent(uid, cHealth.name)
	entitymgr:addComponent(uid, cAnim.name, cAnim.new(8, 8, false, true))
	if eType == "zombie" then
		points = points + 10
		entitymgr:addComponent(uid, cDraw.name, cDraw.new("res/zombieDying.png"))
		entitymgr:addEntity(entitymgr:createEntity{
			[cPos.name] = cPos.new(pos.x - 25, pos.y - 10),
			[cText.name] = cText.new(font, "+10", "center", 50),
			[cMove.name] = cMove.new({x = 0, y = -1}, 30),
			[cTimeout.name] = cTimeout.new(1)
		})
	elseif eType == "bird" then
		points = points + 20
		entitymgr:addComponent(uid, cDraw.name, cDraw.new("res/birdDying.png"))
		entitymgr:addEntity(entitymgr:createEntity{
			[cPos.name] = cPos.new(pos.x - 25, pos.y - 10),
			[cText.name] = cText.new(font, "+20", "center", 50),
			[cMove.name] = cMove.new({x = 0, y = -1}, 30),
			[cTimeout.name] = cTimeout.new(1)
		})
	elseif eType == "monster" then
		points = points + 50
		entitymgr:addComponent(uid, cDraw.name, cDraw.new("res/monsterDying.png"))
		entitymgr:addEntity(entitymgr:createEntity{
			[cPos.name] = cPos.new(pos.x - 25, pos.y - 10),
			[cText.name] = cText.new(font, "+50", "center", 50),
			[cMove.name] = cMove.new({x = 0, y = -1}, 30),
			[cTimeout.name] = cTimeout.new(1)
		})
	end

	if self.killed >= self.nextLevel then
		self.killed = 0
		self.freq = self.freq - 0.05
		if self.freq < 0.1 then self.freq = 0.1 end
		self.nextLevel = self.nextLevel + 5
		self.level = self.level + 1

		entitymgr:addEntity(entitymgr:createEntity{
			[cPos.name] = cPos.new(size.x / 2 - 100, size.y / 2 - 8),
			[cText.name] = cText.new(font, "Next level!", "center", 200, {r=0,g=0,b=0}),
			[cMove.name] = cMove.new({x = 0, y = -1}, 30),
			[cTimeout.name] = cTimeout.new(2)
		})

		entitymgr:addEntity(entitymgr:createEntity{
			[cSound.name] = cSound.new("res/enemylevelup.wav")
		})
	end
end