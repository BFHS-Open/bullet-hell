local Point2d = require("lib.point2d")
local Sprite = require("lib.sprite")
local utils  = require("lib.utils")

local HomingEnemy = {}
HomingEnemy.__index = HomingEnemy

local sprite = Sprite.new("/assets/images/rocket.png", Point2d.rect(20, 20), Point2d.rect(-33, -70))

function HomingEnemy.new(data, game)
	local e = setmetatable(data, HomingEnemy)

	e.sprite = sprite
	e.game = game
	e.spawnTime = game.time
	e.alive = true
	e.weak = true

	e.radius = 3
	e.speed = utils.random(10, 30)
	e.angle = (e.target.position - e.position):angle()
		+ (-1/8 + 1/4 * love.math.random()) * math.pi * 2
	e.angleSpeed = math.pi / 2 / (e.speed / 20)

	local sound = SoundCatMeow:clone()
	love.audio.play(sound)
		
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
	self.sprite:draw(self.position, 1, 1 - fadeIn, self.angle + math.pi / 2)
	if self.game.showHitboxes then
		utils.drawHitbox(self.position, self.radius)
	end
end

return HomingEnemy
