local Point2d = {}
Point2d.__index = Point2d

function Point2d.new(p)
	setmetatable(p, Point2d)
	return p
end

function Point2d.rect(x, y)
	return Point2d.new({ x = x, y = y })
end

function Point2d.polar(angle)
	return Point2d.new({ x = math.cos(angle), y = math.sin(angle) })
end

function Point2d:copy()
	return Point2d.new({ x = self.x, y = self.y })
end

function Point2d:unpack()
	return self.x, self.y
end

function Point2d.__add(a, b)
	return Point2d.rect(a.x + b.x, a.y + b.y)
end

function Point2d.__sub(a, b)
	return Point2d.rect(a.x - b.x, a.y - b.y)
end

function Point2d.__mul(a, b)
	if type(a) == "number" then
		a, b = b, a
	end
	return Point2d.rect(a.x * b, a.y * b)
end

function Point2d.__div(a, b)
	return Point2d.rect(a.x / b, a.y / b)
end

function Point2d.dot(a, b)
	return a.x * b.x + a.y * b.y
end

function Point2d:length()
	return math.sqrt(self:dot(self))
end

function Point2d:unit()
	local length = self:length()
	if length == 0 then
		return self:copy()
	end
	return self / self:length()
end

function Point2d:goTo(dist, other)
	local delta = other - self
	return self + math.min(dist, delta:length()) * delta:unit()
end

return Point2d
