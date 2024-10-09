
mod.setEModSplineType(mdv.MST_Y)
mod.addMod("freeze",mdv.MT_T)
mod.setEMod("freeze")
mod.createSpline(2)
mod.setModProperty(mdv.ML_ALL,mdv.MA_ALL)---mdv.MA_TRK)
mod.setModLayer(2)

xero.definemod {"freeze","freezeP","freezeS", function(b,p,s)
	local currBeat = background.GetBarTime()*s%1
	local viewRangeMeasure = background.GetViewRangeMeasure()
	mod.setEModSplineType(mdv.MST_Y)
	mod.setEMod("freeze")
	for i=0,1 do
		local yOffset = currBeat/viewRangeMeasure/s
		--local yOffset = i/1
		mod.setModSpline(i,yOffset*p*mdv.TRACK_H)
	end
end}

xero.setdefault {0,"freezeP"}
xero.setdefault {1,"freezeS"}

xero.linkmod{"freeze",{"freeze"}}
