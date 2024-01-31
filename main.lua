local playerFactory = require("player")
local enemyFactory = require("enemy")

function love.load()
	player = playerFactory.new(300, 400)
	enemy1 = enemyFactory.new(400, 0, "wallProjectile")
	enemy2 = enemyFactory.new(100, 0, "homing")

	love.graphics.setNewFont(12)
	love.graphics.setColor(0, 0, 0)
	love.graphics.setBackgroundColor(255, 255, 255)
	love.window.setMode(700, 700)
	timeInit = love.timer.getTime()
end

function love.update(dt)
	player:update(dt)
	enemy1:update(dt)
	enemy2:update(dt)
end

function love.draw()
	--score system. Initial Time is subtracted from the current time to get the elapsed time and generate a score
	timeCurr = love.timer.getTime() - timeInit
	score = timeCurr * 20
	love.graphics.draw(player.image, player.x, player.y, 0, player.scale, player.scale)
	love.graphics.draw(enemy1.image, enemy1.x, enemy1.y, 0, enemy1.scale, enemy1.scale)
	love.graphics.draw(enemy2.image, enemy2.x, enemy2.y, 0, enemy2.scale, enemy2.scale)
	love.graphics.print("score: " .. math.ceil(score), 10, 10)
end
