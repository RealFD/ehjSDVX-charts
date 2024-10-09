local Tap_rec = {}
Tap_rec.__index = Tap_rec

---@param isFx boolean
function Tap_rec.new(isFx)
    local s = {
        sm = track.CreateShadedMeshOnTrack("tap_rec",background.GetPath().."realfd/tap_recep/"),
        isFx = isFx,
        w = mdv.BT_W,
		h = mdv.BT_H,
        count = 3,
    }

	s.sm:SetPrimitiveType(s.sm.PRIM_TRIFAN)
	--s.sm:SetBlendMode(s.sm.BLEND_ADD)

    local sx = 1
    local sy = 1
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

	if not isFx then
		s.sm:AddTexture("u_cl",background.GetPath().."realfd/tap_recep/button_receptor.png")
	else
		s.sm:AddTexture("u_cl",background.GetPath().."realfd/tap_recep/fxbutton_receptor.png")
	end

    return setmetatable(s,Tap_rec)
end

function Tap_rec:render(dt)
    local s = self

    for i=0,s.count do
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
        local len = t[8]+t[12]
		len = 1+math.log(len+1,2)*.25
		t = gfx.MultMat(t,gfx.GetScaleMat({len,len,len}))
        s.sm:SetParamMat4("u_t",t)

        s.sm:Draw()
    end
end

return Tap_rec