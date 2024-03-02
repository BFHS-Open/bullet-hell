local utils = require("lib.utils")

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
	local imageWidth, imageHeight = self.image:getDimensions()
	local windowDims = utils.windowFromWorld(self.dims)
	local windowPos = utils.windowFromWorld(pos)
	love.graphics.setColor(1, 1, 1, alpha)
	love.graphics.draw(
		self.image,
		windowPos.x,
		windowPos.y,
		0,
		windowDims.x / imageWidth * scale,
		windowDims.y / imageHeight * scale,
		imageWidth / 2,
		imageHeight / 2
	)
	love.graphics.setColor(1, 1, 1)
end

return Sprite
