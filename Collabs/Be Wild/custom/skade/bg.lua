--TODO(skade)

P_SKADE = background.GetPath().."skade/"

local function loadDefMod(fileName)
	dofile(P_SKADE.."mods/"..fileName..".lua")
end
local function loadMod(fileName)
	dofile(P_SKADE..fileName..".lua")
end

local resx, resy = game.GetResolution()

local bg = {
	particleSystem = require('skade/funkeln/funkeln'),
	FBTexTest = gfx.CreatefbTexture("FBTest",resx,resy),
	ssqTest = gfx.CreateShadedMesh("ssq",P_SKADE.."ssq/"),

	cleanup = function(s)

	end,
	init = function(s)
		loadDefMod('lsrScale')
		loadMod('mods')
		s.particleSystem:init()

		s.ssqTest:AddfbTexture("u_bg","FBTest")
		local ssqDat = {
			{{-1,-1},{0,0}},
			{{1,-1},{1,0}},
			{{1,1},{1,1}},
			{{-1,1},{0,1}},
			{{-1,-1},{0,0}},
			{{1,1},{1,1}},
		}
		--s.ssqTest:SetBlendMode(s.ssqTest.BLEND_ADD)
		s.ssqTest:SetData(ssqDat)
	end,
	render_bg = function(s,deltaTime)
		--s.particleSystem:render(deltaTime)
	end,
	render_bfg = function(s,deltaTime)
		--gfx.SetfbTexture("FBTest",0,0)
	end,
	render_fg = function(s,deltaTime)
		
	end,
	render_ffg = function(s,deltaTime)
		--s.ssqTest:Draw()
	end,
}

return bg