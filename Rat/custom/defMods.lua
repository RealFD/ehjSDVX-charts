
mod.addMod("test1",mdv.MT_T)
mod.setEMod("test1")
mod.setEModSplineType(mdv.MST_X)
mod.createSpline(128)
mod.setModProperty(mdv.ML_ALL,mdv.MA_ALL) --mdv.BTA + mdv.BTC, mdv.MA_ALL)
for i=0,127 do
	mod.setSplineProperty(i,(i-64)/64,mdv.SIT_LIN)
end

--xero.definemod {'test1', function(p)
--	local _,_, trackTimer = background.GetTiming()
--	mod.setEMod("test1")
--	mod.setEModSplineType(mdv.MST_X)
--	for i=0,127 do
--		local val = -(.5-.5*math.cos(i/127.*math.pi*12))*math.sin(trackTimer)*p
--		mod.setModSpline(i,val)
--	end
--end}
