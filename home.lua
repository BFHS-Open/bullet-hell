local utils = require("lib.utils")
local Menu = require("menu")
local Point2d = require("lib.point2d")

local Home = {}
Home.__index = Home

function Home.new(manager)
	local home = setmetatable({}, Home)
	home.manager = manager
	home.menu = Menu.new({
		{
			label = "Start",
			onPress = function(self, key)
				if key ~= "space" then
					return
				end
				home.manager:moveTo("game")
			end
		},
		{
			label = "Difficulty",
			onPress = function() end
		},
		{
			label = "Leaderboard",
			onPress = function() end
		},
		{
			label = "Credits",
			onPress = function() end
		},
		{
			label = "Quit",
			onPress = function(self, key)
				if key ~= "space" then
					return
				end
				love.event.quit()
			end
		}
	})
	return home
end

function Home:update(dt)
end

function Home:draw()
	utils.drawText("Bullet Hell", BigFont, 50, 25, 0, 0)
	self.menu:draw(Point2d.rect(50, 50), Point2d.rect(0, 0))
	love.graphics.setColor(1, 1, 1, 1/2)
	utils.drawText("WASD to navigate, space to select", RegularFont, 50, 85, 0, 0)
	love.graphics.setColor(1, 1, 1)
end

function Home:onPress(...)
	self.menu:onPress(...)
end

return Home
