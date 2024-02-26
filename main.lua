local playerFactory = require("player")
local enemyFactory = require("enemy")
local Point2d = require("point2d")

function love.load()
	love.graphics.setNewFont(12)
	love.graphics.setBackgroundColor(255, 255, 255)
	love.window.setMode(700, 700)

	Player = playerFactory.new(Point2d:rect(350, 350))
	EnemyTable = {}

	for i = 1, 6 do
		EnemyTable[i] = CreateRandomEnemy(Player)
	end
end

function CreateRandomEnemy(target)
		local screenX, screenY = love.window.getMode()

		local data = { target = target }

		-- flip coin for axis
		if love.math.random(0, 1) then
			-- x axis, flip for left or right side

			data.position = Point2d:rect(
				love.math.random(0, 1) * screenX,
				love.math.randomNormal(1/4, 1/2) * screenY
			)
		else
			-- y axis, flip for top or bottom

			data.position = Point2d:rect(
				love.math.randomNormal(1/4, 1/2) * screenX,
				love.math.random(0, 1) * screenY
			)
		end

		-- generate type
		local type = ({
			"homing",
			"ramming"
		})[love.math.random(2)]

		if type == "ramming" then
			data.angle = love.math.random() * 360
		end

		return enemyFactory.new(type, data)
end

function love.update(dt)

	-- update all enemies
	for i, enemy in ipairs(EnemyTable) do
		enemy:update(dt)

		-- delete if dead
		if not enemy.alive then
			-- fast delete by moving the last element to i
			local other = table.remove(EnemyTable)
			if i <= #table then
				table[i] = other
			end
		end
	end

	Player:update(dt)
end

function love.draw()
	Player:draw()

	for _,v in ipairs(EnemyTable) do
		v:draw()
	end
end
