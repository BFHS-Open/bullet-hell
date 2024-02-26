local point2d = require("point2d")

local enemy = {}
enemy.__index = enemy

function enemy.new(type, data)
  local e = setmetatable(data, enemy)

  e.type = type
  e.alive = true

  e.speed = 10

  -- kill distance used so that it can be set to 0 to not kill
  -- (mainly for the blinkies)
  e.killDistance = 2

  e.createdAt = love.timer.getTime()

  if e.type == "homing" then
    e.image = love.graphics.newImage("resources/homing.png")
    e.scale = 0.1
    e.speed = 50
  elseif e.type == "ramming" then
    e.image = love.graphics.newImage("resources/ramming.png")
    e.scale = 0.1
    e.speed = 100
  end

  return e
end

function enemy:update(dt)
  -- go to specific update function
  if self.type == "homing" then
    updateHoming(self, dt)
  elseif self.type == "ramming" then
    updateRamming(self, dt)
  end

  if self.position:distanceTo(self.target.position) < self.killDistance then
    self.target.alive = false
  end
end

function updateHoming(self, dt)
  -- TODO: WILL NEVER DESPAWN

  self.position:goTo(dt, self.speed, self.target.position)
end

function updateRamming(self, dt)
  -- TODO: WILL NEVER DESPAWN AND WILL FLY INTO ABYSS

  self.position:move(dt, 10, self.angle)
end

function enemy:draw()
  local imageX = self.position.x + self.image:getWidth() * self.scale * 0.5
  local imageY = self.position.y + self.image:getHeight() * self.scale * 0.5

  love.graphics.draw(self.image, imageX, imageY, self.scale, self.scale)
end

return enemy
