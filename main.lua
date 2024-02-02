local playerFactory = require("player")
local enemyFactory = require("enemy")

function love.load()
	player = playerFactory.new(300, 400)
	enemyTable = {}
	love.graphics.setNewFont(12)
	love.graphics.setBackgroundColor(255, 255, 255)
	love.window.setMode(700, 700)
	timeInit = love.timer.getTime()
	counter = 0
	cooldown = 0
end

function love.update(dt)
	cooldown = math.max(cooldown - dt,0)

	if cooldown == 0 then
		cooldown = .5
		counter = counter + 1
		local enemyx, enemyy = randomPerimeterCord()
		randClass = math.random()
		if randClass <= .1 then
			enemyTable[counter] = enemyFactory.new(enemyx, enemyy, 150, "homing")
		elseif randClass < .6 and randClass > .1 then
			enemyTable[counter] = enemyFactory.new(enemyx, enemyy, 300, "wallProjectile")
		elseif randClass >= .6 then
			enemyTable[counter] = enemyFactory.new(enemyx, enemyy, 300, "axisAligned")
		end
	end
	player:update(dt)
	for i=1, counter do
		-- the alive/dead system results in a memory leak as dead enemies are never removed from memory
		if enemyTable[i].alive == true then
			enemyTable[i]:update(dt)
		end
	end
end

function randomPerimeterCord()
	local screenX, screenY, _ = love.window.getMode()
	local side = math.random(1, 4)
	if side == 1 then
		x = math.random(0, 700)
		y = 0 - (enemyTable[1].image:getWidth() * enemyTable[1].scale * .5)
	elseif side == 2 then
		x = math.random(0, 700)
		y = screenY
	elseif side == 3 then
		x = 0 - (enemyTable[1].image:getWidth() * enemyTable[1].scale)
		y = math.random(0, 700)
	else
		x = screenX
		y = math.random(0, 700)
	end
	return x, y
end

function love.draw()
	--score system. Initial Time is subtracted from the current time to get the elapsed time and generate a score
	timeCurr = love.timer.getTime() - timeInit
	score = timeCurr * 20
	love.graphics.draw(player.image, player.x, player.y, 0, player.scale, player.scale)
	for i=1, counter do
		if enemyTable[i].alive == true then
			love.graphics.draw(enemyTable[i].image, enemyTable[i].x, enemyTable[i].y, enemyTable[i].scale, enemyTable[i].scale)
		end
	end
	love.graphics.printf({{0, 0, 0}, ("score: " .. math.ceil(score))}, 10, 10, 99)
end
