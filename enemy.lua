local enemy = {}
enemy.__index = enemy

function enemy.new(x, y, class)
	local e = setmetatable({}, enemy)

	e.x = x
	e.y = y
	e.image = love.graphics.newImage("resources/enemy.jpg")
	e.scale = 0.1
	e.speed = 200
	e.class = class
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
	local normx, normy = math.normalize((self.x - player.x), (self.y - player.y))

	self.x = self.x - dt * normx * self.speed
	self.y = self.y - dt * normy * self.speed
end

function enemy:vectorMovement(dt, angle)
	self.x = self.x - dt * self.speed * math.cos(angle)
	self.y = self.y - dt * self.speed * math.sin(angle)
end

function enemy:update(dt)
	if self.class == "homing" then
		self:homing(dt)
	end
	if self.class == "wallProjectile" then
		self:vectorMovement(dt, self.angle)
	end
end

return enemy