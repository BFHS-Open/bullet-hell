local utils = require("lib.utils")

local Leaderboard = {}
Leaderboard.__index = Leaderboard

function Leaderboard.new(manager)
	local credits = setmetatable({}, Leaderboard)
	credits.manager = manager
	return credits
end

function Leaderboard:update(dt)
end

function Leaderboard:draw()
	utils.drawText("Leaderboard", BigFont, 50, 15, 0, 0)
	utils.drawText("TODO", SmallFont, 50, 50, 0, 0)
	love.graphics.setColor(1, 1, 1, 1/2)
	utils.drawText("space to return", RegularFont, 50, 85, 0, 0)
	love.graphics.setColor(1, 1, 1)
end

function Leaderboard:onPress(key)
	if key ~= "space" then
		return
	end
	self.manager:moveTo("home", "leaderboard")
end

return Leaderboard
