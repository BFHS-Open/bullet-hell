local Point2d = require("lib.point2d")
local config  = require("lib.config")
local utils  = require("lib.utils")

local LaserEnemy = {}
LaserEnemy.__index = LaserEnemy

function LaserEnemy.new(data, game)
	local e = setmetatable(data, LaserEnemy)

	e.game = game
	e.stageTime = game.time
	e.stage = 0
	e.alive = true

	e.radius = 5

	if e.position.x == 0 then
		e.angle = 0
	elseif e.position.x == config.dims.x then
		e.angle = math.pi
	elseif e.position.y == 0 then
		e.angle = math.pi / 2
	else
		e.angle = math.pi * 3 / 2
	end

	return e
end

local activateDelay = 1
local activateLength = 1/2
local fadeLength = 1/8

function LaserEnemy:update(dt)
	if self.stage == 0 then
		if self.game.time - self.stageTime < activateDelay then
			return
		end
		self.stage = 1
		self.stageTime = self.game.time
	elseif self.stage == 1 then
		if math.abs(Point2d.polar(self.angle):cross(self.target.position - self.position)) < self.radius + self.target.radius then
			self.target.alive = false
		end
		if self.game.time - self.stageTime < activateLength then
			return
		end
		self.stage = 2
		self.stageTime = self.game.time
	else
		if self.game.time - self.stageTime < fadeLength then
			return
		end
		self.alive = false
	end
end

function LaserEnemy:draw()
	love.graphics.push("all")
	love.graphics.scale(utils.windowFromWorld(Point2d.rect(1, 1)):unpack())
	love.graphics.translate(self.position:unpack())
	love.graphics.rotate(self.angle)
	local span = config.dims:length()
	if self.stage == 0 then
		local charge = math.min((self.game.time - self.stageTime) / activateDelay, 1)
		utils.setRed(1/4)
		love.graphics.rectangle("fill", -span, -self.radius, span * 2, self.radius * 2)
		utils.setRed(1/2)
		love.graphics.rectangle("fill", -span, -self.radius * charge, span * 2, self.radius * charge * 2)
	else
		local fadeOut = self.stage == 1 and 1 or 1 - (self.game.time - self.stageTime) / fadeLength
		utils.setRed()
		love.graphics.rectangle("fill", -span, -self.radius * fadeOut, span * 2, self.radius * fadeOut * 2)
	end
	love.graphics.pop()
end

return LaserEnemy
