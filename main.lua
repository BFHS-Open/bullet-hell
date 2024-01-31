local playerFactory = require("player")
local enemyFactory = require("enemy")

function love.load()
	player = playerFactory.new(300, 400)
	horde = enemyFactory.new(0, 0)

	love.graphics.setNewFont(12)
	love.graphics.setColor(0, 0, 0)
	love.graphics.setBackgroundColor(255, 255, 255)
	love.window.setMode(700, 700)
	timeInit = love.timer.getTime()
end

function love.update(dt)
	player:update(dt)
	horde:update(dt)
end

function love.draw()
	--score system. Initial Time is subtracted from the current time to get the elapsed time and generate a score
	timeCurr = love.timer.getTime() - timeInit
	score = timeCurr * 20
	love.graphics.draw(player.image, player.x, player.y, 0, player.scale, player.scale)
	love.graphics.draw(horde.image, horde.x, horde.y, 0, horde.scale, horde.scale)
	love.graphics.print("score: " .. math.ceil(score), 10, 10)
end
