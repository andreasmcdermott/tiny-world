weapon = {}

function weapon:handle(dt)
	-- Update weapon position
	local weapons = entitymgr:getEntitiesByComponent(cWeapon.name)

	for i, v in ipairs(weapons) do
		local pos = entitymgr:getComponent(v.uid, cPos.name)
		local wpn = entitymgr:getComponent(v.uid, cWeapon.name)
		local prt = entitymgr:getComponent(v.uid, cParticle.name)

		pos.y = pos.y + wpn.dir.y * wpn.speed * dt
		pos.x = pos.x + wpn.dir.x * wpn.speed * dt

		if pos.x < -32 or pos.x > size.x + 32 or pos.y < -32 or pos.y > size.y + 32 then
			entitymgr:remove(v.uid)
		end

		local remove = false
		local collWith = ""
		-- Check collission with ground
		if pos.y + wpn.offsetY + wpn.r > size.y - 32 then
			collWith = "ground"
			if wpn.wType == "bomb" then
				remove = true
				weapon:damageHealth(pos.x + wpn.offsetX, pos.y + wpn.offsetY, wpn)
			elseif wpn.wType == "bullet" then
				remove = true
			elseif wpn.wType == "shotgun" then
				remove = true
			end
		else
			-- Perform collission detection
			local health = entitymgr:getEntitiesByComponent(cHealth.name)
			for ih, vh in ipairs(health) do
				local balloon = entitymgr:getComponent(vh.uid, cBalloon.name)
				local tower = entitymgr:getComponent(vh.uid, cTower.name)
				if v.uid ~= vh.uid and ((not balloon and control.selected == "balloon") or (not tower and control.selected == "tower")) then
					local posH = entitymgr:getComponent(vh.uid, cPos.name)
					local h = entitymgr:getComponent(vh.uid, cHealth.name)
					local l = self.getLen((pos.x + wpn.offsetX) - (posH.x + h.offsetX), (pos.y + wpn.offsetY) - (posH.y + h.offsetY))

					if l < wpn.r + h.r then
						remove = true
						if entitymgr:getComponent(vh.uid, cEnemy.name) then collWith = "enemy"
						else collWith = "misc" end
						if wpn.wType ~= "bomb" then weapon:damageSpecific(h, posH, wpn.damage, wpn.parent)
						else weapon:damageHealth(pos.x + wpn.offsetX, pos.y + wpn.offsetY, wpn) end
					end
				end
			end
		end

		if remove == true then 
			entitymgr:remove(v.uid) 

			if wpn.wType == "bomb" then
				entitymgr:addEntity(entitymgr:createEntity{
					[cPos.name] = cPos.new(pos.x + wpn.offsetX, pos.y + wpn.offsetY + wpn.r),
					[cParticle.name] = cParticle.new("res/particle.png", "explosion", 0.3)
				})
				entitymgr:addEntity(entitymgr:createEntity{
					[cSound.name] = cSound.new("res/explosion.wav"),
				})
			elseif wpn.wType == "bullet" or wpn.wType == "shotgun" then
				if collWith == "enemy" then
					entitymgr:addEntity(entitymgr:createEntity{
						[cPos.name] = cPos.new(pos.x + wpn.offsetX, pos.y + wpn.offsetY + wpn.r),
						[cParticle.name] = cParticle.new("res/particle.png", "blood", 0.3)
					})
					entitymgr:addEntity(entitymgr:createEntity{
						[cSound.name] = cSound.new("res/enemyhit.wav"),
					})
				else
					entitymgr:addEntity(entitymgr:createEntity{
						[cPos.name] = cPos.new(pos.x + wpn.offsetX, pos.y + wpn.offsetY + wpn.r),
						[cParticle.name] = cParticle.new("res/particle.png", "bullet", 0.3)
					})
				end
			end
		end
	end
end

function weapon:damageHealth(x, y, wpn)
	local health = entitymgr:getEntitiesByComponent(cHealth.name)
	for i, v in ipairs(health) do
		local posH = entitymgr:getComponent(v.uid, cPos.name)
		local h = entitymgr:getComponent(v.uid, cHealth.name)
		local l = self.getLen(x - (posH.x + h.offsetX), y - (posH.y + h.offsetY))

		if l < wpn.maxDamageLen then
			if wpn.wType ~= "bomb" then weapon:damageSpecific(h, posH, wpn.damage, wpn.parent)
			else weapon:damageSpecific(h, posH, wpn.damage * (wpn.maxDamageLen - l) / wpn.maxDamageLen, wpn.parent) end
		end
	end
end

function weapon:damageSpecific(h, pos, damage, parent)
	h.hp = h.hp - damage

	entitymgr:addEntity(entitymgr:createEntity{
		[cPos.name] = cPos.new(pos.x + math.random(50) - 25,pos.y - 10),
		[cText.name] = cText.new(font, "-" .. math.floor(damage), "center", 50, {r=255,g=0,b=0}),
		[cMove.name] = cMove.new({x = 0, y = -1}, 30),
		[cTimeout.name] = cTimeout.new(1)
	})

	if h.hp <= 0 then
		if parent then 
			local ent = entitymgr:getComponent(parent.uid, cBalloon.name)
			if not ent then 
				ent = entitymgr:getComponent(parent.uid, cTower.name) 
				cTower.addKill(ent)
			else
				cBalloon.addKill(ent)
			end
		end
	end
end

function weapon.getLen(x, y)
	return math.sqrt(x * x + y * y)
end