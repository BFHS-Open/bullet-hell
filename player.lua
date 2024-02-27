local Point2d = require("lib.point2d")
local Sprite = require("lib.sprite")
local config = require("lib.config")
local utils = require("lib.utils")

local player = {}
player.__index = player

local sprite = Sprite.new("/assets/player.png", Point2d.rect(10, 10))

function player.new(position)
	local p = setmetatable({}, player)

	p.position = position

	p.sprite = sprite

	p.speed = 40

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
	self.position.x = utils.clamp(self.position.x, 0, config.dims.x)
	self.position.y = utils.clamp(self.position.y, 0, config.dims.y)
end

return player
