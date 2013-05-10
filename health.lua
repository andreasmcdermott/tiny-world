health = {}

function health:handle(dt)
	local health = entitymgr:getEntitiesByComponent(cHealth.name)

	for i, v in ipairs(health) do
		local h = entitymgr:getComponent(v.uid, cHealth.name)

		if h then
			local balloon = entitymgr:getComponent(v.uid, cBalloon.name)
			local tower = entitymgr:getComponent(v.uid, cTower.name)
			local turtle = entitymgr:getComponent(v.uid, cTurtle.name)
			if h.hp < 0 then
				local monster = entitymgr:getComponent(v.uid, cEnemy.name)
				local pos = entitymgr:getComponent(v.uid, cPos.name)

				if tower then -- City broken -> game over
					entitymgr:removeAllOfComponent(cParticle.name)
					entitymgr:addEntity(entitymgr:createEntity{
						[cPos.name] = cPos.new(pos.x + h.offsetX, pos.y + h.offsetY),
						[cParticle.name] = cParticle.new("res/particle.png", "fire", -1)
					})
					entitymgr:addEntity(entitymgr:createEntity{
						[cPos.name] = cPos.new(pos.x + h.offsetX + 20, pos.y + h.offsetY - 5),
						[cParticle.name] = cParticle.new("res/particle.png", "fire", -1)
					})
					gameover()
				elseif turtle then --Turtle dead -> game over
					gameover()
					entitymgr:removeComponent(v.uid, cDraw.name)
					entitymgr:addComponent(v.uid, cDraw.name, cDraw.new("res/turtleDying.png"))
					entitymgr:addComponent(v.uid, cAnim.name, cAnim.new(8, 8, false))
				elseif balloon then
					entitymgr:removeComponent(v.uid, cControl.name)
					entitymgr:addComponent(v.uid, cMove.name, cMove.new({x = 0, y = 1}, 100))
				elseif monster then
					enemy:die(v.uid)
				end
			end

			if balloon then
				balloonHpStr = "HP: " .. math.floor(h.hp)
			elseif tower then
				towerHpStr = "HP: " .. math.floor(h.hp)
			elseif turtle then
				turtleHpStr = "HP: " .. math.floor(h.hp)
			end
		end
	end
end