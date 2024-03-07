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

function TextInput:onPress(key, scancode, isrepeat)
	if isrepeat and not self.active then
		return
	end
	self.active = true
	if key == "space" then
		key = " "
	end
	if #key == 1 then
		if love.keyboard.isDown("lshift", "rshift") then
			key = string.upper(key)
		end
		self.content = self.content .. key
	elseif key == "backspace" then
		self.content = string.sub(self.content, 1, #self.content - 1)
	elseif key == "return" then
		local content = self.content
		self.content = ""
		return content
	end
end

function TextInput:draw(pos, align)
	-- TODO: make menu look nicer
	local text = self.label .. self.content
	utils.drawText(text, BigFont, pos.x, pos.y, align.x, align.y)
	local textWidth = BigFont:getWidth(text)
	local textHeight = BigFont:getHeight()
	love.graphics.push("all")
	love.graphics.translate(utils.windowFromWorld(pos):unpack())
	love.graphics.translate(textWidth * (align.x - 1) / 2, textHeight * (align.y - 1) / 2)
	love.graphics.line(textWidth, 0, textWidth, textHeight)
	love.graphics.pop()
end

return TextInput
