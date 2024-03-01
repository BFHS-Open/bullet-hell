local Set = require("lib.set")

local Keymapper = {}
Keymapper.__index = Keymapper

function Keymapper.new()
	local keymapper = setmetatable({}, Keymapper)
	keymapper.pressed = {}
	return keymapper
end

function Keymapper:activate()
	function love.keypressed(key, scancode, isrepeat)
		if isrepeat then
			return
		end
		local callbacks = self.pressed[key]
		if callbacks == nil then
			return
		end
		for callback in callbacks:pairs() do
			callback()
		end
	end
end

function Keymapper:onPress(key, callback)
	if self.pressed[key] == nil then
		self.pressed[key] = Set.new()
	end
	self.pressed[key]:insert(callback)
end

function Keymapper:offPress(key, callback)
	self.pressed[key]:remove(callback)
	if #self.pressed[key] == 0 then
		self.pressed[key] = nil
	end
end

return Keymapper
