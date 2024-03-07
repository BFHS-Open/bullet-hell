local utils = require("lib.utils")
local Sprite  = require("lib.sprite")
local Point2d = require("lib.point2d")

local panel = Sprite.new("assets/images/panel.png", Point2d.rect(80, 100), Point2d.rect(0, -10))

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
	panel:draw(Point2d.rect(50, 52), 1, 3/4)
	utils.drawText("Leaderboard", BigFont, 50, 8, 0, 0)
	love.graphics.setColor(1, 1, 1, 1/2)
	utils.drawText("Time", RegularFont, 39, 20, -1, 0)
	utils.drawText("Name", RegularFont, 41, 20, 1, 0)
	love.graphics.setColor(1, 1, 1)
	local scores = self.manager.scores
	for i = 1, rows  do
		local entry = scores[self.offset + i]
		if entry == nil then
			break
		end
		utils.drawText(utils.clockFromSeconds(entry.time), RegularFont, 39, 20 + 5 * i, -1, 0)
		utils.drawText(entry.name, RegularFont, 41, 20 + 5 * i, 1, 0)
	end
	love.graphics.setColor(1, 1, 1, 1/2)
	utils.drawText("scroll to navigate, space to return", RegularFont, 50, 94, 0, 0)
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
