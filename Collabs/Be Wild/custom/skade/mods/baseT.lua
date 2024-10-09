mod.addMod("baseScale",mdv.MT_S)
mod.setEMod("baseScale")
for i = 0,2 do
	mod.setEModSplineType(mdv.MST_X+i)
	mod.createSpline(2)
end
mod.setModProperty(mdv.ML_ALL,mdv.MA_ALL-mdv.MA_TRK)
mod.setModLayer(1)

xero.definemod {"baseScale","baseScaleX","baseScaleY","baseScaleZ", function(b,x,y,z)
	mod.setEMod("baseScale")
	local scale = {x,y,z}
	for j=0,2 do
		mod.setEModSplineType(mdv.MST_X+j)
		for i=0,1 do
			local p = scale[j+1]
			mod.setModSpline(i,p)
		end
	end
end}

xero.setdefault{1,"baseScaleX"}
xero.setdefault{1,"baseScaleY"}
xero.setdefault{1,"baseScaleZ"}

xero.linkmod{"baseScale",{"baseScale"}}
-------------------------------------------------------------------------------------------
mod.addMod("baseRot",mdv.MT_R)
mod.setEMod("baseRot")
for i = 0,2 do
	mod.setEModSplineType(mdv.MST_X+i)
	mod.createSpline(2)
end
mod.setModProperty(mdv.ML_ALL,mdv.MA_ALL-mdv.MA_TRK)
mod.setModLayer(0)

xero.definemod {"baseRot","baseRotX","baseRotY","baseRotZ", function(b,x,y,z)
	mod.setEMod("baseRot")
	local scale = {x,y,z}
	for j=0,2 do
		mod.setEModSplineType(mdv.MST_X+j)
		for i=0,1 do
			local p = scale[j+1]
			mod.setModSpline(i,p)
		end
	end
end}

xero.setdefault{0,"baseRotX"}
xero.setdefault{0,"baseRotY"}
xero.setdefault{0,"baseRotZ"}

xero.linkmod{"baseRot",{"baseRot"}}
-------------------------------------------------------------------------------------------
mod.addMod("baseTrans",mdv.MT_T)
mod.setEMod("baseTrans")
for i = 0,2 do
	mod.setEModSplineType(mdv.MST_X+i)
	mod.createSpline(2)
end
mod.setModProperty(mdv.ML_ALL,mdv.MA_ALL-mdv.MA_TRK)
mod.setModLayer(0)

xero.definemod {"baseTrans","baseTransX","baseTransY","baseTransZ", function(b,x,y,z)
	mod.setEMod("baseTrans")
	local scale = {x,y,z}
	for j=0,2 do
		mod.setEModSplineType(mdv.MST_X+j)
		for i=0,1 do
			local p = scale[j+1]
			mod.setModSpline(i,p)
		end
	end
end}

xero.setdefault{0,"baseTransX"}
xero.setdefault{0,"baseTransY"}
xero.setdefault{0,"baseTransZ"}

xero.linkmod{"baseTrans",{"baseTrans"}}
-------------------------------------------------------------------------------------------
mod.addMod("baseSkew1",mdv.MT_K1)
mod.setEMod("baseSkew1")
for i = 0,2 do
	mod.setEModSplineType(mdv.MST_X+i)
	mod.createSpline(2)
end
mod.setModProperty(mdv.ML_ALL,mdv.MA_ALL-mdv.MA_TRK)
mod.setModLayer(0)
mod.addMod("baseSkew2",mdv.MT_K2)
mod.setEMod("baseSkew2")
for i = 0,2 do
	mod.setEModSplineType(mdv.MST_X+i)
	mod.createSpline(2)
end
mod.setModProperty(mdv.ML_ALL,mdv.MA_ALL-mdv.MA_TRK)
mod.setModLayer(0)

xero.definemod {"baseSkew",
	"baseSkewXY",
	"baseSkewXZ",
	"baseSkewYX",
	"baseSkewYZ",
	"baseSkewZX",
	"baseSkewZY",
	function(b,x,y,z)
	mod.setEMod("baseSkew1")
	local skew = {x,y,z}
	for j=0,2 do
		mod.setEModSplineType(mdv.MST_X+j)
		for i=0,1 do
			local p = skew[j+1]
			mod.setModSpline(i,p)
		end
	end
end}

xero.setdefault{0,"baseSkewXY"}
xero.setdefault{0,"baseSkewXZ"}
xero.setdefault{0,"baseSkewYX"}
xero.setdefault{0,"baseSkewYZ"}
xero.setdefault{0,"baseSkewZX"}
xero.setdefault{0,"baseSkewZY"}

xero.linkmod{"baseSkew",{"baseSkew1","baseSkew2"}}
