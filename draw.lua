draw = {}

function draw:handle() 
	-- Sprites -------------------------------------------------------------
	local drawables = entitymgr:getEntitiesByComponent(cDraw.name)

	local b = {}
	local batches = {}

	love.graphics.setColor(255, 255 ,255)

	for i, v in ipairs(drawables) do
		local pos = entitymgr:getComponent(v.uid, cPos.name)
		local drw = entitymgr:getComponent(v.uid, cDraw.name)

		if pos ~= nil and drw ~= nil then
			local f = drw.file

			if b[f] == nil then 
				table.insert(batches, { file = f })
				b[f] = table.getn(batches)
			end

			table.insert(batches[b[f]], { quad = drw.quad, pos = pos })
		end
	end

	for i, v in ipairs(batches) do
		local batch = factory:getBatch(v.file)
		batch:clear()

		for i2, v2 in ipairs(v) do
			batch:addq(v2.quad, v2.pos.x, v2.pos.y, v2.pos.rot)
		end

		love.graphics.draw(batch)
	end

	-- Particles------------------------------------------------------------
	drawables = entitymgr:getEntitiesByComponent(cParticle.name)

	for i, v in ipairs(drawables) do
		local pos = entitymgr:getComponent(v.uid, cPos.name)
		local part = entitymgr:getComponent(v.uid, cParticle.name)

		if pos ~= nil and part ~= nil then
			local colorMode = love.graphics.getColorMode()
			local blendMode = love.graphics.getBlendMode()

			if part.pType == "explosion" or part.pType == "fire" or part.pType == "bullet" then
				love.graphics.setColorMode("modulate")
				love.graphics.setBlendMode("multiplicative")
			elseif part.pType == "blood" or part.pType == "bigblood" then
				love.graphics.setColorMode("modulate")
			elseif part.pType == "cloud" then
				love.graphics.setColorMode("modulate")
				love.graphics.setBlendMode("additive")
			else
				love.graphics.setColorMode("modulate")
				love.graphics.setBlendMode("subtractive")
			end

			love.graphics.draw(part.particleSystem, pos.x, pos.y)
			
			love.graphics.setColorMode(colorMode)
			love.graphics.setBlendMode(blendMode)
		end
	end

	-- Shapes --------------------------------------------------------------
	drawables = entitymgr:getEntitiesByComponent(cDrawShape.name)

	for i, v in ipairs(drawables) do
		local pos = entitymgr:getComponent(v.uid, cPos.name)
		local drw = entitymgr:getComponent(v.uid, cDrawShape.name)

		if pos ~= nil and drw ~= nil then
			local r,g,b = love.graphics.getColor()
			love.graphics.setColor(drw.color.r, drw.color.g, drw.color.b)

			if drw.shape == "circle" then
				love.graphics.circle("line", pos.x, pos.y, drw.r)
			elseif drw.shape == "fillcircle" then
				love.graphics.circle("fill", pos.x, pos.y, drw.r)
			end
			
			love.graphics.setColor(r,g,b)
		end
	end
end