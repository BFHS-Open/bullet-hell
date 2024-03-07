local Player = require("entities.player")
local StraightEnemy = require("entities.straight-enemy")
local HomingEnemy = require("entities.homing-enemy")
local LockonEnemy = require("entities.lockon-enemy")
local LaserEnemy = require("entities.laser-enemy")
local Point2d = require("lib.point2d")
local List = require("lib.list")
local config = require("lib.config")
local utils = require("lib.utils")
local Sprite = require("lib.sprite")
local Set = require("lib.set")
local TextInput = require("ui.text-input")

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

local warning = Sprite.new("/assets/images/warning.png", Point2d.rect(10, 10))

local Game = {}
Game.__index = Game

function Game.new(manager)
	local game = setmetatable({}, Game)

	game.state = 0

	game.manager = manager
	game.player = Player.new(Point2d.rect(50, 50))
	game.enemies = Set.new()
	game.spawnInterval = .1
	game.cooldown = 0
	game.queue = List.new()
	-- simulation time is tracked separately from global time
	game.time = 0

	game.textInput = TextInput.new()

	return game
end

function Game:onPress(...)
	if self.player.alive then
		return
	end
	local key = ...
	if key ~= "return" then
		self.textInput:onPress(...)
		return
	end
	self.score.name = self.textInput.content:match("^%s*(.-)%s*$")
	self.manager:moveTo("home", "game")
end

function Game:onText(...)
	if self.player.alive then
		return
	end
	self.textInput:onText(...)
end

function Game:queueEnemy()
	self.queue:pushBack({
		time = self.time,
		position = randomSpawnPosition()
	})
end

local enemies = {
	{value = HomingEnemy, weight = 1},
	{value = StraightEnemy, weight = 10},
	{value = LockonEnemy, weight = 1},
	{value = LaserEnemy, weight = 1},
}

local function weightedRandom(options)
	local totalWeight = 0
	for _, option in ipairs(options) do
		totalWeight = totalWeight + option.weight
	end

	local rand = math.ceil(love.math.random() * totalWeight)

	for _, option in ipairs(options) do
		rand = rand - option.weight
		if rand <= 0 then
			return option.value
		end
	end
end

function Game:randomEnemy(position, target)
	local data = {
		position = position,
		target = target
	}

	-- generate type
	local Enemy = weightedRandom(enemies)

	data.angle = (target.position - data.position):angle()
		+ (-1/8 + 1/4 * love.math.random()) * math.pi * 2

	return Enemy.new(data, self)
end

local spawnDelay = 1
local targetSpawnInterval = 2

function Game:update(dt)
	if self.state == 0 then
		self.time = self.time + dt

		-- queue spawns
		self.cooldown = self.cooldown - dt

		while self.cooldown < 0 do
			self.cooldown = self.cooldown + self.spawnInterval
			self.spawnInterval = utils.lerp(self.spawnInterval, targetSpawnInterval, .1)
			self:queueEnemy()
		end

		-- resolve spawns
		while self.queue:len() ~= 0 and (self.time - self.queue:front().time > spawnDelay) do
			self.enemies:insert(self:randomEnemy(self.queue:popFront().position, self.player))
		end

		-- update all enemies
		for enemy in self.enemies:pairs() do
			enemy:update(dt)

			-- delete if dead
			if not enemy.alive then
				-- setting to nil while traversing is allowed
				self.enemies:remove(enemy)
			end
		end

		self.player:update(dt)

		if self.player.alive then
			return
		end
		self.score = {
			time = self.time,
			timestamp = os.time(),
		}
		local scores = self.manager.scores
		table.insert(scores, self.score)
		table.sort(
			scores,
			function (a, b)
				if a.time > b.time then
					return true
				elseif a.time < b.time then
					return false
				end
				if a.timestamp < b.timestamp then
					return true
				end
				return false
			end
		)
		local rank
		for i,v in ipairs(scores) do
			if v == self.score then
				rank = i
				break
			end
		end
		if rank == 1 then
			self.message = "NEW HIGH SCORE!!!"
		elseif (rank - 1) / #scores < 1 / 4 then
			self.message = string.format("Rank %d of %d!!", rank, #scores)
		else
			self.message = string.format("Top %d%%!", math.ceil(rank / #scores * 100))
		end
		self.state = 1
	end
end

function Game:draw()
	self.player:draw()

	for enemy in self.enemies:pairs() do
		enemy:draw()
	end

	for i = self.queue.first, self.queue.last do
		local item = self.queue[i]
		local fadeIn = math.max(1 - (self.time - item.time) / spawnDelay * 4, 0)
		local fadeOut = math.min(1 - (item.time + spawnDelay - self.time) / spawnDelay * 2, 1)
		warning:draw(utils.moveInBounds(item.position, 5), 1 + fadeIn, (1 - fadeIn) * (1 - fadeOut))
	end

	if self.state == 0 then
		-- TODO: HH:MM:SS.SS
		utils.drawText(string.format("%.2f", self.time), BigFont, 95, 95, -1, -1)
	else
		utils.drawText(string.format("Score: %.2f", self.time), BigFont, 50, 40, 0, 0)
		utils.drawText(self.message, BigFont, 50, 46, 0, 0)
		utils.drawText("Name:", BigFont, 50, 54, 0, 0)
		love.graphics.setColor(3/4, 3/4, 1)
		self.textInput:draw(Point2d.rect(50, 60), Point2d.rect(0, 0))
		if self.textInput.content ~= "" then
			love.graphics.setColor(1, 1, 1, 1/2)
			utils.drawText("enter to confirm", RegularFont, 50, 70, 0, 0)
		end
		love.graphics.setColor(1, 1, 1)
	end
end

return Game
