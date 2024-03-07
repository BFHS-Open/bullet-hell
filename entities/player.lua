local Point2d = require("lib.point2d")
local Sprite = require("lib.sprite")
local utils = require("lib.utils")

local Player = {}
Player.__index = Player

local radius = 4
local sprite = Sprite.new("/assets/images/astronaut.png", Point2d.rect(20, 20))

function Player.new(position, game)
	local p = setmetatable({}, Player)

	p.position = position
	p.radius = radius
	p.speed = 80

	p.sprite = sprite

	p.game = game
	p.alive = true

	return p
end

function Player:draw()
	self.sprite:draw(self.position)
	if self.game.showHitboxes then
		utils.drawHitbox(self.position, self.radius)
	end
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

function Player:update(dt)
	handleInput(self, dt)

	-- handle screen border collisions
	self.position = utils.moveInBounds(self.position, self.radius)
end

return Player
