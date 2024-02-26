local Point2d = require("point2d")

local player = {}
player.__index = player

function player.new(position)
	local p = setmetatable({}, player)

	p.position = position

	p.image = love.graphics.newImage("resources/player.png")
	p.scale = 0.1

	p.speed = 350

	p.alive = true

	return p
end

function player:draw()
	local imageX = self.position.x + self.image:getWidth() * self.scale * 0.5
	local imageY = self.position.y + self.image:getHeight() * self.scale * 0.5

	love.graphics.draw(self.image, imageX, imageY, self.scale, self.scale)
end

local function handleInput(self, dt)
	local v = Point2d:rect(0, 0)

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

	local screenX, screenY, _ = love.window.getMode()

	-- handle screen border collisions
	if self.position.x < 0 then
		self.position.x = 0
	end
	if self.position.x + self.image:getWidth() * self.scale > screenX then
		self.position.x = screenX - self.image:getWidth() * self.scale
	end
	if self.position.y < 0 then
		self.position.y = 0
	end
	if self.position.y + self.image:getHeight() * self.scale > screenY then
		self.position.y = screenY - self.image:getHeight() * self.scale
	end
end

return player
