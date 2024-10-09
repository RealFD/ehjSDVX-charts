mod.addMod("globalScale",mdv.MT_S)
mod.setEMod("globalScale")
for i = 0,2 do
	mod.setEModSplineType(mdv.MST_X+i)
	mod.createSpline(2)
end
mod.setModProperty(mdv.ML_ALL,mdv.MA_ALL)
mod.setModLayer(3)

xero.definemod {"globalScale","globalScaleX","globalScaleY","globalScaleZ", function(b,x,y,z)
	mod.setEMod("globalScale")
	local scale = {x,y,z}
	for j=0,2 do
		mod.setEModSplineType(mdv.MST_X+j)
		for i=0,1 do
			local p = scale[j+1]
			mod.setModSpline(i,p)
		end
	end
end}

xero.setdefault{1,"globalScaleX"}
xero.setdefault{1,"globalScaleY"}
xero.setdefault{1,"globalScaleZ"}

xero.linkmod{"globalScale",{"globalScale"}}
-------------------------------------------------------------------------------------------
mod.addMod("globalRot",mdv.MT_R)
mod.setEMod("globalRot")
for i = 0,2 do
	mod.setEModSplineType(mdv.MST_X+i)
	mod.createSpline(2)
end
mod.setModProperty(mdv.ML_ALL,mdv.MA_ALL)
mod.setModLayer(3)

xero.definemod {"globalRot","globalRotX","globalRotY","globalRotZ", function(b,x,y,z)
	mod.setEMod("globalRot")
	local scale = {x,y,z}
	for j=0,2 do
		mod.setEModSplineType(mdv.MST_X+j)
		for i=0,1 do
			local p = scale[j+1]
			mod.setModSpline(i,p)
		end
	end
end}

xero.setdefault{1,"globalRotX"}
xero.setdefault{1,"globalRotY"}
xero.setdefault{1,"globalRotZ"}

xero.linkmod{"globalRot",{"globalRot"}}
-------------------------------------------------------------------------------------------
mod.addMod("globalTrans",mdv.MT_T)
mod.setEMod("globalTrans")
for i = 0,2 do
	mod.setEModSplineType(mdv.MST_X+i)
	mod.createSpline(2)
end
mod.setModProperty(mdv.ML_ALL,mdv.MA_ALL)
mod.setModLayer(3)

xero.definemod {"globalTrans","globalTransX","globalTransY","globalTransZ", function(b,x,y,z)
	mod.setEMod("globalTrans")
	local scale = {x,y,z}
	for j=0,2 do
		mod.setEModSplineType(mdv.MST_X+j)
		for i=0,1 do
			local p = scale[j+1]
			mod.setModSpline(i,p)
		end
	end
end}

xero.setdefault{0,"globalTransX"}
xero.setdefault{0,"globalTransY"}
xero.setdefault{0,"globalTransZ"}

xero.linkmod{"globalTrans",{"globalTrans"}}

