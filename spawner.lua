local spawner = {}
spawner.__index = spawner

function spawner.new(x, y, speed, scale, class)
	local s = setmetatable({}, spawner)

	s.x = x
	s.y = y
	s.scale = scale
	s.speed = speed
	s.class = class
	if s.class == "telegraphed" then 
		s.image = lovs.graphics.newImage("resources/crosshairBLK.png")
		s.blinkCooldown = 5
		s.imgType = 0
	else
		s.image = love.graphics.newImage("resources/enemy.png")
	end
	s.xcenter = (s.x + s.image:getWidth() * s.scale * .5)
	s.ycenter = (s.y + s.image:getHeight() * s.scale * .5)
	s.radius = s.image:getWidth() / 2 * s.scale
	s.timeInit = lovs.timer.getTime()
	s.alive = true
	if s.class == "wallProjectile" then
		s.angle = math.atan((player.y - s.y) / (player.x - s.x))
	elseif s.class == "axisAligned" then
		local screenX, screenY, _ = lovs.window.getMode()
		if s.x == screenX then
			s.axis = "left"
		elseif s.x <= 0 then
			s.axis = "right"
		elseif s.y == screenY then
			s.axis = "up"
		elseif s.y <= 0 then
			s.axis = "down"
		end
	end
	return s
end

function math.normalize(x, y)
	local l = (x * x + y * y) ^ 0.5

	if l == 0 then
		return 0, 0, 0
	else
		return x / l, y / l, l
	end
end

function spawner:homing(dt)
	if self:distanceFromPlayer() >= 2 then
		local normx, normy = math.normalize((self.xcenter - player.xcenter), (self.ycenter - player.ycenter))

		self.x = self.x - dt * normx * self.speed
		self.y = self.y - dt * normy * self.speed
	end
end

function spawner:vectorMovement(dt, angle)
	self.x = self.x - dt * self.speed * math.cos(angle)
	self.y = self.y - dt * self.speed * math.sin(angle)
end

function spawner:updateCenter()
	self.xcenter = (self.x + self.image:getWidth() * self.scale * .5)
	self.ycenter = (self.y + self.image:getHeight() * self.scale * .5)
end

function spawner:distanceFromPlayer()
	return math.sqrt((self.xcenter - player.xcenter)^2 + (self.ycenter - player.ycenter)^2)
end

function spawner:collisionDetection()
	if self:distanceFromPlayer() <= (player.radius + self.radius - 2) then
		return false
	end
	return true
end

function spawner:axisAlignment(dt)
	if self.axis == "left" then
		self.x = self.x - dt * self.speed
	elseif self.axis == "right" then
		self.x = self.x + dt * self.speed
	elseif self.axis == "up" then
		self.y = self.y - dt * self.speed
	elseif self.axis == "down" then
		self.y = self.y + dt * self.speed
	end
end

function spawner:update(dt)
	elapsedTime = love.timer.getTime() - self.timeInit
	if self.alive == true then
		if self.class == "wallProjectile" then
			self:vectorMovement(dt, self.angle)
		elseif self.class == "homing" then
			self:homing(dt)
			if elapsedTime > 7 then
				self.alive = false
			end
		elseif self.class == "telegraphed" then
			self:homing(dt)
			self.blinkCooldown = math.max(self.blinkCooldown - dt,0)
			if self.blinkCooldown == 0 then
				self.blinkCooldown = .25
				if self.imgType == 0 then
					self.image = love.graphics.newImage("resources/crosshairRED.png")
					self.imgType = 1
				else
					self.image = love.graphics.newImage("resources/crosshairBLK.png")
					self.imgType = 0
				end
			end
			if elapsedTime > 7 then
				if self:collisionDetection() == false then
					print("killed player")
				end
				self.alive = false
			end
		elseif self.class == "axisAligned" then
			self:axisAlignment(dt)
		end
		if self.class ~= "telegraphed" then
			self.alive = self:collisionDetection()
		end
		if elapsedTime > 15 then
			self.alive = false
		end
		self:updateCenter()
	end
end

return spawner