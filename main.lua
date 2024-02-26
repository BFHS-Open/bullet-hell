local playerFactory = require("player")
local enemyFactory = require("enemy")
local point2dFactory = require("point2d")

function love.load()
	love.graphics.setNewFont(12)
	love.graphics.setBackgroundColor(255, 255, 255)
	love.window.setMode(700, 700)

	player = playerFactory.new(point2dFactory.new(350, 350))
	enemyTable = {}


	for i = 0, 5 do
		enemyTable[i] = createRandomEnemy(player)
	end
end

function createRandomEnemy(player)
		data = {}
	
		local screenX, screenY, _ = love.window.getMode()

		-- flip coin for axis
		if (love.math.random(0, 1) == 0) then
			-- x axis, flip for left or right side

			if (love.math.random(0, 1) == 0) then
				data["position"] = point2dFactory.new(0, love.math.randomNormal() * screenY)
			else
				data["position"] =point2dFactory.new(screenX, love.math.randomNormal() * screenY)
			end

		else 
			-- y axis, flip for top or bottom

			if (love.math.random(0, 1) == 0) then
				data["position"] = point2dFactory.new(love.math.randomNormal() * screenX, 0)
			else
				data["position"] = point2dFactory.new(love.math.randomNormal() * screenX, screenY)
			end
		end 

		-- generate type
		local random = love.math.random(0, 1)

		local type = ""

		data["target"] = player
	
		if random == 0 then
			type = "homing"
		elseif random == 1 then
			type = "ramming"

			data["angle"] = love.math.random(0, 360)
		end

		return enemyFactory.new(type, data)
end

function love.update(dt)

	-- update all enemies
	for k,v in pairs(enemyTable) do
		v:update(dt)

		-- delete if dead
		if not v.alive then
			enemyTable.k = nil
		end
	end

	player:update(dt)
end

function love.draw()
	player:draw()
	
	for _,v in pairs(enemyTable) do
		v:draw()
	end
end
