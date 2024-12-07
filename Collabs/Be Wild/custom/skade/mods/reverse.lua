mod.setEModSplineType(mdv.MST_Y)
mod.addMod("reverseT",mdv.MT_T)
mod.setEMod("reverseT")
mod.createSpline(2)
mod.setSplineProperty(0,-1,mdv.SIT_LIN)
mod.setSplineProperty(1,2,mdv.SIT_LIN)
mod.setModProperty(mdv.ML_ALL,mdv.MA_ALL)
mod.setModLayer(4)

mod.addMod("reverseS",mdv.MT_S)
mod.setEMod("reverseS")
mod.createSpline(2)
mod.setSplineProperty(0,-1,mdv.SIT_LIN)
mod.setSplineProperty(1,2,mdv.SIT_LIN)
mod.setModProperty(mdv.ML_ALL,mdv.MA_ALL)
mod.setModLayer(4)

xero.definemod {"reverse","reverseP", function(b,p)
	local p01 = 0
	if p > 0 then
		p01 = 2*math.abs(math.fmod(p*.5,1)-math.fmod(p,1)) -- 0 to 1
	else
		p01 = p
	end

	mod.setEModSplineType(mdv.MST_Y)
	mod.setEMod("reverseT")
	mod.setModSpline(0,(mdv.TRACK_H)*p01)
	mod.setModSpline(1,(mdv.TRACK_H)*p01)
	mod.setEMod("reverseS")
	mod.setModSpline(0,-(p01*2-1))
	mod.setModSpline(1,-(p01*2-1))
end}

xero.setdefault {0,"reverseP"}
xero.setdefault {1,"reverseS"}
xero.linkmod{"reverse",{"reverseT","reverseS"}}
