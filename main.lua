local config = require("lib.config")
local Sprite = require("lib.sprite")
local Manager = require("manager")
local Menu = require("menu")

local manager
local background

function love.load()
	-- global fonts
	BigFont = love.graphics.newFont("assets/FiraCode-Regular.ttf", 36)
	RegularFont = love.graphics.newFont("assets/FiraCode-Regular.ttf", 24)

	background = Sprite.new("/assets/background.png", config.dims * 12 / 7)
	manager = Manager.new(Menu)
end

function love.update(dt)
	manager:update(dt)
end

function love.draw()
	local step = Time / 60
	background:draw(config.dims:scale(
		1/2 + 5/28 * 2 * math.sin(step),
		1/2 + 5/28 * math.sin(2 * step)
	))
	manager:draw()
end
