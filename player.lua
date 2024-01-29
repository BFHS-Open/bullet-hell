player = {}

function player:new(x, y)
   self.x = x
   self.y = y
   self.image = love.graphics.newImage("resources/player.png")
   self.scale = 0.3
   return player
end

function player:update()
   -- handle movement
   if love.keyboard.isDown("up") then
      player.y = player.y - 10
   end
   if love.keyboard.isDown("down") then
      player.y = player.y + 10
   end
   if love.keyboard.isDown("left") then
      player.x = player.x - 10
   end
   if love.keyboard.isDown("right") then
      player.x = player.x + 10
   end
   -- handle screen border collisions
   if player.x < 0 then player.x = 0 end
   if player.x + player.image:getWidth() * player.scale > 1920 then player.x = 1920 - player.image:getWidth() * player.scale end
   if player.y < 0 then player.y = 0 end
   if player.y + player.image:getHeight() * player.scale > 1080 then player.y = 1080 - player.image:getHeight() * player.scale end
end
