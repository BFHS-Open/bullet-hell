local Point2d = require("lib.point2d")
local Sprite = require("lib.sprite")
local utils  = require("lib.utils")
local config = require("lib.config")

local enterTime = 1/4

local Enemy = {}
Enemy.__index = Enemy

local sprites = {
	straight = Sprite.new("/assets/straight.png", Point2d.rect(10, 10)),
	homing = Sprite.new("/assets/homing.png", Point2d.rect(10, 10)),
}

function Enemy.new(type, data, game)
	local e = setmetatable(data, Enemy)

	e.type = type
	e.sprite = sprites[type]
	e.alive = true

	e.speed = 10

	-- kill distance used so that it can be set to 0 to not kill
	-- (mainly for the blinkies)
	e.radius = 5

	e.game = game
	e.spawnTime = game.time

	if e.type == "homing" then
		e.speed = 10
		e.radius = 2
	elseif e.type == "straight" then
		e.speed = 40
	end

	return e
end

local function updateHoming(enemy, dt)
	enemy.position = enemy.position:goTo(dt * enemy.speed, enemy.target.position)

	if enemy.game.time - enemy.spawnTime > config.dims:length() / enemy.speed then
		enemy.alive = false
	end
end

local function updateStraight(enemy, dt)
	enemy.position = enemy.position + dt * enemy.speed * Point2d.polar(enemy.angle)

	if enemy.position ~= utils.moveInBounds(enemy.position, -enemy.radius) then
		enemy.alive = false
	end
end

function Enemy:update(dt)
	-- go to specific update function
	if self.type == "homing" then
		updateHoming(self, dt)
	elseif self.type == "straight" then
		updateStraight(self, dt)
	end

	if (self.position - self.target.position):length() < self.radius + self.target.radius then
		self.target.alive = false
	end
end

function Enemy:draw()
	local fadeIn = math.max(1 - (self.game.time - self.spawnTime) / enterTime, 0)
	self.sprite:draw(self.position, 1, 1 - fadeIn)
end

return Enemy
