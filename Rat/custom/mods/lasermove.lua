local splineamount = 128

SplineType(SpCordX)
AddMod("L1",TransMod)
SetMod("L1")
ModLayer(0)
MakeSpline(splineamount)
ModProp(LaserL,LaserAF)

SplineType(SpCordX)
AddMod("R1",TransMod)
SetMod("R1")
ModLayer(0)
MakeSpline(splineamount)
ModProp(LaserR,LaserAF)

SplineType(SpCordZ)
AddMod("L2",TransMod)
SetMod("L2")
ModLayer(0)
MakeSpline(splineamount)
ModProp(LaserL,LaserAF)

SplineType(SpCordZ)
AddMod("R2",TransMod)
SetMod("R2")
ModLayer(0)
MakeSpline(splineamount)
ModProp(LaserR,LaserAF)



xero.definemod {"LaserSetWaveX", function (p)
    local val = p
    SplineType(SpCordX)
    SetMod("L1")
    for i = 0, (splineamount - 1) do
        local t = val*(i / splineamount) * 2 * math.pi * 5  -- adjust frequency
        if p==0 then
            SplineProp(i, i/127, SpLinear)
        else
            SplineProp(i, (i-val*64) / (val*64), SpLinear)
        end
        ModSpline(i, math.sin(t) * 0.3)
    end

    SplineType(SpCordX)
    SetMod("R1")
    for i = 0, (splineamount - 1) do
        local t = val*(i / splineamount) * 2 * math.pi * 5  -- adjust frequency
        if p==0 then
            SplineProp(i, i/127, SpLinear)
        else
            SplineProp(i, (i-val*64) / (val*64), SpLinear)
        end
        ModSpline(i, -math.sin(t) * 0.3)
    end
end}
xero.setdefault{0, "LaserSetWaveX"}

xero.definemod {"LaserSetWaveY", function (p)
    local val = p
    SplineType(SpCordZ)
    SetMod("L2")
    for i = 0, (splineamount - 1) do
        local t = val*(i / splineamount) * 2 * math.pi * 5  -- adjust frequency
        if p==0 then
            SplineProp(i, i/127, SpLinear)
        else
            SplineProp(i, (i-val*64) / (val*64), SpLinear)
        end
        ModSpline(i, math.cos(t) * 0.3)  -- Use cos to synchronize with X
    end

    SplineType(SpCordZ)
    SetMod("R2")
    for i = 0, (splineamount - 1) do
        local t = val*(i / splineamount) * 2 * math.pi * 5  -- adjust frequency
        if p==0 then
            SplineProp(i, i/127, SpLinear)
        else
            SplineProp(i, (i-val*64) / (val*64), SpLinear)
        end
        ModSpline(i, -math.cos(t) * 0.3)  -- Use cos to synchronize with X
    end
end}
xero.setdefault{0, "LaserSetWaveY"}

