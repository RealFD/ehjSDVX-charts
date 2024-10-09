mod.setEModSplineType(mdv.MST_Z)
mod.addMod("helixPierce",mdv.MT_T)
mod.setEMod("helixPierce")
mod.createSpline(128)
mod.setModProperty(mdv.ML_ALL,mdv.MA_LS)
mod.setModLayer(0)
local v = {}

xero.definemod {"helixPierce","helixPierceP", function(b,p)
	mod.setEModSplineType(mdv.MST_Z)
	mod.setEMod("helixPierce")

	local currBeat = background.GetBarTime()
	local viewRangeMeasure = background.GetViewRangeMeasure()
	local yOffset = currBeat/viewRangeMeasure

	for i=0,127 do
		local ii=i/127
		ii = ii+yOffset
		--v[i] = math.sin(ii*math.pi*10.)*.1
		--v[i] = math.sin(ii*math.pi*10.)*.1
		v[i] = math.sin(ii*math.pi*2.*10./viewRangeMeasure)*.1
	end
	mod.setModSplineT(v)
end}

xero.setdefault{0,"helixPierceP"}

xero.linkmod{"helixPierce",{"helixPierce"}}

