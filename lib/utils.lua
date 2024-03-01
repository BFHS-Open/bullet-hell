local config = require("lib.config")

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

return utils
