enemy = {}

function enemy:new(x, y)
   self.x = x
   self.y = y
   self.image = love.graphics.newImage("resources/enemy.jpg")
   self.scale = 0.1
   self.speed = 200
   return enemy
end

function math.normalize(x,y) local l=(x*x+y*y)^.5 if l==0 then return 0,0,0 else return x/l,y/l,l end end

function enemy:update(dt)
   -- handle movement and direction
   normx, normy = math.normalize((self.x-player.x), (self.y-player.y))
   self.x = self.x - dt * normx * enemy.speed
   self.y = self.y - dt * normy * enemy.speed
end
