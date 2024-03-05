local utils = require("lib.utils")

local Menu = {}
Menu.__index = Menu

function Menu.new(manager)
	local menu = setmetatable({}, Menu)
	menu.manager = manager
	return menu
end

function Menu:update(dt)
	if love.keyboard.isDown("space") then
		return "game"
	end
end

function Menu:draw()
	utils.drawText("Bullet Hell", BigFont, 50, 45, 0, 0)
	utils.drawText("Press Space to Start", RegularFont, 50, 55, 0, 0)
end

return Menu
