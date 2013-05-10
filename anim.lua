anim = {}

function anim:handle(dt)
	local anims = entitymgr:getEntitiesByComponent(cAnim.name)

	-- images
	for i, v in ipairs(anims) do
		local drw = entitymgr:getComponent(v.uid, cDraw.name)
		local ani = entitymgr:getComponent(v.uid, cAnim.name)

		if drw ~= nil and ani ~= nil then
			ani.time = ani.time + dt

			if ani.time > (1 / ani.fps) then
				ani.currFrame = ani.currFrame + 1
				if ani.currFrame > ani.frames then
					if ani.loop == true then ani.currFrame = 1
					else 
						if ani.remove then entitymgr:remove(v.uid) end
						ani.currFrame = ani.frames 
					end
				end
				ani.time = 0

				local img = factory:getImage(drw.file)
				local w = img:getWidth() / ani.frames
				drw.quad = love.graphics.newQuad(w * ani.currFrame - w, 0, drw.w, drw.h, img:getWidth(), img:getHeight())
			end
		end
	end

	-- shapes
	local anims = entitymgr:getEntitiesByComponent(cDrawShape.name)

	for i, v in ipairs(anims) do
		local drw = entitymgr:getComponent(v.uid, cDrawShape.name)

		if drw ~= nil then
			drw.elapsed = drw.elapsed + dt

			if drw.shape == "circle" and drw.e.r ~= drw.s.r then
				drw.r = drw.s.r + (drw.e.r - drw.s.r) * (drw.elapsed / drw.time)

				if drw.r > drw.e.r then
					entitymgr:remove(v.uid)
				end
			end
		end
	end
end