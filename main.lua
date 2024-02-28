local Menu = require("menu")
local Game = require("game")

local state;

function love.load()
	BigFont = love.graphics.newFont("assets/FiraCode-Regular.ttf", 36)
	RegularFont = love.graphics.newFont("assets/FiraCode-Regular.ttf", 24)
	BackgroundImage = love.graphics.newImage("assets/background.png")
	state = Menu:new()
end

local states = {
	menu = Menu,
	game = Game
}

function love.update(dt)
	local next = state:update(dt)
	if next ~= nil then
		state = states[next]:new()
	end
end

function love.draw()
	love.graphics.draw(BackgroundImage)
	state:draw()
end
