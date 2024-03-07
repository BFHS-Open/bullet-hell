local utils = require("lib.utils")
local Menu = require("ui.menu")
local Point2d = require("lib.point2d")
local Sprite  = require("lib.sprite")

local Home = {}
Home.__index = Home

local title = Sprite.new("assets/images/title.png", Point2d.rect(336, 157) / 5)

function Home.new(manager, from)
	local home = setmetatable({}, Home)
	home.manager = manager
	home.soundButton = {
		label = manager.muted and "Sound [Off]" or "Sound [On]",
		onPress = function()
			manager:toggleSound()
			home.soundButton.label = manager.muted and "Sound [Off]" or "Sound [On]"
		end
	}
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
			label = "Leaderboard",
			onPress = function(self, key)
				if key ~= "space" then
					return
				end
				home.manager:moveTo("leaderboard")
			end
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
		home.soundButton,
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
		leaderboard = 2,
		credits = 3
	})[from])
	return home
end

function Home:update(dt)
end

function Home:draw()
	title:draw(Point2d.rect(50, 20))
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
