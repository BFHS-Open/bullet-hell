local config = require("lib.config")
local Point2d = require("lib.point2d")

local utils = {}

function utils.clamp(a, min, max)
	return math.min(math.max(a, min), max)
end

function utils.lerp(a, b, x)
	return a + (b - a) * x
end

function utils.random(min, max)
	return min + love.math.random() * (max - min)
end

function utils.worldFromWindow(v)
	local windowWidth, windowHeight = love.window:getMode()
	return v:scale(config.dims.x / windowWidth, config.dims.y / windowHeight)
end

function utils.windowFromWorld(v)
	local windowWidth, windowHeight = love.window:getMode()
	return v:scale(windowWidth / config.dims.x, windowHeight / config.dims.y)
end

function utils.drawText(text, font, x, y, horz, vert)
	local windowPos = utils.windowFromWorld(Point2d.rect(x, y))
	local textWidth = font:getWidth(text)
	local _, newlines = text:gsub("\n", "\n")
	local textHeight = font:getHeight() * (newlines + 1)
	-- flooring is to avoid blurry text
	love.graphics.print(
		text, font,
		math.floor(windowPos.x), math.floor(windowPos.y),
		0,
		1, 1,
		math.floor(textWidth * (1 - horz) / 2), math.floor(textHeight * (1 - vert) / 2)
	)
end

function utils.drawHitbox(position, radius)
	local x, y = utils.windowFromWorld(position):unpack()
	local rx, ry = utils.windowFromWorld(Point2d.rect(radius, radius)):unpack()
	utils.setRed()
	love.graphics.ellipse("line", x, y, rx, ry)
	love.graphics.setColor(1, 1, 1)
end

function utils.moveInBounds(position, padding)
	local x, y = position:unpack()
	return Point2d.rect(
		utils.clamp(x, padding, config.dims.x - padding),
		utils.clamp(y, padding, config.dims.y - padding)
	)
end

function utils.setRed(alpha)
	alpha = alpha or 1
	love.graphics.setColor(.8, .1, .25, alpha)
end

return utils
