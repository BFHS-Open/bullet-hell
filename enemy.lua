local Point2d = require("lib.point2d")
local Sprite = require("lib.sprite")

local enemy = {}
enemy.__index = enemy

local sprites = {
	homing = Sprite.new("/assets/homing.png", Point2d.rect(10, 10)),
	ramming = Sprite.new("/assets/ramming.png", Point2d.rect(10, 10)),
}

function enemy.new(type, data)
	local e = setmetatable(data, enemy)

	e.type = type
	e.sprite = sprites[type]
	e.alive = true

	e.speed = 10

	-- kill distance used so that it can be set to 0 to not kill
	-- (mainly for the blinkies)
	e.radius = 5

	e.createdAt = love.timer.getTime()

	if e.type == "homing" then
		e.speed = 10
		e.radius = 2
	elseif e.type == "ramming" then
		e.speed = 40
	end

	return e
end

local function updateHoming(self, dt)
	-- TODO: WILL NEVER DESPAWN

	self.position = self.position:goTo(dt * self.speed, self.target.position)
end

local function updateRamming(self, dt)
	-- TODO: WILL NEVER DESPAWN AND WILL FLY INTO ABYSS

	self.position = self.position + dt * self.speed * Point2d.polar(self.angle)
end

function enemy:update(dt)
	-- go to specific update function
	if self.type == "homing" then
		updateHoming(self, dt)
	elseif self.type == "ramming" then
		updateRamming(self, dt)
	end

	if (self.position - self.target.position):length() < self.radius + self.target.radius then
		self.target.alive = false
	end
end

function enemy:draw()
	self.sprite:draw(self.position)
end

return enemy
