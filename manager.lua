local Home = require("home")
local Game = require("game")

local Manager = {}
Manager.__index = Manager

local states = {
	home = Home,
	game = Game
}

function Manager.new(State)
	local manager = setmetatable({}, Manager)

	-- global for convenience
	Time = 0

	manager.state = State.new(manager)
	return manager
end

function Manager:update(dt)
	Time = Time + dt
	self.state:update(dt)
end

function Manager:draw()
	self.state:draw()
end

function Manager:onPress(...)
	self.state:onPress(...)
end

function Manager:moveTo(state)
	self.state = states[state].new(self)
end

return Manager
