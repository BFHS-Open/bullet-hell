local Point2d = require("lib.point2d")
local Sprite = require("lib.sprite")
local utils  = require("lib.utils")

local StraightEnemy = {}
StraightEnemy.__index = StraightEnemy

local sprite = Sprite.new("/assets/images/asteroid.png", Point2d.rect(20, 20), Point2d.rect(10, 10))

function StraightEnemy.new(data, game)
	local e = setmetatable(data, StraightEnemy)

	e.sprite = sprite
	e.game = game
	e.spawnTime = game.time
	e.alive = true

	e.radius = 5
	e.speed = utils.random(30, 50)
	e.angle = (e.target.position - e.position):angle()
		+ (-1/8 + 1/4 * love.math.random()) * math.pi * 2

	local sound = SoundCatFunny:clone()
	love.audio.play(sound)

	return e
end

local enterTime = 1/4

function StraightEnemy:update(dt)
	self.position = self.position + dt * self.speed * Point2d.polar(self.angle)

	if self.position ~= utils.moveInBounds(self.position, -self.radius) then
		self.alive = false
		return
	end

	if (self.position - self.target.position):length() < self.radius + self.target.radius
		and self.game.time - self.spawnTime > enterTime
	then
		self.target.alive = false
	end
end

function StraightEnemy:draw()
	local fadeIn = math.max(1 - (self.game.time - self.spawnTime) / enterTime, 0)
	self.sprite:draw(self.position, 1, 1 - fadeIn)
	if self.game.showHitboxes then
		utils.drawHitbox(self.position, self.radius)
	end
end

return StraightEnemy
