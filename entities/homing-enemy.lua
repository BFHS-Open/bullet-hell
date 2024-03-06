local Point2d = require("lib.point2d")
local Sprite = require("lib.sprite")
local utils  = require("lib.utils")

local HomingEnemy = {}
HomingEnemy.__index = HomingEnemy

local sprite = Sprite.new("/assets/homing.png", Point2d.rect(10, 10))

function HomingEnemy.new(data, game)
	local e = setmetatable(data, HomingEnemy)

	e.sprite = sprite
	e.game = game
	e.spawnTime = game.time
	e.alive = true
	e.weak = true

	e.radius = 3
	e.speed = utils.random(10, 30)
	e.angleSpeed = math.pi / 2 / (e.speed / 20)

	CatSound1:seek(0, "seconds")
	love.audio.play(CatSound1)
		
	return e
end

local enterTime = 1/4

function HomingEnemy:update(dt)
	local targetAngle = (self.target.position - self.position):angle()
	local deltaAngle = (targetAngle - self.angle + math.pi) % (2 * math.pi) - math.pi
	local maxDeltaAngle = dt * self.angleSpeed
	deltaAngle = utils.clamp(deltaAngle, -maxDeltaAngle, maxDeltaAngle)
	self.angle = self.angle + deltaAngle
	self.position = self.position + dt * self.speed * Point2d.polar(self.angle)

	if (self.position - self.target.position):length() < self.radius + self.target.radius
		and self.game.time - self.spawnTime > enterTime
	then
		self.target.alive = false
	end
end

function HomingEnemy:draw()
	local fadeIn = math.max(1 - (self.game.time - self.spawnTime) / enterTime, 0)
	self.sprite:draw(self.position, 1, 1 - fadeIn, self.angle)
end

return HomingEnemy
