local enemy = {}
enemy.__index = enemy

function enemy.new(x, y, speed, class)
	local e = setmetatable({}, enemy)

	e.x = x
	e.y = y
	e.image = love.graphics.newImage("resources/enemy.png")
	e.scale = 0.1
	e.speed = speed
	e.class = class
	e.xcenter = (e.x + e.image:getWidth() * e.scale * .5)
	e.ycenter = (e.y + e.image:getHeight() * e.scale * .5)
	e.radius = e.image:getWidth() / 2 * e.scale
	e.timeInit = love.timer.getTime()
	e.alive = true
	if e.class == "wallProjectile" then
		e.angle = math.atan((player.y - e.y) / (player.x - e.x))
	end

	return e
end

function math.normalize(x, y)
	local l = (x * x + y * y) ^ 0.5

	if l == 0 then
		return 0, 0, 0
	else
		return x / l, y / l, l
	end
end

function enemy:homing(dt)
	local normx, normy = math.normalize((self.xcenter - player.xcenter), (self.ycenter - player.ycenter))

	self.x = self.x - dt * normx * self.speed
	self.y = self.y - dt * normy * self.speed
end

function enemy:vectorMovement(dt, angle)
	self.x = self.x - dt * self.speed * math.cos(angle)
	self.y = self.y - dt * self.speed * math.sin(angle)
end

function enemy:updateCenter()
	self.xcenter = (self.x + self.image:getWidth() * self.scale * .5)
	self.ycenter = (self.y + self.image:getHeight() * self.scale * .5)
end

function enemy:collisionDetection()
	if math.sqrt((self.xcenter - player.xcenter)^2 + (self.ycenter - player.ycenter)^2) <= (player.radius + self.radius - 2) then
		self.alive = false
	end
end

function enemy:update(dt)
	if self.alive == true then
		if self.class == "wallProjectile" then
			self:vectorMovement(dt, self.angle)
		end
		if self.class == "homing" then
			self:homing(dt)
			if love.timer.getTime() - self.timeInit > 7 then
				self.alive = false
			end
		end
		self:updateCenter()
		self:collisionDetection()
	end
end

return enemy