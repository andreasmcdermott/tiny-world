bkgd = {}

function bkgd:handle(dt)
	local bkgds = entitymgr:getEntitiesByComponent(cBkgd.name)

	for i, v in ipairs(bkgds) do
		local pos = entitymgr:getComponent(v.uid, cPos.name)
		local drw = entitymgr:getComponent(v.uid, cDraw.name)
		local bkgd = entitymgr:getComponent(v.uid, cBkgd.name)

		if bkgd ~= nil and drw ~= nil and pos ~= nil then
			pos.x = pos.x - dt * bkgd.speed

			if pos.x < -bkgd.sizeX then
				bkgd.tileType = math.random(1, bkgd.tileTypes)
				pos.x = pos.x + (size.x + bkgd.sizeX)
			end

			local img = factory:getImage(drw.file)
			drw.quad = love.graphics.newQuad(bkgd.tileType * bkgd.sizeX - bkgd.sizeX, 0, bkgd.sizeX, bkgd.sizeY, img:getWidth(), img:getHeight())
		end
	end
end