local function setShareGlobalTable(name,t)
	local idx = 1
	for index, value in ipairs(t) do
		globals[name..tostring(idx)] = value
		idx = idx + 1
	end
end

local function getShareGlobalTable(name,len)
	local t = {}
	local idx = 1
	for i = 1,len do
		t[idx] = globals[name..tostring(idx)]
		idx = idx + 1
	end
	return t
end

return {
	set = setShareGlobalTable,
	get = getShareGlobalTable,
}