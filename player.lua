local Point2d = require("lib.point2d")
local Sprite = require("lib.sprite")
local config = require("lib.config")
local utils = require("lib.utils")

local player = {}
player.__index = player

local radius = 5
local sprite = Sprite.new("/assets/player.png", Point2d.rect(radius, radius) * 2)

function player.new(position)
	local p = setmetatable({}, player)

	p.position = position

	p.radius = radius

	p.sprite = sprite

	p.speed = 80

	p.alive = true

	return p
end

function player:draw()
	self.sprite:draw(self.position)
end

local function handleInput(self, dt)
	local v = Point2d.rect(0, 0)

	if love.keyboard.isDown("w") then
		v.y = v.y - 1
	end
	if love.keyboard.isDown("s") then
		v.y = v.y + 1
	end
	if love.keyboard.isDown("d") then
		v.x = v.x + 1
	end
	if love.keyboard.isDown("a") then
		v.x = v.x - 1
	end

	--applies movement
	self.position = self.position + self.speed * dt * v:unit()
end

function player:update(dt)
	handleInput(self, dt)

	-- handle screen border collisions
	self.position = utils.inBounds(self.position, self.radius)
end

return player
