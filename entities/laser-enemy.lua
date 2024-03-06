local Point2d = require("lib.point2d")
local config  = require("lib.config")
local utils  = require("lib.utils")

local LaserEnemy = {}
LaserEnemy.__index = LaserEnemy

function LaserEnemy.new(data, game)
	local e = setmetatable(data, LaserEnemy)

	e.game = game
	e.spawnTime = game.time
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

function LaserEnemy:update(dt)
	if self.game.time - self.spawnTime < activateDelay then
		return
	end

	if self.game.time - self.spawnTime >= activateDelay + activateLength then
		self.alive = false
		return
	end

	if math.abs(Point2d.polar(self.angle):cross(self.target.position - self.position)) < self.radius + self.target.radius then
		self.target.alive = false
	end
end

function LaserEnemy:draw()
	local charge = math.min((self.game.time - self.spawnTime) / activateDelay, 1)
	love.graphics.push("all")
	love.graphics.scale(utils.windowFromWorld(Point2d.rect(1, 1)):unpack())
	love.graphics.translate(self.position:unpack())
	love.graphics.rotate(self.angle)
	local span = config.dims:length()
	if charge < 1 then
		love.graphics.setColor(1, 0, 0, 1/4)
		love.graphics.rectangle("fill", -span, -self.radius, span * 2, self.radius * 2)
		love.graphics.setColor(1, 0, 0, 1/2)
		love.graphics.rectangle("fill", -span, -self.radius * charge, span * 2, self.radius * charge * 2)
	else
		love.graphics.setColor(1, 0, 0, 1)
		love.graphics.rectangle("fill", -span, -self.radius, span * 2, self.radius * 2)
	end
	love.graphics.pop()
end

return LaserEnemy
