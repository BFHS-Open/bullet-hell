local config = require("lib.config")

local Sprite = {}
Sprite.__index = Sprite

function Sprite.new(path, dims)
	local sprite = setmetatable({}, Sprite)
	sprite.image = love.graphics.newImage(path)
	sprite.dims = dims
	return sprite
end

function Sprite:draw(pos, scale, alpha)
	scale = scale or 1
	alpha = alpha or 1
	local windowWidth, windowHeight = love.window:getMode()
	local imageWidth, imageHeight = self.image:getDimensions()
	local width = self.dims.x / config.dims.x * windowWidth
	local height = self.dims.y / config.dims.y * windowHeight
	love.graphics.setColor(1, 1, 1, alpha)
	love.graphics.draw(
		self.image,
		pos.x / config.dims.x * windowWidth,
		pos.y / config.dims.y * windowHeight,
		0,
		width / imageWidth * scale,
		height / imageHeight * scale,
		imageWidth / 2,
		imageHeight / 2
	)
	love.graphics.setColor(1, 1, 1, 1)
end

return Sprite
