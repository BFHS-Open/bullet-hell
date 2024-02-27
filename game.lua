local playerFactory = require("player")
local enemyFactory = require("enemy")
local Point2d = require("lib.point2d")
local config = require("config")
local utils = require("lib.utils")

local game = {}
game.__index = game

function game.load()
	Player = playerFactory.new(Point2d:rect(50, 50))
	EnemyTable = {}
	cooldown = 0
	counter = 0

	for i = 1, 6 do
		CreateRandomEnemy(Player)
	end
end

function CreateRandomEnemy(target)
	local data = { target = target }

	-- flip coin for axis
	if love.math.random(0, 1) then
		-- x axis, flip for left or right side

		data.position = Point2d:rect(
			love.math.random(0, 1) * config.dims.x,
			utils.clamp(love.math.randomNormal(1 / 4, 1 / 2), 0, 1) * config.dims.y
		)
	else
		-- y axis, flip for top or bottom

		data.position = Point2d:rect(
			utils.clamp(love.math.randomNormal(1 / 4, 1 / 2), 0, 1) * config.dims.x,
			love.math.random(0, 1) * config.dims.y
		)
	end

	-- generate type
	local type = ({
		"homing",
		"ramming",
	})[love.math.random(2)]

	if type == "ramming" then
		data.angle = love.math.random() * math.pi * 2
	end
	
	counter = counter + 1
	EnemyTable[counter] = enemyFactory.new(type, data)
end

function game.update(dt)
	-- update all enemies
	cooldown = math.max(cooldown-dt, 0)

	if cooldown == 0 then
		cooldown = 1
		CreateRandomEnemy(Player)
	end

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

function game.draw()
	Player:draw()

	for _, v in ipairs(EnemyTable) do
		v:draw()
	end
end

return game
