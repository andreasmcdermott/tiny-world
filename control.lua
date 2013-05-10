control = {}
control.selected = "balloon"

function control:handle(dt)
	if not self.keyEventId then	self.keyEventId = input:addKeyListener(control.onKeyEvent) end
	if not self.mouseEventId then self.mouseEventId = input:addMouseListener(control.onMouseEvent) end

	local controls = entitymgr:getEntitiesByComponent(cControl.name)

	for i, v in ipairs(controls) do
		local pos = entitymgr:getComponent(v.uid, cPos.name)
		local ctrl = entitymgr:getComponent(v.uid, cControl.name)
		local balloon = entitymgr:getComponent(v.uid, cBalloon.name)
		local tower = entitymgr:getComponent(v.uid, cTower.name)
		local aim = entitymgr:getComponent(v.uid, cAim.name)
		local h = entitymgr:getComponent(v.uid, cHealth.name)

		if balloon and self.selected == "balloon" then
			local x = 0
			local y = 0

			if love.keyboard.isDown("w") then y = -1 end
			if love.keyboard.isDown("s") then y = 1 end
			if love.keyboard.isDown("a") then x = -1 end
			if love.keyboard.isDown("d") then x = 1 end

			pos.x = pos.x + x * dt * 100
			pos.y = pos.y + y * dt * 100

			if love.mouse.isDown("l") then
				if balloon.bulletCount > 0 and balloon.bulletRecharge <= 0 and balloon.lastShot <= 0 then
					local aimPos = entitymgr:getComponent(entitymgr:getEntitiesByComponent(cAim.name)[1].uid, cPos.name)
					local xDir = (aimPos.x + 16) - (pos.x + 16)
					local yDir = (aimPos.y + 16) - (pos.y + 32)
					local l = weapon.getLen(xDir, yDir)
					xDir = xDir / l
					yDir = yDir / l

					entitymgr:addEntity(entitymgr:createEntity{
						[cPos.name] = cPos.new((pos.x + 16), pos.y + 32),
						[cDrawShape.name] = cDrawShape.new("fillcircle", {r=1},{r=1},0,{r=0,g=0,b=0}),
						[cWeapon.name] = cWeapon.new("bullet", {x = xDir, y = yDir}, v, balloon.extraDamage)
					})

					entitymgr:addEntity(entitymgr:createEntity{
						[cSound.name] = cSound.new("res/bullet.wav"),
					})

					balloon.lastShot = balloon.delay

					balloon.bulletCount = balloon.bulletCount - 1
					if balloon.bulletCount <= 0 then
						balloon.bulletRecharge = balloon.rechargeTime
					end
				elseif balloon.bulletRecharge > 0 and balloon.lastShot <= 0 then
					entitymgr:addEntity(entitymgr:createEntity{
						[cSound.name] = cSound.new("res/empty.wav"),
					})
					balloon.lastShot = balloon.delay
				end
			end
		elseif tower and self.selected == "tower" then
			if love.mouse.isDown("l") then
				if tower.bulletCount > 0 and tower.bulletRecharge <= 0 and tower.lastShot <= 0 then
					local aimPos = entitymgr:getComponent(entitymgr:getEntitiesByComponent(cAim.name)[1].uid, cPos.name)
					local xDir = (aimPos.x + 16) - (pos.x + 10)
					local yDir = (aimPos.y + 16) - (pos.y + 10)
					local l = weapon.getLen(xDir, yDir)
					xDir = xDir / l
					yDir = yDir / l

					entitymgr:addEntity(entitymgr:createEntity{
						[cPos.name] = cPos.new((pos.x + 10), pos.y + 10),
						[cDrawShape.name] = cDrawShape.new("fillcircle", {r=1},{r=1},0,{r=0,g=0,b=0}),
						[cWeapon.name] = cWeapon.new("bullet", {x = xDir, y = yDir}, v, tower.extraDamage)
					})

					entitymgr:addEntity(entitymgr:createEntity{
						[cSound.name] = cSound.new("res/bullet.wav"),
					})

					tower.lastShot = tower.delay

					tower.bulletCount = tower.bulletCount - 1
					if tower.bulletCount <= 0 then
						tower.bulletRecharge = tower.rechargeTime
					end
				elseif tower.bulletRecharge > 0 and tower.lastShot <= 0 then
					entitymgr:addEntity(entitymgr:createEntity{
						[cSound.name] = cSound.new("res/empty.wav"),
					})
					tower.lastShot = tower.delay
				end
			end
			if love.mouse.isDown("r") then
				if tower.shotgunCount > 0 and tower.shotgunRecharge <= 0 and tower.lastShotShotgun <= 0 then
					local aimPos = entitymgr:getComponent(entitymgr:getEntitiesByComponent(cAim.name)[1].uid, cPos.name)
					local xDir = (aimPos.x + 16) - (pos.x + 10)
					local yDir = (aimPos.y + 16) - (pos.y + 10)
					local l = weapon.getLen(xDir, yDir)
					xDir = xDir / l
					yDir = yDir / l
					tower.lastShotShotgun = tower.shotgunDelay
					tower.shotgunCount = tower.shotgunCount - 1
					if tower.shotgunCount <= 0 then
						tower.shotgunRecharge = tower.rechargeTimeShotgun
					end
					entitymgr:addEntity(entitymgr:createEntity{
						[cPos.name] = cPos.new((pos.x + 10), pos.y + 10),
						[cDrawShape.name] = cDrawShape.new("fillcircle", {r=2},{r=2},0,{r=0,g=0,b=0}),
						[cWeapon.name] = cWeapon.new("shotgun", {x = xDir, y = yDir}, v, tower.extraDamage)
					})

					entitymgr:addEntity(entitymgr:createEntity{
						[cSound.name] = cSound.new("res/cannon.wav"),
					})
				elseif tower.shotgunCount <= 0 and tower.shotgunRecharge <= 0 then
					entitymgr:addEntity(entitymgr:createEntity{
						[cSound.name] = cSound.new("res/empty.wav"),
					})
					tower.lastShotShotgun = tower.shotgunDelay
				end
			end
		elseif aim then
			local x = love.mouse.getX()
			local y = love.mouse.getY()

			pos.x = x - 16
			pos.y = y - 16

			if love.mouse.isDown("l", "r") and aim.down == false then
				aim.down = true
				local drw = entitymgr:getComponent(v.uid, cDraw.name)
				local img = factory:getImage(drw.file)
				drw.quad = love.graphics.newQuad(32, 0, drw.w, drw.h, img:getWidth(), img:getHeight())
			elseif not love.mouse.isDown("l", "r") and aim.down == true then
				aim.down = false
				local drw = entitymgr:getComponent(v.uid, cDraw.name)
				local img = factory:getImage(drw.file)
				drw.quad = love.graphics.newQuad(0, 0, drw.w, drw.h, img:getWidth(), img:getHeight())
			end
		end

		if tower then
			tower.lastShot = tower.lastShot - dt
			if tower.bulletRecharge > 0 then 
				tower.bulletRecharge = tower.bulletRecharge - dt 
				if tower.bulletRecharge <= 0 then
					tower.bulletCount = tower.maxBullets
				end
			end
			tower.lastShotShotgun = tower.lastShotShotgun - dt
			if tower.shotgunRecharge > 0 then 
				tower.shotgunRecharge = tower.shotgunRecharge - dt 
				if tower.shotgunRecharge <= 0 then
					tower.shotgunCount = tower.maxShotgunBullets
				end
			end

			if tower.kills > tower.nextLevel then
				tower.maxBullets = tower.maxBullets + 10
				tower.bulletCount = tower.maxBullets
				tower.bulletRecharge = 0
				tower.delay = tower.delay - 0.01
				if tower.delay < 0.1 then tower.delay = 0.1 end
				tower.rechargeTime = tower.rechargeTime - 0.01
				if tower.rechargeTime < 1 then tower.rechargeTime = 1 end

				tower.maxShotgunBullets = tower.maxShotgunBullets + 5
				tower.shotgunCount = tower.maxShotgunBullets
				tower.shotgunRecharge = 0
				tower.shotgunDelay = tower.shotgunDelay - 0.01
				if tower.shotgunDelay < 0.2 then tower.shotgunDelay = 0.2 end
				tower.rechargeTimeShotgun = tower.rechargeTimeShotgun - 0.01
				if tower.rechargeTimeShotgun < 1.5 then tower.rechargeTimeShotgun = 1.5 end

				tower.kills = 0
				tower.extraDamage = tower.extraDamage + 0.5
				entitymgr:addEntity(entitymgr:createEntity{
					[cSound.name] = cSound.new("res/levelup.wav"),
				})
				entitymgr:addEntity(entitymgr:createEntity{
					[cPos.name] = cPos.new(pos.x - 100, pos.y - 10),
					[cText.name] = cText.new(font, "Level up!", "center", 200),
					[cMove.name] = cMove.new({x = 0, y = -1}, 30),
					[cTimeout.name] = cTimeout.new(2)
				})
				tower.nextLevel = tower.nextLevel + 5
			end
			towerStr = "Tower\nBullets: " .. tower.bulletCount .. "\nCannon: " .. tower.shotgunCount
		end
		if balloon then
			balloon.lastShot = balloon.lastShot - dt
			if balloon.bombRecharge > 0 then balloon.bombRecharge = balloon.bombRecharge - dt end
			if balloon.bulletRecharge > 0 then 
				balloon.bulletRecharge = balloon.bulletRecharge - dt 
				if balloon.bulletRecharge <= 0 then
					balloon.bulletCount = balloon.maxBullets
				end
			end

			if balloon.kills > balloon.nextLevel then
				balloon.maxBullets = balloon.maxBullets + 10
				balloon.bulletCount = balloon.maxBullets
				balloon.bulletRecharge = 0
				balloon.extraDamage = balloon.extraDamage + 0.5
				balloon.delay = balloon.delay - 0.01
				if balloon.delay < 0.15 then balloon.delay = 0.15 end
				balloon.rechargeTime = balloon.rechargeTime - 0.01
				if balloon.rechargeTime < 1 then balloon.rechargeTime = 1 end
				balloon.bombCount = balloon.bombCount + 4 + balloon.maxBullets / 10
				balloon.kills = 0
				entitymgr:addEntity(entitymgr:createEntity{
					[cSound.name] = cSound.new("res/levelup.wav"),
				})
				entitymgr:addEntity(entitymgr:createEntity{
					[cPos.name] = cPos.new(pos.x - 100, pos.y - 10),
					[cText.name] = cText.new(font, "Level up!", "center", 200),
					[cMove.name] = cMove.new({x = 0, y = -1}, 30),
					[cTimeout.name] = cTimeout.new(2)
				})
				balloon.nextLevel = balloon.nextLevel + 5
			end
			balloonStr = "Balloon\nBullets: " .. balloon.bulletCount .. "\nRockets: " .. balloon.bombCount
		end
	end
