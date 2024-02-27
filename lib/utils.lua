local utils = {}

function utils.clamp(a, min, max)
	return math.min(math.max(a, min), max)
end

return utils
