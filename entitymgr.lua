require "components"
require "draw"
require "text"
require "anim"
require "bkgd"
require "control"
require "particle"
require "weapon"
require "health"
require "sound"
require "enemy"
require "position"
require "timeout"

entitymgr = {}
local nextEntity = 1
entitymgr.entities = {}

function entitymgr:createEntity(e)
	e = e or {}
	e.uid = nextEntity
	nextEntity = nextEntity + 1
	return e
end

function entitymgr:addEntity(e)
	e = e or {}
	if e.uid <= 0 then
		e.uid = nextEntity
		nextEntity = nextEntity + 1
	end

	self.entities[e.uid] = e

	return e
end

function entitymgr:addEntities(es)
	es = es or {}

	for i, v in ipairs(es) do
		self.entities[v.uid] = v
	end
end

function entitymgr:addComponent(uid, cName, cData)
	local e = self.entities[uid]

	if e ~= nil then
		e[cName] = cData
	end
end

function entitymgr:removeComponent(uid, cName)
	if self.entities[uid] ~= nil then
		self.entities[uid][cName] = nil
	end
end

function entitymgr:removeAllOfComponent(cName)
	for i = 1, nextEntity - 1 do
		if self.entities[i] ~= nil and self.entities[i][cName] ~= nil then
			self:removeComponent(self.entities[i].uid, cName)
		end
	end
end

function entitymgr:remove(uid)
	self.entities[uid] = nil
end

function entitymgr:removeAll()
	local es = {}
	for i = 1, nextEntity - 1 do
		if self.entities[i] then
			table.insert(es, self.entities[i])
		end
	end
	self.entities = {}
	return es
end

function entitymgr:getEntitiesByComponent(cName)
	local es = {}

	for i = 1, nextEntity - 1 do
		if self.entities[i] ~= nil and self.entities[i][cName] ~= nil then
			table.insert(es, self.entities[i])
		end
	end
	return es
end

function entitymgr:getComponent(uid, cName)
	local e = self.entities[uid]

	if e ~= nil then
		return e[cName]
	end
end

function entitymgr:print()
	local ids = {}
	local comps = {
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
		[5] = 0,
		[6] = 0,
		[7] = 0,
		[8] = 0,
		[9] = 0,
		[10] = 0,
		[11] = 0,
		[12] = 0,
		[13] = 0,
		[14] = 0,
		[15] = 0,
		[16] = 0,
		[17] = 0
	}
	for i = 1, nextEntity - 1 do
		if self.entities[i] then
			table.insert(ids, i)

			if self.entities[i][cPos.name] then comps[1] = comps[1] + 1 end
			if self.entities[i][cDraw.name] then comps[2] = comps[2] + 1 end
			if self.entities[i][cAnim.name] then comps[3] = comps[3] + 1 end
			if self.entities[i][cText.name] then comps[4] = comps[4] + 1 end
			if self.entities[i][cTurtle.name] then comps[5] = comps[5] + 1 end
			if self.entities[i][cTower.name] then comps[6] = comps[6] + 1 end
			if self.entities[i][cBalloon.name] then comps[7] = comps[7] + 1 end
			if self.entities[i][cControl.name] then comps[8] = comps[8] + 1 end
			if self.entities[i][cDrawShape.name] then comps[9] = comps[8] + 1 end
			if self.entities[i][cWeapon.name] then comps[10] = comps[10] + 1 end
			if self.entities[i][cBkgd.name] then comps[11] = comps[11] + 1 end
			if self.entities[i][cHealth.name] then comps[12] = comps[12] + 1 end
			if self.entities[i][cSound.name] then comps[13] = comps[13] + 1 end
			if self.entities[i][cEnemy.name] then comps[14] = comps[14] + 1 end
			if self.entities[i][cMove.name] then comps[15] = comps[15] + 1 end
			if self.entities[i][cTimeout.name] then comps[16] = comps[16] + 1 end
			if self.entities[i][cParticle.name] then comps[17] = comps[17] + 1 end
		end
	end

	for i,v in ipairs(comps) do
		print(i, v)
	end
	--print(unpack(ids))
	print("----------------------------------------------------")
end