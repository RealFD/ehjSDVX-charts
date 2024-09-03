mod.setEModSplineType(mdv.MST_X)
mod.addMod("lsrScaleX1",mdv.MT_S)
mod.setEMod("lsrScaleX1")
mod.createSpline(2)
mod.setModProperty(mdv.ML_ALL,mdv.MA_ALL)

mod.addMod("lsrScaleX2",mdv.MT_S)
mod.setEMod("lsrScaleX2")
mod.setModLayer(1)
mod.createSpline(2)
mod.setModProperty(mdv.ML_ALL,mdv.MA_ALL)

xero.definemod {"lsrScale","lsrScaleP", function(b,p)
	local val = p--/50
	mod.setEModSplineType(mdv.MST_X)
	mod.setEMod("lsrScaleX1")
	for i=0,1 do
		mod.setModSpline(i,1/val)
	end
	mod.setEMod("lsrScaleX2")
	for i=0,1 do
		mod.setModSpline(i,val)
	end
end}

xero.setdefault{1,"lsrScaleP"}

xero.linkmod{"lsrScale",{"lsrScaleX1","lsrScaleX2"}}
