-- Ludum Dare 23
-- Theme Tiny World
-- By Andreas Hedin

require "input"
require "entitymgr"
require "eventmgr"
require "factory"

paused = false
local scenes = {}
local active = nil
isGameover = false
size = { x = 640, y = 480}
points = 0
kills = 0
font = nil
bigFont = nil
balloonStr = ""
balloonHpStr = ""
towerStr = ""
towerHpStr = ""
turtleHpStr = ""

function love.load()
	math.randomseed(os.time())

	love.keyboard.setKeyRepeat(0.01, 0.01)

	bigFont = love.graphics.newFont("res/slkscr.ttf", 32)
	font = love.graphics.newFont("res/slkscr.ttf", 16)
	love.graphics.setDefaultImageFilter("nearest", "linear")
	love.graphics.setBackgroundColor(87, 210, 235)

	love.mouse.setVisible(false)

	scenes["menu"] = require "menu"
	scenes["game"] = require "game"
	restart()
end

function restart()
	points = 0
	kills = 0
	entitymgr:removeAll()
	scenes["menu"]:init()
	scenes["game"]:init()
	active = scenes["menu"]
	active:onActivate()
	isGameover = false
	enemy:init()
end

function love.draw()
	draw:handle()
	text:handle()

	if active.name == "game" then -- gui
		love.graphics.setFont(font)

		love.graphics.setColor(255, 0, 0)
		love.graphics.printf(balloonHpStr, size.x - 410, 58, 400, "right")
		love.graphics.printf(towerHpStr, size.x - 410, 123, 400, "right")
		love.graphics.printf(turtleHpStr, size.x - 410, 155, 400, "right")

		love.graphics.setColor(0, 0, 0)
		love.graphics.printf("Points: " .. points .. "   Kills: " .. kills, 10, 10, size.x, "left")
		love.graphics.printf(balloonStr, size.x - 410, 10, 400, "right")
		love.graphics.printf(towerStr, size.x - 410, 75, 400, "right")
		love.graphics.printf("Turtle", size.x - 410, 140, 400, "right")

		love.graphics.setColor(255, 255, 255)
	end
end

function love.update(dt)
	if not paused then
		for e, o in eventmgr:poll() do
	    	if e == "changeScene" then
	    		if active.name ~= o.goto then
		       		active:onDeactivate()
		       		active = scenes[o.goto]
		       		active:onActivate()
				end
			elseif e == "print" then
				entitymgr:print()
		    end 
		end

		if active.name == "game" then
			bkgd:handle(dt)
			anim:handle(dt)
			position:handle(dt)
			weapon:handle(dt)
			health:handle(dt)
			particle:handle(dt)
			enemy:handle(dt)
			control:handle(dt)
			sound:handle(dt)
			timeout:handle(dt)
		else
			anim:handle(dt)
		end
	end

	eventmgr:clear()
end

function love.quit()
	
end

function love.focus(f)
	if not f and active.name == "game" then
		eventmgr:push("changeScene", { goto = "menu"})
	end
end

function gameover()
	isGameover = true
	entitymgr:addEntity(entitymgr:createEntity{
		[cPos.name] = cPos.new(0, size.y / 2 - 32),
		[cText.name] = cText.new(bigFont, "Game Over", "center")
	})
	entitymgr:addEntity(entitymgr:createEntity{
		[cPos.name] = cPos.new(0, size.y / 2),
		[cText.name] = cText.new(font, "Push spacebar to continue", "center")
	})
	entitymgr:removeAllOfComponent(cBkgd.name)
	entitymgr:removeAllOfComponent(cAnim.name)
	entitymgr:removeAllOfComponent(cSound.name)
	entitymgr:removeAllOfComponent(cEnemy.name)
	entitymgr:removeAllOfComponent(cMove.name)
	entitymgr:removeAllOfComponent(cHealth.name)
	entitymgr:removeAllOfComponent(cControl.name)
end