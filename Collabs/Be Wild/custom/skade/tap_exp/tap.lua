--class FLMC
local Tap = {}
Tap.__index = Tap

local colNear = {201/255,7/255,197/255}
local colSCrit = {214/255,214/255,214/255}
local colCrit = {177/255,172/255,17/255}

---@param isFx boolean
function Tap.new(isFx)
	local s = { --self
		sm = track.CreateShadedMeshOnTrack("tap",background.GetPath().."skade/tap_exp/"),
		animLen = .225,
		w = mdv.BT_W,
		h = mdv.BT_H,
		isFx = isFx,
		count = 3,
		timings = {},
		ratings = {},
	}

	s.sm:SetPrimitiveType(s.sm.PRIM_TRIFAN)
	s.sm:SetBlendMode(s.sm.BLEND_ADD)

	local sx = 2
	local sy = 4
	if isFx then
		s.w = mdv.FX_W
		s.h = mdv.FX_H
		s.count = 1
	end

	s.sm:SetData({
		{{-s.w*.5*sx,-s.h*.5*sy},{0,0}},
		{{ s.w*.5*sx,-s.h*.5*sy},{1,0}},
		{{ s.w*.5*sx, s.h*.5*sy},{1,1}},
		{{-s.w*.5*sx, s.h*.5*sy},{0,1}},
	})
	
	for i=0,s.count do
		s.timings[i] = 0
		s.ratings[i] = 0
	end

	if not isFx then
		s.sm:AddTexture("u_cl",background.GetPath().."skade/tap_exp/button_tap.png")
	else
		s.sm:AddTexture("u_cl",background.GetPath().."skade/tap_exp/fxbutton_tap.png")
	end

	return setmetatable(s, Tap)
end

function Tap:render(dt)
	local s = self

	for i=0,s.count do
		--TODO check ma for hold or bt?

		s.timings[i] = s.timings[i] - dt

		-- check holds
		if s.isFx then
			if gameplay.noteHeld[i+4+1] then
				s.timings[i] = s.animLen
			end
		else
			if gameplay.noteHeld[i+1] then
				s.timings[i] = s.animLen
			end
		end

		local offset = i
		local btx = i
		if s.isFx then
			offset = offset+1
			btx = btx+4
		end
		local t = mod.evaluateModTransform({-s.w*1.5+offset*s.w,0,0},0,mdv.MA_BT,btx)
		t = {
			1,0,0,t[4],
			0,0,1,t[8],
			0,1,0,t[12],
			0,0,0,1,
		}
		-- scale with distance
		local len = t[8]+t[12]
		len = 1+math.log(len+1,2)*.25
		t = gfx.MultMat(t,gfx.GetScaleMat({len,len,len}))
		--t = gfx.MultMat(gfx.GetRotMat({90,0,0}),t)
		s.sm:SetParamMat4("u_t",t)

		--TODO scrit
		--if s.ratings[i] == 2 then
		--	s.sm:SetParamVec3("u_col",table.unpack(colSCrit))
		--end
		if s.ratings[i] == 2 then
			s.sm:SetParamVec3("u_col",table.unpack(colCrit))
		end
		if s.ratings[i] == 1 then
			s.sm:SetParamVec3("u_col",table.unpack(colNear))
		end
		--if s.ratings[i] == 0 then
		--	s.sm:SetParamVec3("u_col",0,0,0)
		--end

		local op = s.timings[i]/s.animLen
		s.sm:SetParam("u_opacity",op*2)
		s.sm:Draw()
		--gfx.ForceRender()
	end
end

return Tap