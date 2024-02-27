local config = require("lib.config")

local Sprite = {}
Sprite.__index = Sprite

function Sprite.new(path, dims)
	local sprite = setmetatable({}, Sprite)
	sprite.image = love.graphics.newImage(path)
	sprite.dims = dims
	return sprite
end

function Sprite:draw(pos)
	local windowWidth, windowHeight = love.window:getMode()
	local imageWidth, imageHeight = self.image:getDimensions()
	local width = self.dims.x / config.dims.x * windowWidth
	local height = self.dims.y / config.dims.y * windowHeight
	love.graphics.draw(
		self.image,
		pos.x / config.dims.x * windowWidth,
		pos.y / config.dims.y * windowHeight,
		0,
		width / imageWidth,
		height / imageHeight,
		imageWidth / 2,
		imageHeight / 2
	)
end

return Sprite
