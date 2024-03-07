local Home = require("states.home")
local Game = require("states.game")
local Credits = require("states.credits")
local Leaderboard = require("states.leaderboard")

local Manager = {}
Manager.__index = Manager

local states = {
	home = Home,
	game = Game,
	leaderboard = Leaderboard,
	credits = Credits,
}

function Manager.new(State)
	local manager = setmetatable({}, Manager)

	-- global for convenience
	Time = 0

	manager.state = State.new(manager)
	manager.muted = false
	-- TODO: save to file
	manager.scores = {}
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

function Manager:onText(...)
	if self.state.onText == nil then
		return
	end
	self.state:onText(...)
end

function Manager:moveTo(state, ...)
	self.state = states[state].new(self, ...)
end

function Manager:toggleSound()
	self.muted = not self.muted
	if self.muted then
		love.audio.setVolume(0)
	else
		love.audio.setVolume(1)
	end
end

return Manager
