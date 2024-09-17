
for i=0,5 do
	
	mod.addMod("starTarget"..tostring(i),mdv.MT_T)
	mod.setEMod("starTarget"..tostring(i))
	for j=0,2 do
		mod.setEModSplineType(mdv.MST_X+j)
		mod.createSpline(2)
		mod.setSplineProperty(0,0,mdv.SIT_COS)
		mod.setSplineProperty(1,1,mdv.SIT_COS)
	end
	if i == 0 then
		mod.setModProperty(mdv.LSL,mdv.MA_ALL-mdv.MA_LS)
	end
	if i >= 1 and i <= 4 then
		mod.setModProperty(2^(i-1),mdv.MA_ALL-mdv.MA_LS)
	end
	if i == 5 then
		mod.setModProperty(mdv.LSR,mdv.MA_ALL-mdv.MA_LS)
	end
	mod.setModLayer(0)

end

xero.definemod {"starTarget","starTargetP", function(b,p)
	mod.setEModSplineType(mdv.MST_Y)
	--for i=0,2 do
	--	mod.setEModSplineType(mdv.MST_X+i)
	--	mod.setModSpline(0,math.cos(b))
	--	mod.setModSpline(1,0)
	--end
	for i=0,5 do
		mod.setEMod("starTarget"..tostring(i))
		mod.setEModSplineType(mdv.MST_X)
		local v = math.sin(b) + (i*2-5)/5 + math.cos(b+i)*.3
		mod.setModSpline(0,v*p)
		mod.setModSpline(1,0)
		mod.setEModSplineType(mdv.MST_Z)
		local v2 = math.cos(b)*.5+ math.cos(b*2+i)*.5
		mod.setModSpline(0,v2*p)
		mod.setModSpline(1,0)
		mod.setEModSplineType(mdv.MST_Y)
		mod.setModSpline(0,-3*p)
		mod.setModSpline(1,0)
	end
end}

xero.setdefault {0,"starTargetP"}
local t = {}
for i=0,5 do
	table.insert(t,"starTarget"..tostring(i))
end
xero.linkmod{"starTarget",t}
