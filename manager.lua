local Menu = require("menu")
local Game = require("game")
local Keymapper = require("keymapper")

local Manager = {}
Manager.__index = Manager

local states = {
	menu = Menu,
	game = Game
}

function Manager.new(State)
	local manager = setmetatable({}, Manager)

	-- globals for convenience
	Time = 0
	Keys = Keymapper.new()
	Keys:activate()

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

function Manager:moveTo(state)
	self.state:close()
	self.state = states[state].new(self)
end

return Manager
