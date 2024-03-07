local utils = require("lib.utils")

local Leaderboard = {}
Leaderboard.__index = Leaderboard

function Leaderboard.new(manager)
	local leaderboard = setmetatable({}, Leaderboard)
	leaderboard.manager = manager
	leaderboard.offset = 0
	return leaderboard
end

function Leaderboard:update(dt)
end

local rows = 12

function Leaderboard:draw()
	utils.drawText("Leaderboard", BigFont, 50, 10, 0, 0)
	love.graphics.setColor(1, 1, 1, 1/2)
	utils.drawText("Time", RegularFont, 49, 20, -1, 0)
	utils.drawText("Name", RegularFont, 51, 20, 1, 0)
	love.graphics.setColor(1, 1, 1)
	local scores = self.manager.scores
	for i = 1, rows  do
		local entry = scores[self.offset + i]
		utils.drawText(utils.clockFromSeconds(entry.time), RegularFont, 49, 20 + 5 * i, -1, 0)
		utils.drawText(entry.name, RegularFont, 51, 20 + 5 * i, 1, 0)
	end
	love.graphics.setColor(1, 1, 1, 1/2)
	utils.drawText("scroll to navigate, space to return", RegularFont, 50, 90, 0, 0)
	love.graphics.setColor(1, 1, 1)
end

function Leaderboard:scroll(x)
	self.offset = utils.clamp(self.offset + x, 0, math.max(#self.manager.scores - rows, 0))
end

function Leaderboard:onPress(key)
	if key == "w" then
		self:scroll(-1)
	elseif key == "s" then
		self:scroll(1)
	elseif key == "space" then
		self.manager:moveTo("home", "leaderboard")
	end
end

function Leaderboard:onWheel(_, y)
	self:scroll(-y)
end

return Leaderboard
