local playerFactory = require("player")
local enemyFactory = require("enemy")
local Point2d = require("lib.point2d")
local config = require("lib.config")
local utils = require("lib.utils")

local function CreateRandomEnemy(target)
	local data = { target = target }

	-- flip coin for axis
	if love.math.random(0, 1) then
		-- x axis, flip for left or right side

		data.position = config.dims:scale(
			love.math.random(0, 1),
			utils.clamp(love.math.randomNormal(1 / 4, 1 / 2), 0, 1)
		)
	else
		-- y axis, flip for top or bottom

		data.position = config.dims:scale(
			utils.clamp(love.math.randomNormal(1 / 4, 1 / 2), 0, 1),
			love.math.random(0, 1)
		)
	end

	-- generate type
	local type = ({
		"homing",
		"ramming",
	})[love.math.random(2)]

	if type == "ramming" then
		data.angle = (target.position - data.position):angle() 
			+ (-1/8 + 1/4 * love.math.random()) * math.pi * 2
	end

	return enemyFactory.new(type, data)
end

local Game = {}
Game.__index = Game

function Game.new()
	local game = setmetatable({}, Game)

	game.player = playerFactory.new(Point2d.rect(50, 50))
	game.enemies = {}
	game.cooldown = 0

	for _ = 1, 6 do
		game:spawnEnemy()
	end

	return game
end

function Game:spawnEnemy()
	table.insert(self.enemies, CreateRandomEnemy(self.player))
end

function Game:update(dt)
	if not self.player.alive then
		if love.keyboard.isDown("return") then
			return "menu"
		end
		return
	end

	-- update all enemies
	self.cooldown = self.cooldown - dt

	while self.cooldown < 0 do
		self.cooldown = self.cooldown + 1
		self:spawnEnemy()
	end

	for i, enemy in ipairs(self.enemies) do
		enemy:update(dt)

		-- delete if dead
		if not enemy.alive then
			-- fast delete by moving the last element to i
			local other = table.remove(self.enemies)
			if i <= #table then
				table[i] = other
			end
		end
	end

	self.player:update(dt)
end

function Game:draw()
	self.player:draw()

	for _, v in ipairs(self.enemies) do
		v:draw()
	end

	if not self.player.alive then
		-- TODO: actual end screen
		local screenX, screenY = love.window.getMode()
		love.graphics.print("game over", BigFont, screenX / 2 - 100, screenY / 2 - 120)
	end
end

return Game
