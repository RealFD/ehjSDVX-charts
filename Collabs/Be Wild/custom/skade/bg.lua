--TODO(skade)

P_SKADE = background.GetPath().."skade/"

local function loadDefMod(fileName)
	dofile(P_SKADE.."mods/"..fileName..".lua")
end
local function loadMod(fileName)
	dofile(P_SKADE..fileName..".lua")
end

local resx, resy = game.GetResolution()

local TAP = require('skade/tap_exp/tap')
local tap = TAP.new(false)
local tapFX = TAP.new(true)

local bg = {
	particleSystem = require('skade/funkeln/funkeln'),
	FBTexTest = gfx.CreatefbTexture("FBTest",resx,resy),
	ssqTest = gfx.CreateShadedMesh("ssq",P_SKADE.."ssq/"),

	cleanup = function(s)

	end,
	init = function(s)
		loadDefMod('lsrScale')
		loadDefMod('reverse')
		loadDefMod('starTarget')
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
	end,
	render_bfg = function(s,deltaTime)
		--gfx.SetfbTexture("FBTest",0,0)
	end,
	render_fg = function(s,deltaTime)
		if Ubgfs.alpha < 1 then
			s.particleSystem:render(deltaTime)
		end
		tap:render(deltaTime)
		tapFX:render(deltaTime)
	end,
	render_ffg = function(s,deltaTime)
		--s.ssqTest:Draw()
	end,
}


function bg:button_hit(btn, rating, delta)
	if rating == 1 or rating == 2 then
		if btn < 4 then
			tap.timings[btn] = tap.animLen
			tap.ratings[btn] = rating
		else
			tapFX.timings[btn-4] = tapFX.animLen
			tapFX.ratings[btn-4] = rating
		end
	end
end

return bg