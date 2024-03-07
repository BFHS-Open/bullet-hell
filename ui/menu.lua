local utils = require("lib.utils")
local Point2d = require("lib.point2d")

local Menu = {}
Menu.__index = Menu

function Menu.new(buttons, selected)
	local menu = setmetatable({}, Menu)
	menu.buttons = buttons
	menu.selected = selected or 1
	return menu
end

function Menu:onPress(key)
	if key == "s" then
		self.selected = self.selected % #self.buttons + 1
	elseif key == "w" then
		self.selected = (self.selected - 2) % #self.buttons + 1
	else
		self.buttons[self.selected]:onPress(key)
	end
end

local spacing = 8

function Menu:draw(pos, align)
	local y = pos.y - (1 - align.y) / 2 * spacing * #self.buttons
	for i,button in ipairs(self.buttons) do
		utils.drawText(
			button.label,
			RegularFont,
			pos.x, y + (i - 1/2) * spacing,
			align.x, align.y
		)
	end
	local textWidth = RegularFont:getWidth(self.buttons[self.selected].label)
	local textHeight = RegularFont:getHeight()
	local rectPos = utils.windowFromWorld(Point2d.rect(
		pos.x,
		y + (self.selected - 1/2) * spacing
	)) - Point2d.rect(
		textWidth * (1 - align.x) / 2,
		textHeight * (1 - align.y) / 2
	)
	love.graphics.rectangle(
		"line",
		rectPos.x,
		rectPos.y,
		textWidth,
		textHeight
	)
end

return Menu
