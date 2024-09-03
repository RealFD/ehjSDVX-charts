--TODO(skade)

local function loadDefMod(fileName)
	dofile(background.GetPath().."skade/mods/"..fileName..".lua")
end
local function loadMod(fileName)
	dofile(background.GetPath().."skade/"..fileName..".lua")
end

local bg = {
	cleanup = function(s)

	end,
	init = function(s)
		loadDefMod('lsrScale')
		loadMod('mods')
	end,
	render_bg = function(s,deltaTime)
		
	end,
	render_fg = function(s,deltaTime)
		
	end,
	render_ffg = function(s,deltaTime)
		
	end,
}

return bg