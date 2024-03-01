local config = require("lib.config")
local Point2d = require("lib.point2d")

local utils = {}

function utils.clamp(a, min, max)
	return math.min(math.max(a, min), max)
end

function utils.drawText(text, font, x, y, horz, vert)
	local windowWidth, windowHeight = love.window:getMode()
	local textWidth = font:getWidth(text)
	local textHeight = font:getHeight()
	love.graphics.print(
		text, font,
		x / config.dims.x * windowWidth, y / config.dims.y * windowHeight,
		0,
		1, 1,
		textWidth * (1 - horz) / 2, textHeight * (1 - vert) / 2
	)
end

function utils.moveInBounds(position, padding)
	local x, y = position:unpack()
	return Point2d.rect(
		utils.clamp(x, padding, config.dims.x - padding),
		utils.clamp(y, padding, config.dims.y - padding)
	)
end

return utils
