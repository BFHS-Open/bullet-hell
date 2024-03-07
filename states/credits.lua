local utils = require("lib.utils")

-- TODO: actual formatting
local creditText = [[
- Design -

Jonathan, Austin, Eden, Xindi, Oscar

- Programming -

Jonathan, Austin, Joe, Thomas

- Art -

Eden

Sound assets credits soon!
]]

local Credits = {}
Credits.__index = Credits

function Credits.new(manager)
	local credits = setmetatable({}, Credits)
	credits.manager = manager
	return credits
end

function Credits:update(dt)
end

function Credits:draw()
	utils.drawText("Credits", BigFont, 50, 15, 0, 0)
	utils.drawText(creditText, SmallFont, 50, 50, 0, 0)
	love.graphics.setColor(1, 1, 1, 1/2)
	utils.drawText("space to return", RegularFont, 50, 85, 0, 0)
	love.graphics.setColor(1, 1, 1)
end

function Credits:onPress(key)
	if key ~= "space" then
		return
	end
	self.manager:moveTo("home", "credits")
end

return Credits