end

function control.onKeyEvent(key, down)
	if isGameover then return end
	if key == "f" and not down and control.selected ~= "balloon" then
		control.selected = "balloon"
		local e = entitymgr:getEntitiesByComponent(cBalloon.name)[1]
		local ePos = entitymgr:getComponent(e.uid, cPos.name)
		entitymgr:addEntity(entitymgr:createEntity{
			[cPos.name]	= cPos.new(ePos.x + 16, ePos.y + 16),
			[cDrawShape.name] = cDrawShape.new("circle", { r = 0 }, { r = 32 }, 0.25, {r=255, g=0, b=0}),
		})
	elseif key == "f" and not down and control.selected ~= "tower" then
		control.selected = "tower"
		local e = entitymgr:getEntitiesByComponent(cTower.name)[1]
		local ePos = entitymgr:getComponent(e.uid, cPos.name)
		entitymgr:addEntity(entitymgr:createEntity{
			[cPos.name]	= cPos.new(ePos.x + 16, ePos.y + 16),
			[cDrawShape.name] = cDrawShape.new("circle", { r = 0 }, { r = 32 }, 0.25, {r=255, g=0, b=0}),
		})
	end
end

function control.onMouseEvent(x, y, button, down)
	if button == "r" and not down then
		if control.selected == "balloon" then
			local e = entitymgr:getEntitiesByComponent(cBalloon.name)[1]
			local ePos = entitymgr:getComponent(e.uid, cPos.name)
			local eBalloon = entitymgr:getComponent(e.uid, cBalloon.name)
			if eBalloon.bombRecharge <= 0 and eBalloon.bombCount > 0 then
				entitymgr:addEntity(entitymgr:createEntity{
					[cPos.name] = cPos.new(ePos.x, ePos.y + 16),
					[cDraw.name] = cDraw.new("res/bomb.png"),
					[cWeapon.name] = cWeapon.new("bomb", {x=0, y=1}, e, eBalloon.extraDamage),
					[cParticle.name] = cParticle.new("res/particle.png", "bomb", -1)
				})
				entitymgr:addEntity(entitymgr:createEntity{
					[cSound.name] = cSound.new("res/bomb.wav"),
				})
				eBalloon.bombRecharge = eBalloon.bombDelay
				eBalloon.bombCount = eBalloon.bombCount - 1
			elseif eBalloon.bombCount <= 0 and eBalloon.bombRecharge <= 0 then
				entitymgr:addEntity(entitymgr:createEntity{
					[cSound.name] = cSound.new("res/empty.wav"),
				})
				eBalloon.bombRecharge = eBalloon.bombDelay
			end
		end
	end
end