position = {}

function position:handle(dt)
	local movable = entitymgr:getEntitiesByComponent(cMove.name)
	for i, v in ipairs(movable) do
		local pos = entitymgr:getComponent(v.uid, cPos.name)
		local move = entitymgr:getComponent(v.uid, cMove.name)

		if pos and move then
			pos.x = pos.x + move.dir.x * move.speed * dt
			pos.y = pos.y + move.dir.y * move.speed * dt
		end

		if pos.x < -64 or pos.x > size.x + 32 or pos.y < -32 or pos.y > size.y then 
			entitymgr:remove(v.uid)
		end
	end

	local balloon = entitymgr:getEntitiesByComponent(cBalloon.name)[1]
	local pos = entitymgr:getComponent(balloon.uid, cPos.name)
	local ctrl = entitymgr:getComponent(balloon.uid, cControl.name)

	if pos.x < 0 then pos.x = 0 end
	if pos.x > size.x - 32 then pos.x = size.x - 32 end
	if pos.y < 0 then pos.y = 0 end
	if pos.y > size.y - 64 then 
		pos.y = size.y - 64
		if not isGameover then
			gameover()
			entitymgr:addComponent(balloon.uid, cAnim.name, cAnim.new(8, 8, false))
		end
	end
end