cPos = { name = "pos" }

function cPos.new(x, y, rot)
	local o = { x = x or 0, y = y or 0, rot = rot or 0 }
	return o
end

cDraw = { name = "draw" }

function cDraw.new(file, x, y, w, h)
	local o = { file = file or "", w = w or 32, h = h or 32 }
	local img = factory:getImage(o.file)
	o.quad = love.graphics.newQuad(x or 0, y or 0, w or 32, h or 32, img:getWidth(), img:getHeight())
	return o
end

cAnim = { name = "anim" }

function cAnim.new(frames, fps, loop, remove)
	if loop == nil then loop = true end
	local o = { frames = frames or 1, fps = fps or 1, currFrame = 1, time = 0, loop = loop, remove = remove or false }
	return o
end

cText = { name = "text" }

function cText.new(font, str, align, width, color)
	local o = { font = font, str = str or "", width = width or size.x, align = align or "left", color = color or {r=0,g=0,b=0} }
	return o
end

cTurtle = { name = "turtle" }

function cTurtle.new()
	local o = {}
	return o	
end

cTower = { name = "tower" }

function cTower.new()
	local o = {}
	o.bulletRecharge = 0
	o.bulletCount = 25
	o.maxBullets = 25
	o.rechargeTime = 3
	o.delay = 0.2
	o.lastShot = 0
	o.kills = 0
	o.nextLevel = 10
	o.extraDamage = 0

	o.shotgunRecharge = 0
	o.shotgunCount = 10
	o.maxShotgunBullets = 10
	o.rechargeTimeShotgun = 6
	o.shotgunDelay = 0.5
	o.lastShotShotgun = 0
	return o	
end

function cTower.addKill(o)
	o.kills = o.kills + 1
end

cBalloon = { name = "balloon" }

function cBalloon.new()
	local o = {}
	o.bombCount = 10
	o.bombRecharge = 0
	o.bulletRecharge = 0
	o.bulletCount = 10
	o.maxBullets = 10
	o.delay = 0.25
	o.lastShot = 0
	o.rechargeTime = 2
	o.bombDelay = 1
	o.kills = 0
	o.nextLevel = 10
	o.extraDamage = 0.5
	return o	
end

function cBalloon.addKill(o)
	o.kills = o.kills + 1
end

cAim = { name = "aim" }

function cAim.new()
	local o = {down = false}
	return o	
end

cControl = { name = "control" }

function cControl.new()
	local o = {}
	return o
end

cDrawShape = { name = "drawshape" }

function cDrawShape.new(shape, s, e, time, color)
	local o = {shape = shape, elapsed = 0, s = s, e = e, time = time, color = color, }
	if shape == "circle" or shape == "fillcircle" then
		o.r = s.r
	elseif shape == "line" then
		o.l = s.l
	end
	return o
end

cWeapon = { name = "weapon" }

function cWeapon.new(wType, dir, parent, extraDmg)
	local o = {wType = wType, dir = dir, parent = parent}
	if wType == "bomb" then
		o.r = 13
		o.offsetX = 16
		o.offsetY = 16
		o.damage = 200 + extraDmg * 2
		o.maxDamageLen = 64
		o.speed = 250
	elseif wType == "shotgun" then
		o.r = 1
		o.offsetX = 1
		o.offsetY = 1
		o.damage = 10 + extraDmg * 2
		o.maxDamageLen = 1
		o.speed = 200
	elseif wType == "bullet" then
		o.r = 1
		o.damage = 3 + extraDmg
		o.maxDamageLen = 2
		o.speed = 400
		o.offsetX = 1
		o.offsetY = 1
	end
	return o
end

cBkgd = { name = "bkgd" }

function cBkgd.new(tileTypes, sizeX, sizeY, speed)
	local o = { tileType = math.random(1, tileTypes), tileTypes = tileTypes or 1, sizeX = sizeX or 32, sizeY = sizeY or 32, speed = speed or 32 }
	return o	
end

cHealth = { name = "health" }

function cHealth.new(hp, r, ox, oy)
	local o = {hp = hp or 100, r = r or 16, offsetX = ox or 16, offsetY = oy or 16}
	return o
end

cSound = { name = "sound" }

