local utils = require("lib.utils")

local Menu = {}
Menu.__index = Menu

function Menu.new(manager)
	local menu = setmetatable({}, Menu)
	menu.manager = manager
	-- TODO: figure out a better way to bind keys
	menu.onPressBound = function() menu:onPress() end
	Keys:onPress("space", menu.onPressBound)
	return menu
end

function Menu:close()
	Keys:offPress("space", self.onPressBound)
end

function Menu:onPress()
	self.manager:moveTo("game")
end

function Menu:update(dt)
end

function Menu:draw()
	utils.drawText("Bullet Hell", BigFont, 50, 45, 0, 0)
	utils.drawText("press space to start", RegularFont, 50, 55, 0, 0)
end

return Menu
