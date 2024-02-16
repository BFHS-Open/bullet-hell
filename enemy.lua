local enemy = {}
enemy.__index = enemy

function enemy.new(x, y, speed, scale, class)
	local e = setmetatable({}, enemy)

	e.x = x
	e.y = y
	e.scale = scale
	e.speed = speed
	e.class = class
	if e.class == "telegraphed" then 
		e.image = love.graphics.newImage("resources/crosshairBLK.png")
		e.blinkCooldown = 5
		e.imgType = 0
	else
		e.image = love.graphics.newImage("resources/enemy.png")
	end
	e.xcenter = (e.x + e.image:getWidth() * e.scale * .5)
	e.ycenter = (e.y + e.image:getHeight() * e.scale * .5)
	e.radius = e.image:getWidth() / 2 * e.scale
	e.timeInit = love.timer.getTime()
	e.alive = true
	if e.class == "wallProjectile" then
		e.angle = math.atan((player.y - e.y) / (player.x - e.x))
	elseif e.class == "axisAligned" then
		local screenX, screenY, _ = love.window.getMode()
		if e.x == screenX then
			e.axis = "left"
		elseif e.x <= 0 then
			e.axis = "right"
		elseif e.y == screenY then
			e.axis = "up"
		elseif e.y <= 0 then
			e.axis = "down"
		end
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
	if self:distanceFromPlayer() >= 2 then
		local normx, normy = math.normalize((self.xcenter - player.xcenter), (self.ycenter - player.ycenter))

		self.x = self.x - dt * normx * self.speed
		self.y = self.y - dt * normy * self.speed
	end
end

function enemy:vectorMovement(dt, angle)
	self.x = self.x - dt * self.speed * math.cos(angle)
	self.y = self.y - dt * self.speed * math.sin(angle)
end

function enemy:updateCenter()
	self.xcenter = (self.x + self.image:getWidth() * self.scale * .5)
	self.ycenter = (self.y + self.image:getHeight() * self.scale * .5)
end

function enemy:distanceFromPlayer()
	return math.sqrt((self.xcenter - player.xcenter)^2 + (self.ycenter - player.ycenter)^2)
end

function enemy:collisionDetection()
	if self:distanceFromPlayer() <= (player.radius + self.radius - 2) then
		return true
	end
	return false
end

function enemy:axisAlignment(dt)
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

function enemy:update(dt)
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
				if self:collisionDetection() == true then
					print("killed player")
				end
				self.alive = false
			end
		elseif self.class == "axisAligned" then
			self:axisAlignment(dt)
		end
		if self.class ~= "telegraphed" then
			self.alive = not self:collisionDetection()
		end
		if elapsedTime > 15 then
			self.alive = false
		end
		self:updateCenter()
	end
end

return enemy
