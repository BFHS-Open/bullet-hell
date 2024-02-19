local player = {}
player.__index = player

function player.new(x, y)
	local p = setmetatable({}, player)

	p.x = x
	p.y = y
	p.image = love.graphics.newImage("resources/player.png")
	p.scale = 0.1
	p.speed = 350
	p.radius = p.image:getWidth() / 2 * p.scale
	p.xcenter = (p.x + p.image:getWidth() * p.scale * .5)
	p.ycenter = (p.y + p.image:getHeight() * p.scale * .5)
	p.alive = true
	return p
end

function player:updateCenter()
	self.xcenter = (self.x + self.image:getWidth() * self.scale * .5)
	self.ycenter = (self.y + self.image:getHeight() * self.scale * .5)
end

function player:update(dt)
	local dx, dy = 0, 0
	local adjustment = 1

	if love.keyboard.isDown("w") then
		dy = dy - 1
	end
	if love.keyboard.isDown("s") then
		dy = dy + 1
	end
	if love.keyboard.isDown("d") then
		dx = dx + 1
	end
	if love.keyboard.isDown("a") then
		dx = dx - 1
	end

	if dx ~= 0 and dy ~= 0 then
		adjustment = 0.707106781
	end

	--applies movement
	self.x = self.x + dx * dt * self.speed * adjustment
	self.y = self.y + dy * dt * self.speed * adjustment
	self:updateCenter()

	local screenX, screenY, _ = love.window.getMode()

	-- handle screen border collisions
	if self.x < 0 then
		self.x = 0
	end
	if self.x + self.image:getWidth() * self.scale > screenX then
		self.x = screenX - self.image:getWidth() * self.scale
	end
	if self.y < 0 then
		self.y = 0
	end
	if self.y + self.image:getHeight() * self.scale > screenY then
		self.y = screenY - self.image:getHeight() * self.scale
	end
end

return player
