local s = dofile(background.GetPath().."/realfd/shortcuts.lua")

local t = {}

for i = 1, 4, 1 do
    table.insert(t,"ln_swapper"..i)
end
-------------------------------------------------------------------
mod.addMod(t[1], mdv.MT_T)
mod.setEMod(t[1])
mod.setModLayer(1)
for i = 0,2 do
	mod.setEModSplineType(mdv.MST_Y+i)
	mod.createSpline(2)
end
mod.setModProperty(s.BTA,mdv.MA_ALL-mdv.MA_TICK)
-------------------------------------------------------------------
mod.addMod(t[2], mdv.MT_T)
mod.setEMod(t[2])
mod.setModLayer(1)
for i = 0,2 do
	mod.setEModSplineType(mdv.MST_Y+i)
	mod.createSpline(2)
end
mod.setModProperty(s.BTB,mdv.MA_ALL-mdv.MA_TICK)
-------------------------------------------------------------------
mod.addMod(t[3], mdv.MT_T)
mod.setEMod(t[3])
for i = 0,2 do
	mod.setEModSplineType(mdv.MST_Y+i)
	mod.createSpline(2)
end
mod.setModLayer(1)
mod.setModProperty(s.BTC,mdv.MA_ALL-mdv.MA_TICK)
-------------------------------------------------------------------
mod.addMod(t[4], mdv.MT_T)
mod.setEMod(t[4])
for i = 0,2 do
	mod.setEModSplineType(mdv.MST_Y+i)
	mod.createSpline(2)
end
mod.setModLayer(1)
mod.setModProperty(s.BTD,mdv.MA_ALL-mdv.MA_TICK)
-------------------------------------------------------------------

xero.definemod {"ln_swapper","ln_swapperP","ln_swapperD", function (b,p,d)
    local beat = b
    local val = p
    local dex = d

    mod.setEModSplineType(mdv.MST_Y)
    mod.setEMod(t[dex])
    mod.setModSpline(0,val)
    mod.setModSpline(1,-val)
end}

xero.setdefault{0,"ln_swapperP"}
xero.setdefault{1,"ln_swapperD"}

xero.linkmod{"ln_swapper",t}