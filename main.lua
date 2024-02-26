local playerFactory = require("player")
local enemyFactory = require("enemy")
local Point2d = require("point2d")
local game = require("game")
local config = require("config")
local utils = require("utils")

function love.load()
	BigFont = love.graphics.newFont("resources/FiraCode-Regular.ttf", 36)
	RegularFont = love.graphics.newFont("resources/FiraCode-Regular.ttf", 24)
	love.graphics.setBackgroundColor(255, 255, 255)
	BackgroundImage = love.graphics.newImage("resources/background.png")
	love.window.setMode(700, 700)
	GameStarted = false
end

function love.update(dt)
	if not GameStarted then
		if love.keyboard.isDown("space") then
			GameStarted = true
			game.load()
		end
	else
		game.update(dt)
	end
end

function love.draw()
	love.graphics.draw(BackgroundImage)
	if not GameStarted then
		local screenX, screenY = love.window.getMode()
		love.graphics.print("Bullet Hell", BigFont, screenX/2-100, screenY/2-120)
		love.graphics.print("Press Space to Start", RegularFont, screenX/2-130, screenY/2+120)

	else
		game.draw()
	end
end
