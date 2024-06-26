local splineamount = 55

SplineType(SpCordZ)
AddMod("CH1",TransMod)
SetMod("CH1")
ModLayer(5)
MakeSpline(splineamount)
ModProp(All,AllAF)


xero.definemod {"CH", function (p)
    local val = p
    SplineType(SpCordZ)
    SetMod("CH1")
    for i=0,(splineamount-1) do
        SplineProp(i,(i-val)/val,SpLinear)
        ModSpline(i,math.sin(i/127*math.pi*10)*.3)
    end
end}
xero.setdefault{0.1,"CH"}