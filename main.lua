local config = require("lib.config")
local Point2d = require("lib.point2d")
local Sprite = require("lib.sprite")
local Menu = require("menu")
local Game = require("game")

local state
local background

function love.load()
	BigFont = love.graphics.newFont("assets/FiraCode-Regular.ttf", 36)
	RegularFont = love.graphics.newFont("assets/FiraCode-Regular.ttf", 24)
	background = Sprite.new("/assets/background.png", config.dims * 12 / 7)
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
	local time = love.timer.getTime()
	local step = time / 60
	background:draw(config.dims:scale(
		1/2 + 5/28 * 2 * math.sin(step),
		1/2 + 5/28 * math.sin(2 * step)
	))
	state:draw()
end
