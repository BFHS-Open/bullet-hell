local utils = require("lib.utils")
local Sprite  = require("lib.sprite")
local Point2d = require("lib.point2d")

local panel = Sprite.new("assets/images/panel.png", Point2d.rect(80, 100), Point2d.rect(0, -10))

local Credits = {}
Credits.__index = Credits

function Credits.new(manager)
	local credits = setmetatable({}, Credits)
	credits.manager = manager
	return credits
end

function Credits:update(dt)
end

local short = 5
local long = 12

function Credits:draw()
	panel:draw(Point2d.rect(50, 52), 1, 3/4)
	utils.drawText("Credits", BigFont, 50, 8, 0, 0)
	local pos = 52 - (short * 3 + long * 3) / 2
	utils.drawText("Design", RegularFont, 50, pos, 0, 0)
	love.graphics.setColor(1, 3/4, 3/4)
	pos = pos + short
	utils.drawText("Austin, Jonathan, Eden, Xindi, Oscar", RegularFont, 50, pos, 0, 0)
	love.graphics.setColor(1, 1, 1)
	pos = pos + long
	utils.drawText("Programming", RegularFont, 50, pos, 0, 0)
	love.graphics.setColor(3/4, 1, 3/4)
	pos = pos + short
	utils.drawText("Austin, Jonathan, Joe, Thomas", RegularFont, 50, pos, 0, 0)
	love.graphics.setColor(1, 1, 1)
	pos = pos + long
	utils.drawText("Art", RegularFont, 50, pos, 0, 0)
	love.graphics.setColor(3/4, 3/4, 1)
	pos = pos + short
	utils.drawText("Eden", RegularFont, 50, pos, 0, 0)
	love.graphics.setColor(1, 1, 1)
	pos = pos + long
	utils.drawText("Sound assets credits soon!", RegularFont, 50, pos, 0, 0)
	love.graphics.setColor(1, 1, 1, 1/2)
	utils.drawText("space to return", RegularFont, 50, 94, 0, 0)
	love.graphics.setColor(1, 1, 1)
end

function Credits:onPress(key)
	if key ~= "space" then
		return
	end
	self.manager:moveTo("home", "credits")
end

return Credits
