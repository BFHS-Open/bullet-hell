local config = require("lib.config")
local Sprite = require("lib.sprite")
local Manager = require("manager")
local Home = require("states.home")
local manager
local background

function love.load()
	love.keyboard.setKeyRepeat(true)
	love.filesystem.setIdentity("catnapped_in_space")

	-- global for convenience
	Time = 0

	-- global fonts
	BigFont = love.graphics.newFont("assets/fonts/KleeOne-SemiBold.ttf", 36)
	RegularFont = love.graphics.newFont("assets/fonts/KleeOne-SemiBold.ttf", 24)

	-- global sounds
	SoundCatMeow = love.audio.newSource("assets/sounds/cat-meow.mp3", "static")
	SoundCatPurr = love.audio.newSource("assets/sounds/cat-purr-meow.mp3", "static")
	SoundCatFunny = love.audio.newSource("assets/sounds/funny-meow.mp3", "static")
	BackgroundMusic = love.audio.newSource("assets/sounds/background_music.mp3", "stream")
	BackgroundMusic:setLooping(true)
	BackgroundMusic:setVolume(0.4)

	love.audio.play(BackgroundMusic)

	background = Sprite.new("/assets/images/background.png", config.dims * 12 / 7)
	local info = love.filesystem.getInfo("save.txt", "file")
	local data = nil
	if info then
		local message
		data, message = love.filesystem.read("save.txt")
		if data == nil then
			print(message)
			love.event.quit()
			return
		end
	end
	manager = Manager.new(Home, data)
end

function love.update(dt)
	Time = Time + dt
	manager:update(dt)
end

function love.draw()
	local step = Time / 60
	background:draw(config.dims:scale(
		1/2 + 5/28 * 2 * math.sin(step),
		1/2 + 5/28 * math.sin(2 * step)
	))
	manager:draw()
end

function love.keypressed(key, scancode, isrepeat)
	manager:onPress(key, scancode, isrepeat)
end

function love.textinput(text)
	manager:onText(text)
end

function love.wheelmoved(x, y)
	manager:onWheel(x, y)
end

function love.quit()
	if manager == nil then
		return
	end
	local data = manager:save()
	local success, message = love.filesystem.write("save.txt", data)
	if not success then
		print(data)
		print(message)
	end
end
