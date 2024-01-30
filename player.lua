player = {}

function player:new(x, y)
   self.x = x
   self.y = y
   self.image = love.graphics.newImage("resources/player.png")
   self.scale = 0.3
   self.speed = 500
   return player
end

function player:update(dt)
   -- handle movement
   local dx, dy = 0, 0
   local adjustment = 1
   -- goes through the key set and changes the movement accordingly based on whether keys are active
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

   -- applies the vector normalization if both components are nonzero
   if dx ~= 0 and dy ~= 0 then
      adjustment = .707106
   end

   --applies movement
   player.x = player.x + dx * dt * player.speed * adjustment
   player.y = player.y + dy * dt * player.speed * adjustment
   
   -- handle screen border collisions
   if player.x < 0 then player.x = 0 end
   if player.x + player.image:getWidth() * player.scale > 1920 then player.x = 1920 - player.image:getWidth() * player.scale end
   if player.y < 0 then player.y = 0 end
   if player.y + player.image:getHeight() * player.scale > 1080 then player.y = 1080 - player.image:getHeight() * player.scale end
end