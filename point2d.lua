local point2d = {}
point2d.__index = point2d

function point2d.new(x, y)
  local p = setmetatable({}, point2d)

  p.x = x
  p.y = y

  return p
end

function point2d:getX()
  return self.x
end

function point2d:getY()
  return self.y
end

function point2d:distanceTo(other)
  return math.sqrt((self.x - other.x)^2 + (self.y - other.y)^2)
end

function point2d:goTo(dt, speed, other)
  local normalizedX, normalizedY = math.normalize((self.x - other.x), (self.y - other.y));

  self.x = self.x - dt * normalizedX * speed
  self.y = self.y - dt * normalizedY * speed
end

function point2d:move(dt, speed, angle)
  self.x = self.x - dt * speed * math.cos(angle)
  self.y = self.y - dt * speed * math.cos(angle)
end

function point2d:moveBy(x, y)
  self.x = self.x + x
  self.y = self.y + y
end

-- stolen from love website
function math.normalize(x, y)
	local l = (x * x + y * y) ^ 0.5

	if l == 0 then
		return 0, 0, 0
	else
		return x / l, y / l, l
	end
end

return point2d
