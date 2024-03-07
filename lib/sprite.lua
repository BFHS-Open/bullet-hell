local utils = require("lib.utils")
local Point2d = require("lib.point2d")

local Sprite = {}
Sprite.__index = Sprite

function Sprite.new(path, dims, origin)
	local sprite = setmetatable({}, Sprite)
	sprite.image = love.graphics.newImage(path)
	sprite.dims = dims
	sprite.origin = origin or Point2d.rect(0, 0)
	return sprite
end

function Sprite:draw(pos, scale, alpha, angle)
	scale = scale or 1
	alpha = alpha or 1
	angle = angle or 0
	local imageWidth, imageHeight = self.image:getDimensions()
	local windowDims = utils.windowFromWorld(self.dims)
	local windowPos = utils.windowFromWorld(pos)
	love.graphics.setColor(1, 1, 1, alpha)
	love.graphics.draw(
		self.image,
		windowPos.x,
		windowPos.y,
		angle,
		windowDims.x / imageWidth * scale,
		windowDims.y / imageHeight * scale,
		imageWidth / 2 + self.origin.x,
		imageHeight / 2 + self.origin.y
	)
	love.graphics.setColor(1, 1, 1)
end

return Sprite
