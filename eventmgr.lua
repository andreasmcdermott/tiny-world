eventmgr = {}
eventmgr.events = {}

function eventmgr:push(e, o)
	table.insert(self.events, {e = e, o = o or {}})
end

function eventmgr:poll()
	local i = 0
	local n = table.getn(self.events)

	return function ()
		i = i + 1
		if i <= n then return self.events[i].e, self.events[i].o end
	end
end

function eventmgr:clear()
	self.events = {}
end