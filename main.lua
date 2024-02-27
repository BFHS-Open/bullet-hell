local Game = require("game")

function love.load()
	BigFont = love.graphics.newFont("assets/FiraCode-Regular.ttf", 36)
	RegularFont = love.graphics.newFont("assets/FiraCode-Regular.ttf", 24)
	BackgroundImage = love.graphics.newImage("assets/background.png")
	GameStarted = false
end

local game;

function love.update(dt)
	if not GameStarted then
		if love.keyboard.isDown("space") then
			GameStarted = true
			game = Game:new()
		end
	else
		game:update(dt)
	end
end

function love.draw()
	love.graphics.draw(BackgroundImage)
	if not GameStarted then
		local screenX, screenY = love.window.getMode()
		love.graphics.print("Bullet Hell", BigFont, screenX / 2 - 100, screenY / 2 - 120)
		love.graphics.print("Press Space to Start", RegularFont, screenX / 2 - 130, screenY / 2 + 120)
	else
		game:draw()
	end
end
