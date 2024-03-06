local utils = require("lib.utils")
local Menu = require("ui.menu")
local Point2d = require("lib.point2d")

local Home = {}
Home.__index = Home

function Home.new(manager, from)
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
			onPress = function(self, key)
				if key ~= "space" then
					return
				end
				home.manager:moveTo("credits")
			end
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
	}, ({
		game = 1,
		leaderboard = 3,
		credits = 4
	})[from])
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
	-- no settings menu, so - and + directly resize screen
	local key = ...
	if key == "-" then
		local width, height = love.window.getMode()
		love.window.setMode(
			math.max(width - 100, 100),
			math.max(height - 100, 100)
		)
		return
	elseif key == "=" then
		local width, height = love.window.getMode()
		love.window.setMode(
			math.min(width + 100, 4000),
			math.min(height + 100, 4000)
		)
		return
	end
	self.menu:onPress(...)
end

return Home
