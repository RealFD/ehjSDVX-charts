mod.addMod("starTarget",mdv.MT_T)
mod.setEMod("starTarget")
for i=0,2 do
	mod.setEModSplineType(mdv.MST_X+i)
	mod.createSpline(2)
	mod.setSplineProperty(0,0,mdv.SIT_COS)
	mod.setSplineProperty(1,1,mdv.SIT_COS)
end
mod.setModProperty(mdv.ML_ALL,mdv.MA_ALL-mdv.MA_LS)
mod.setModLayer(0)

xero.definemod {"starTarget","starTargetP", function(b,p)
	mod.setEModSplineType(mdv.MST_Y)
	mod.setEMod("starTarget")
	for i=0,2 do
		mod.setEModSplineType(mdv.MST_X+i)
		mod.setModSpline(0,-1)
		mod.setModSpline(1,0)
	end
end}

xero.setdefault {0,"starTargetP"}
xero.linkmod{"starTarget",{"starTarget"}}
