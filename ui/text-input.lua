local utils = require("lib.utils")
local Point2d = require("lib.point2d")

local TextInput = {}
TextInput.__index = TextInput

function TextInput.new(label, content)
	local i = setmetatable({}, TextInput)
	i.label = label or ""
	i.content = content or ""
	i.active = false
	return i
end

function TextInput:onPress(key, _, isrepeat)
	-- prevent holding WASD causing typing
	if not isrepeat then
		self.active = true
	end
	if key == "backspace" then
		self.content = string.sub(self.content, 1, #self.content - 1)
	end
end

function TextInput:onText(text)
	if not self.active then
		return
	end
	self.content = self.content .. text
end

function TextInput:draw(pos, align)
	-- TODO: make menu look nicer
	local text = self.label .. self.content
	utils.drawText(text, BigFont, pos.x, pos.y, align.x, align.y)
	if Time % 1 < 1/2 then
		local textWidth = BigFont:getWidth(text)
		local textHeight = BigFont:getHeight()
		love.graphics.push("all")
		love.graphics.translate(utils.windowFromWorld(pos):unpack())
		love.graphics.translate(textWidth * (align.x - 1) / 2, textHeight * (align.y - 1) / 2)
		love.graphics.line(textWidth, 0, textWidth, textHeight)
		love.graphics.pop()
	end
end

return TextInput
