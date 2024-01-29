enemy = {}

function enemy:new(x, y)
   self.x = x
   self.y = y
   self.image = love.graphics.newImage("resources/enemy.jpg")
   self.scale = 0.2
   return enemy
end

function enemy:update(player)
   -- handle movement and direction
   if self.x < player.x then
      self.x = self.x + 2
   end
   if self.x > player.x then
      self.x = self.x - 2
   end
   if self.y < player.y then
      self.y = self.y + 2
   end
   if self.y > player.y then
      self.y = self.y - 2
   end
end
