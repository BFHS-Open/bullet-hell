local playerFactory = require("player")
local enemyFactory = require("enemy")
local Point2d = require("lib.point2d")
local List = require("lib.list")
local config = require("lib.config")
local utils = require("lib.utils")
local Sprite = require("lib.sprite")

local function randomSpawnPosition()
	if love.math.random(2) == 1 then
		-- x axis, flip for left or right side

		return config.dims:scale(
			love.math.random(0, 1),
			utils.clamp(love.math.randomNormal(1 / 4, 1 / 2), 0, 1)
		)
	else
		-- y axis, flip for top or bottom

		return config.dims:scale(
			utils.clamp(love.math.randomNormal(1 / 4, 1 / 2), 0, 1),
			love.math.random(0, 1)
		)
	end
end

local function randomEnemy(position, target)
	local data = {
		position = position,
		target = target
	}

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

local warning = Sprite.new("/assets/warning.png", Point2d.rect(10, 10))

local Game = {}
Game.__index = Game

function Game.new()
	local game = setmetatable({}, Game)

	game.player = playerFactory.new(Point2d.rect(50, 50))
	game.enemies = {}
	game.cooldown = 0
	game.queue = List.new()
	-- simulation time is tracked separately from global time
	game.time = 0

	for _ = 1, 6 do
		game:queueEnemy()
	end

	return game
end

function Game:queueEnemy()
	self.queue:pushBack({
		time = self.time,
		position = randomSpawnPosition()
	})
end

local spawnTime = 1
local spawnDelay = 1/2

function Game:update(dt)
	if not self.player.alive then
		if love.keyboard.isDown("return") then
			return "menu"
		end
		return
	end

	self.time = self.time + dt

	-- queue spawns
	self.cooldown = self.cooldown - dt

	while self.cooldown < 0 do
		self.cooldown = self.cooldown + spawnTime
		self:queueEnemy()
	end

	-- resolve spawns
	while self.queue:len() ~= 0 and (self.time - self.queue:front().time > spawnDelay) do
		table.insert(self.enemies, randomEnemy(self.queue:popFront().position, self.player))
	end

	-- update all enemies
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

	for i = self.queue.first, self.queue.last do
		local item = self.queue[i]
		local fadeIn = math.max(1 - (self.time - item.time) / spawnDelay * 4, 0)
		local fadeOut = math.min(1 - (item.time + spawnDelay - self.time) / spawnDelay * 2, 1)
		warning:draw(utils.inBounds(item.position, 5), 1 + fadeIn, (1 - fadeIn) * (1 - fadeOut))
	end

	if self.player.alive then
		-- UI
		utils.drawText(string.format("%.2f", self.time), BigFont, 95, 95, -1, -1)
	else
		-- TODO: actual end screen
		utils.drawText(string.format("Score: %.2f", self.time), BigFont, 50, 50, 0, 0)
	end
end

return Game
