local playerFactory = require("player")
local enemyFactory = require("enemy")

function love.load()
	player = playerFactory.new(380, 380)
	enemyTable = {}
	love.graphics.setNewFont(12)
	love.graphics.setBackgroundColor(255, 255, 255)
	love.window.setMode(700, 700)
	timeInit = love.timer.getTime()
	counter = 0
	cooldown = 1
	for i = 0, 5 do
		counter = counter + 1
		xstationary = love.math.random(0,700)
		ystationary = love.math.random(0,700)
		while distanceFrom(xstationary, ystationary, 380, 380) < (player.scale * (player.image:getWidth() / 2) + 25) do
			xstationary = math.random(0,700)
			ystationary = math.random(0,700)
		end
		enemyTable[counter] = enemyFactory.new(xstationary, ystationary, 0, .1, "stationary")
	end
end

function love.update(dt)
	cooldown = math.max(cooldown - dt,0)

	if cooldown == 0 then
		cooldown = 1
		counter = counter + 1
		local enemyx, enemyy = randomPerimeterCord()
		randClass = love.math.random()
		if randClass <= .1 then
			enemyTable[counter] = enemyFactory.new(enemyx, enemyy, 200, .1, "homing")
		elseif randClass <= .6 and randClass > .1 then
			enemyTable[counter] = enemyFactory.new(enemyx, enemyy, 300, .1, "wallProjectile")
		elseif randClass > .6 and randClass <= .9 then
			enemyTable[counter] = enemyFactory.new(enemyx, enemyy, 300, .1, "axisAligned")
		elseif randClass > .9 then
			enemyTable[counter] = enemyFactory.new(player.x, player.y, 250, .15, "telegraphed")
		end
	end
	player:update(dt)
	for i=1, counter do
		-- the alive/dead system results in a memory leak as dead enemies are never removed from memory
		if enemyTable[i].alive == true then
			enemyTable[i]:update(dt)
		end
	end
	if player.alive == false then
		love.event.quit(0)
	end
end

function distanceFrom(x1, y1, x2, y2)
	return math.sqrt((x1 - x2)^2 + (y1 - y2)^2)
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