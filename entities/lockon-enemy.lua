local Point2d = require("lib.point2d")
local Sprite = require("lib.sprite")
local utils  = require("lib.utils")

local LockonEnemy = {}
LockonEnemy.__index = LockonEnemy

local sprite = Sprite.new("/assets/images/lockon.png", Point2d.rect(20, 20))

function LockonEnemy.new(data, game)
	local e = setmetatable(data, LockonEnemy)

	e.sprite = sprite
	e.game = game
	e.spawnTime = game.time
	e.activated = false
	e.alive = true

	e.radius = 20
	e.innerRadius = 5
	e.speed = 25
	e.acceleration = 1

	local sound = SoundCatPurr:clone()
	love.audio.play(sound)

	return e
end

local enterTime = 1/4
local activateDelay = 1

function LockonEnemy:update(dt)
	if not self.activated then
		local oldSpeed = self.speed
		self.speed = self.speed + dt * self.acceleration
		self.position = self.position:goTo(dt * (self.speed + oldSpeed) / 2, self.target.position)
		if (self.position - self.target.position):length() < self.innerRadius + self.target.radius then
			self.activated = true
			self.activateTime = self.game.time
		end
	else
		if self.game.time - self.activateTime < activateDelay then
			return
		end
		for other in self.game.enemies:pairs() do
			if other.weak and (self.position - other.position):length() < self.radius + other.radius then
				other.alive = false
			end
		end
		if (self.position - self.target.position):length() < self.radius + self.target.radius then
			self.target.alive = false
		end
		self.alive = false
	end
end

function LockonEnemy:draw()
	if self.activated then
		local x, y = utils.windowFromWorld(self.position):unpack()
		local rx, ry = utils.windowFromWorld(Point2d.rect(self.radius, self.radius)):unpack()
		local charge = (self.game.time - self.activateTime) / activateDelay
		love.graphics.setColor(1, 0, 0, charge ^ 4)
		love.graphics.ellipse("fill", x, y, rx, ry)
		love.graphics.setColor(1, 1, 1)
	end
	local fadeIn = math.max(1 - (self.game.time - self.spawnTime) / enterTime, 0)
	self.sprite:draw(self.position, 1, (1 - fadeIn) / 2)
end

return LockonEnemy
