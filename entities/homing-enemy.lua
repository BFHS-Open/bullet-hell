local Point2d = require("lib.point2d")
local Sprite = require("lib.sprite")
local config = require("lib.config")

local HomingEnemy = {}
HomingEnemy.__index = HomingEnemy

local sprite = Sprite.new("/assets/homing.png", Point2d.rect(10, 10))

function HomingEnemy.new(data, game)
	local e = setmetatable(data, HomingEnemy)

	e.sprite = sprite
	e.game = game
	e.spawnTime = game.time
	e.alive = true

	e.radius = 2
	e.speed = 20

	return e
end

local enterTime = 1/4

function HomingEnemy:update(dt)
	self.position = self.position:goTo(dt * self.speed, self.target.position)

	if self.game.time - self.spawnTime > config.dims:length() / self.speed then
		self.alive = false
		return
	end

	if (self.position - self.target.position):length() < self.radius + self.target.radius
		and self.game.time - self.spawnTime > enterTime
	then
		self.target.alive = false
	end
end

function HomingEnemy:draw()
	local fadeIn = math.max(1 - (self.game.time - self.spawnTime) / enterTime, 0)
	self.sprite:draw(self.position, 1, 1 - fadeIn)
end

return HomingEnemy
