-- spin around certain point
mod.setEModSplineType(mdv.MST_Y)
mod.addMod("spinImpactRT",mdv.MT_T)
mod.setEMod("spinImpactRT")
mod.createSpline(2)
mod.setModProperty(mdv.ML_ALL,mdv.MA_ALL)
mod.setModLayer(1)

mod.setEModSplineType(mdv.MST_X)
mod.addMod("spinImpactR",mdv.MT_R)
mod.setEMod("spinImpactR")
mod.createSpline(2)
mod.setModProperty(mdv.ML_ALL,mdv.MA_ALL)
mod.setModLayer(2)

-- revert trans but keep up
mod.setEModSplineType(mdv.MST_Y)
mod.addMod("spinImpactRT2",mdv.MT_T)
mod.setEMod("spinImpactRT2")
mod.createSpline(2)
mod.setModProperty(mdv.ML_ALL,mdv.MA_ALL)
mod.setModLayer(2)

xero.definemod {"spinImpact","spinImpactP", function(b,p)

	local spinOffset = mdv.TRACK_H*.35
	mod.setEModSplineType(mdv.MST_Y)
	mod.setEMod("spinImpactRT")
	mod.setModSpline(0,-spinOffset)
	mod.setModSpline(1,-spinOffset)
	mod.setEModSplineType(mdv.MST_X)
	mod.setEMod("spinImpactR")
	mod.setModSpline(0,360*p)
	mod.setModSpline(1,360*p)
	mod.setEModSplineType(mdv.MST_Y)
	mod.setEMod("spinImpactRT2")
	mod.setModSpline(0,(spinOffset))
	mod.setModSpline(1,(spinOffset))
end}

xero.setdefault {0,"spinImpactP"}
xero.linkmod{"spinImpact",{"spinImpactT","spinImpactRotT","spinImpactRotT2"}}