function cSound.new(file)
	local o = {file = file}
	return o
end

cEnemy = { name = "enemy" }

function cEnemy.new(eType)
	local o = {eType = eType}
	if eType == "zombie" then
		o.damage = 1
		o.resetDelay = 0.25
		o.delay = 0
	elseif eType == "bird" then
		o.damage = 15
		o.resetDelay = 0.2
		o.delay = 0
	elseif eType == "monster" then
		o.damage = 10
		o.resetDelay = 0.3
		o.delay = 0
	end
	return o
end

cMove = { name = "move" }

function cMove.new(dir, speed)
	local o = {dir = dir, speed = speed}
	return o
end

cTimeout = { name = "timeout"}

function cTimeout.new(time)
	local o = {time = time}
	return o
end

cParticle = { name = "particle" }

function cParticle.new(file, pType, lifetime)
	local o = {file = file, pType = pType, lifetime = lifetime}
	o.particleSystem = love.graphics.newParticleSystem(factory:getImage(file), 256)
	o.particleSystem:setSpread(0.2)
	o.particleSystem:setSpeed(5, 25)
	o.particleSystem:setColors(0, 0, 0, 128, 50, 50, 50, 64)
	o.particleSystem:setSizes(0.1, 0.15)
	o.particleSystem:setLifetime(lifetime)
	o.particleSystem:setParticleLife(2.5, 4)
	o.particleSystem:setEmissionRate(64)
	o.particleSystem:setDirection(math.pi / 4 * 5)
	o.particleSystem:setGravity(0.1, 1)
	o.particleSystem:setTangentialAcceleration(0, 0)
	o.particleSystem:setSpin(0)
	o.particleSystem:setSpinVariation(0, 0)

	if pType == "bomb" then
		o.particleSystem:setDirection(math.pi * 2 - math.pi / 2)
		o.particleSystem:setParticleLife(0.5, 2.5)
		o.particleSystem:setSpeed(45, 85)
		o.particleSystem:setSizes(0.2, 0.5)
		o.particleSystem:setPosition(16, 0)
		o.particleSystem:setEmissionRate(80)
	elseif pType == "explosion" then
		o.particleSystem:setColors(200, 64, 0, 255, 0, 0, 0, 255)
		o.particleSystem:setSpread(40)
		o.particleSystem:setParticleLife(0.5, 1.2)
		o.particleSystem:setSpeed(30, 70)
		o.particleSystem:setSizes(1.5, 0.5)
		o.particleSystem:setDirection(math.pi * 2 - math.pi / 2)
		o.particleSystem:setSpin(0.5)
		o.particleSystem:setEmissionRate(250)
	elseif pType == "fire" then
		o.particleSystem:setColors(200, 64, 0, 255, 0, 0, 0, 255)
		o.particleSystem:setSpread(0.2)
		o.particleSystem:setParticleLife(1.5, 2.5)
		o.particleSystem:setSpeed(10, 40)
		o.particleSystem:setSizes(0.5, 0.1)
		o.particleSystem:setDirection(math.pi * 2 - math.pi / 2)
		o.particleSystem:setSpin(0.5)
	elseif pType == "bullet" then
		o.particleSystem:setColors(0, 0, 0, 64, 0, 0, 0, 0)
		o.particleSystem:setSpread(0.1)
		o.particleSystem:setParticleLife(0.5, 1)
		o.particleSystem:setSpeed(10, 40)
		o.particleSystem:setSizes(0.1, 0.1)
		o.particleSystem:setDirection(math.pi * 2 - math.pi / 2)
		o.particleSystem:setSpin(0.5)
		o.particleSystem:setEmissionRate(64)
	elseif pType == "blood" then
		o.particleSystem:setColors(255, 0, 0, 64, 255, 0, 0, 0)
		o.particleSystem:setSpread(40)
		o.particleSystem:setParticleLife(0.1, 0.5)
		o.particleSystem:setSpeed(10, 40)
		o.particleSystem:setSizes(0.1, 0.1)
		o.particleSystem:setDirection(math.pi * 2 - math.pi / 2)
		o.particleSystem:setSpin(0.5)
		o.particleSystem:setEmissionRate(256)
	end

	o.particleSystem:start()
	return o
end