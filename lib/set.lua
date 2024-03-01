local Set = {}
Set.__index = Set

function Set.new()
	local set = setmetatable({}, Set)
	-- sub-table to avoid polluting the set with a metatable
	set.items = {}
	return set
end

function Set:has(x)
	return self.items[x] ~= nil
end

function Set:insert(x)
	self.items[x] = true
end

function Set:remove(x)
	self.items[x] = nil
end

function Set:pairs()
	return pairs(self.items)
end

return Set
