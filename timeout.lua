timeout = {}

function timeout:handle(dt)
	local timeouts = entitymgr:getEntitiesByComponent(cTimeout.name)

	for i,v in ipairs(timeouts) do
		local t = entitymgr:getComponent(v.uid, cTimeout.name)

		if t then
			t.time = t.time - dt

			if t.time <= 0 then entitymgr:remove(v.uid) end
		end
	end
end