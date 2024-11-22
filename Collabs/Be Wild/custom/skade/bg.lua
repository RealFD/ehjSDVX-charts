--TODO(skade)

--TODO milchstrasse maybe?

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

	starfield = track.CreateShadedMeshOnTrack("starfield",P_SKADE.."funkeln/"),
	cleanup = function(s)

	end,
	init = function(s)
		loadDefMod('lsrScale')
		loadDefMod('reverse')
		loadDefMod('starTarget')
		loadDefMod('spinImpact')
		loadDefMod('freeze')
		loadDefMod('baseT')
		loadDefMod('globalT')
		loadDefMod('helixPierce')
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

		s.starfield:SetPrimitiveType(s.starfield.PRIM_TRIFAN)
		s.starfield:SetBlendMode(s.starfield.BLEND_ADD)
		s.starfield:SetData({
			{{-1,-1, 0},{0,0}},
			{{ 1,-1, 0},{1,0}},
			{{ 1, 1, 0},{1,1}},
			{{-1, 1, 0},{0,1}},
		})
		mod.setDepthTest(mdv.MA_TRK,true)
		s.starfield:SetScreenSpace(false)
		s.starfield:SetDepthTest(true)
		s.starfield:SetDepthMask(false)
		s.starfield:AddTexture("u_tex",P_SKADE.."funkeln/starfield.png")
		s.starfieldTimer = 0
	end,
	render_bg = function(s,deltaTime)
	end,
	render_bfg = function(s,deltaTime)
		--gfx.SetfbTexture("FBTest",0,0)
	end,
	render_fg = function(s,deltaTime)
		local currBeat = background.GetBeat()
		local beat = (currBeat+background.GetBarTime())
		if Ubgfs.alpha < 1 then
			--s.particleSystem:render(deltaTime)
			s.r_starfield(s,deltaTime)
		end
		tap:render(deltaTime)
		tapFX:render(deltaTime)
	end,
	render_ffg = function(s,deltaTime)
		--s.ssqTest:Draw()
	end,
	r_starfield = function(s,deltaTime)
		if Ubgfs.alpha < 1 then
			s.starfieldTimer = s.starfieldTimer + deltaTime
			
			for i=1,4 do
				local sz = math.exp(i)
				--local move =math.sin(beat)*2
				local move = math.log(s.starfieldTimer*20.)*.5
				local t = {
					10+sz,0,0,0,
					0,10+sz,0,0,
					0,0,1,move-sz,
					0,0,0,1,
				}
				--t = gfx.MultMat(gfx.GetRotMat({0,0,0}),t)
				s.starfield:SetParam("u_i",i*1.2+3)
				s.starfield:SetParamMat4("u_t",t)

				--s.starfield:SetParam("u_time",p.time)
				s.starfield:Draw()
			end
		else
			s.starfieldTimer = 0
		end
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