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
function Manager.new(State, data)
	local manager = setmetatable({}, Manager)

	if data == nil then
		manager.muted = false
		manager.scores = {}
	else
		manager:deserialize(data)
	end
	manager.state = State.new(manager)
	return manager
end

function Manager:serialize()
	local width, height = love.window.getMode()
	local data = string.format("%d,%d,%d\n", self.muted and 1 or 0, width, height)
	for _,score in ipairs(self.scores) do
		if score.name == nil then
			score.name = ""
		end
		data = data .. string.format("%d", score.timestamp) .. ","
			.. string.format("%f", score.time) .. "\n"
			.. ":" .. score.name .. "\n"
	end
	return data
end

function Manager:deserialize(data)
	local i = 0
	self.scores = {}
	local score = {}
	for line in string.gmatch(data, "[^\n]+") do
		i = i + 1
		if i == 1 then
			local j = 0
			local width, height
			for val in string.gmatch(line, "[^,]+") do
				j = j + 1
				if j == 1 then
					self.muted = val ~= "0"
					if self.muted then
						love.audio.setVolume(0)
					else
						love.audio.setVolume(1)
					end
				elseif j == 2 then
					width = tonumber(val)
				else
					height = tonumber(val)
					break
				end
			end
			if width ~= 800 or height ~= 800 then
				love.window.setMode(width, height)
			end
		else
			if i % 2 == 0 then
				local j = 0
				for val in string.gmatch(line, "[^,]+") do
					j = j + 1
					if j == 1 then
						score.timestamp = tonumber(val)
					else
						score.time = tonumber(val)
						break
					end
				end
			else
				score.name = line:sub(2)
				table.insert(self.scores, score)
				score = {}
			end
		end
	end
end

function Manager:update(dt)
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

function Manager:save()
	return self:serialize()
end

return Manager
