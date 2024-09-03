--useful matrix functions
local matN = function(m)
	for i=1,16 do
		m[i] = m[i] / m[16]
	end
end
local printM = function(m)
	for i=0,3 do
		game.Print(tostring(m[i*4+1]).."	"..tostring(m[i*4+2]).."	"..tostring(m[i*4+3]).."	"..tostring(m[i*4+4]).."	")
	end
end

local vec3NRM = function(v)
	local l = v[1]+v[2]+v[3]
	return {v[1]/l,v[2]/l,v[3]/l}
end

return {
	matN = matN,
	printM = printM,
	vec3NRM = vec3NRM,
}
