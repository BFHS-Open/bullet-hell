local List = {}
List.__index = List

function List.new()
	local list = setmetatable({}, List)
	-- can "eventually" overflow, but not until the precision of doubles is exceeded,
	-- and at that point something else fundamental probably overflowed
	list.first = 1
	list.last = 0
	return list
end

function List:len()
	return self.last - self.first + 1
end

function List:front()
	return self[self.first]
end

function List:pushFront(x)
	self.first = self.first - 1
	self[self.first] = x
end

function List:popFront()
	local x = self[self.first]
	self[self.first] = nil
	self.first = self.first + 1
	return x
end

function List:back()
	return self[self.last]
end

function List:pushBack(x)
	self.last = self.last + 1
	self[self.last] = x
end

function List:popBack()
	local x = self[self.last]
	self[self.last] = nil
	self.last = self.last - 1
	return x
end

return List
