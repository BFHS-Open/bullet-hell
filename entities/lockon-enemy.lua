local Point2d = require("lib.point2d")
local Sprite = require("lib.sprite")
local utils  = require("lib.utils")

local LockonEnemy = {}
LockonEnemy.__index = LockonEnemy

local sprite = Sprite.new("/assets/images/ufo.png", Point2d.rect(20, 20))

function LockonEnemy.new(data, game)
	local e = setmetatable(data, LockonEnemy)

	e.sprite = sprite
	e.game = game
	e.stageTime = game.time
	e.stage = 0
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
local fadeLength = 1/4

function LockonEnemy:update(dt)
	if self.stage == 0 then
		local oldSpeed = self.speed
		self.speed = self.speed + dt * self.acceleration
		self.position = self.position:goTo(dt * (self.speed + oldSpeed) / 2, self.target.position)
		if (self.position - self.target.position):length() < self.innerRadius + self.target.radius then
			self.stage = 1
			self.stageTime = self.game.time
		end
	elseif self.stage == 1 then
		if self.game.time - self.stageTime < activateDelay then
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
		self.stage = 2
		self.stageTime = self.game.time
	else
		if self.game.time - self.stageTime < fadeLength then
			return
		end
		self.alive = false
	end
end

function LockonEnemy:draw()
	if self.stage >= 1 then
		local x, y = utils.windowFromWorld(self.position):unpack()
		local rx, ry = utils.windowFromWorld(Point2d.rect(self.radius, self.radius)):unpack()
		love.graphics.push("all")
		if self.stage == 1 then
			local charge = (self.game.time - self.stageTime) / activateDelay
			love.graphics.setColor(1, 0, 0, 1/4)
			love.graphics.ellipse("fill", x, y, rx, ry)
			love.graphics.setColor(1, 0, 0, 1/2)
			love.graphics.ellipse("fill", x, y, rx * charge, ry * charge)
		else
			local fadeOut = (self.game.time - self.stageTime) / fadeLength
			love.graphics.setColor(1, 0, 0, 1 - fadeOut)
			love.graphics.ellipse("fill", x, y, rx, ry)
		end
		love.graphics.pop()
	end
	if self.stage < 2 then
		local fadeIn = self.stage == 1 and 1 or (self.game.time - self.stageTime) / enterTime
		self.sprite:draw(self.position, 1, fadeIn / 2)
	end
end

return LockonEnemy
