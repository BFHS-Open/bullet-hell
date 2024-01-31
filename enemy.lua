local enemy = {}
enemy.__index = enemy

function enemy.new(x, y)
	local e = setmetatable({}, enemy)

	e.x = x
	e.y = y
	e.image = love.graphics.newImage("resources/enemy.jpg")
	e.scale = 0.1
	e.speed = 200

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

function enemy:update(dt)
	normx, normy = math.normalize((self.x - player.x), (self.y - player.y))

	self.x = self.x - dt * normx * self.speed
	self.y = self.y - dt * normy * self.speed
end

return enemy
