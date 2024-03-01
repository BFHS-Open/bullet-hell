local playerFactory = require("player")
local enemyFactory = require("enemy")
local Point2d = require("lib.point2d")
local List = require("lib.list")
local config = require("lib.config")
local utils = require("lib.utils")
local Sprite = require("lib.sprite")

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

local warning = Sprite.new("/assets/gold.jpg", Point2d.rect(5, 5))

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
		enemy = CreateRandomEnemy(self.player)
	})
end

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
		self.cooldown = self.cooldown + 1
		self:queueEnemy()
	end

	-- resolve spawns
	while self.queue:len() ~= 0 and (self.time - self.queue:front().time > 1/2) do
		table.insert(self.enemies, self.queue:popFront().enemy)
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
		warning:draw(self.queue[i].enemy.position)
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
