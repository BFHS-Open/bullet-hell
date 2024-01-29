require("player")
require("enemy")

function love.load()
   player = player:new(300, 400) -- overriding the require...caution?
   horde = enemy:new(0, 0)
   
   love.graphics.setNewFont(12)
   love.graphics.setColor(0,0,0)
   love.graphics.setBackgroundColor(255,255,255)
   love.window.setMode(1920, 1080)
end

function love.update()
   player:update()
   horde:update(player)
end

function love.draw()
   love.graphics.draw(player.image, player.x, player.y, 0, player.scale, player.scale)
   love.graphics.draw(horde.image, horde.x, horde.y, 0, horde.scale, horde.scale)
   love.graphics.print("Click and drag the cake around or use the arrow keys", 10, 10)
end
