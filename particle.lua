particle = {}

function particle:handle(dt)
	local particles = entitymgr:getEntitiesByComponent(cParticle.name)

	for i, v in ipairs(particles) do
		local part = entitymgr:getComponent(v.uid, cParticle.name)
		local pos = entitymgr:getComponent(v.uid, cPos.name)
		part.particleSystem:update(dt)

		if part.particleSystem:isEmpty() then
			entitymgr:remove(v.uid)
		end
	end
end