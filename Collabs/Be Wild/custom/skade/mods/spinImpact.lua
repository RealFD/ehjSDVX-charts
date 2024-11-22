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
	mod.setModSpline(0,spinOffset)
	mod.setModSpline(1,spinOffset)
end}

xero.setdefault {0,"spinImpactP"}
xero.linkmod{"spinImpact",{"spinImpactR","spinImpactRT","spinImpactRT2"}}

--spinImpactSlam
mod.setEModSplineType(mdv.MST_X)
mod.addMod("spinImpactSlam",mdv.MT_T)
mod.setEMod("spinImpactSlam")
mod.createSpline(128)
mod.setModProperty(mdv.ML_ALL,mdv.MA_ALL)
mod.setModLayer(0)
local v = {}

xero.definemod {"spinImpactSlam","spinImpactSlamP", function(b,p)
	local spinOffset = mdv.TRACK_H*.35
	mod.setEModSplineType(mdv.MST_X)
	mod.setEMod("spinImpactSlam")

	local _, _, trackTimer = background.GetTiming()

	for i=0,127 do
		local ii = i/127
		local ip = 1.25/((2*ii)*(2*ii)+1)-.25
		local sixh = (trackTimer % (1/60))
		v[i] = (sixh*2-1/60) * ip * 10. * p
	end
	mod.setModSplineT(v)
end}

xero.setdefault {0,"spinImpactSlamP"}
xero.linkmod{"spinImpactSlam",{"spinImpactSlam"}}
