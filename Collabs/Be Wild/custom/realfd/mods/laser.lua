local s = dofile(background.GetPath().."/realfd/shortcuts.lua")

local splineamount = 128
local v = {}
for i = 1, splineamount do
    v[i] = 0
end

s.Create("L1",mdv.MST_X,mdv.MT_T,mdv.LSL,mdv.MA_LS,splineamount,2)
s.Create("L2",mdv.MST_X,mdv.MT_T,mdv.LSL,mdv.MA_LS,splineamount,2)

s.Create("R1",mdv.MST_Z,mdv.MT_T,mdv.LSR,mdv.MA_LS,splineamount,1)
s.Create("R2",mdv.MST_Z,mdv.MT_T,mdv.LSR,mdv.MA_LS,splineamount,1)

xero.definemod {"LaserWave","LWP","LWX","LWY", function (b,p,x,y)
    local beat = b
    local val = p
    local xpos = x
    local ypos = y

    mod.setEModSplineType(mdv.MST_X)
    mod.setEMod("L1")
    for i = 0, (splineamount - 1) do
        local t = xpos*(i / splineamount) * 2 * math.pi * 5  -- adjust frequency
        if xpos==0 then
            mod.setSplineProperty(i, i/(splineamount - 1) ,mdv.SIT_LIN)
        else
            mod.setSplineProperty(i, (i-xpos*64) / (xpos*64), mdv.SIT_LIN)
        end
        --v[i] = xpos * math.sin(t) * 0.3
        mod.setModSpline(i,xpos * math.sin(t) * 0.3)
    end
    --mod.setModSplineT(v)

    mod.setEModSplineType(mdv.MST_X)
    mod.setEMod("L2")
    for i = 0, (splineamount - 1) do
        local t = ypos*(i / splineamount) * 2 * math.pi * 5  -- adjust frequency
        if ypos==0 then
            mod.setSplineProperty(i, i/(splineamount - 1) ,mdv.SIT_LIN)
        else
            mod.setSplineProperty(i, (i-ypos*64) / (ypos*64), mdv.SIT_LIN)
        end
        mod.setModSpline(i,ypos * math.sin(t) * 0.3)
    end

    mod.setEModSplineType(mdv.MST_X)
    mod.setEMod("R1")
    for i = 0, (splineamount - 1) do
        local t = ypos*(i / splineamount) * 2 * math.pi * 5  -- adjust frequency
        if ypos==0 then
            mod.setSplineProperty(i, i/(splineamount - 1), mdv.SIT_LIN)
        else
            mod.setSplineProperty(i, (i-ypos*64) / (ypos*64), mdv.SIT_LIN)
        end
        mod.setModSpline(i,ypos * -math.sin(t) * 0.3)
    end

end}

xero.setdefault{0,"LWP"}
xero.setdefault{0,"LWX"}
xero.setdefault{0,"LWY"}

xero.linkmod{"LaserWave",{"L1","L2","R1","R2"}}