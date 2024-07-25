local splineamount = 55

SplineType(SpCordZ)
AddMod("CH:Z",TransMod)
SetMod("CH:Z")
ModLayer(0)
MakeSpline(splineamount)
ModProp(All,AllAF)

SplineType(SpCordX)
AddMod("CH:L:Y",TransMod)
SetMod("CH:L:Y")
ModLayer(0)
MakeSpline(splineamount)
ModProp(LeftSide,AllAF)

SplineType(SpCordX)
AddMod("CH:R:Y",TransMod)
SetMod("CH:R:Y")
ModLayer(0)
MakeSpline(splineamount)
ModProp(RightSide,AllAF)


xero.definemod {"CH:Z", function (p)
    local val = p
    SplineType(SpCordZ)
    SetMod("CH:Z")
    for i=0,(splineamount-1) do
        SplineProp(i,(i-val)/val,SpLinear)
        ModSpline(i,math.sin(i/127*math.pi*10)*.3)
    end
end}
xero.setdefault{0.1,"CH:Z"}

xero.definemod {"CH:MSplit", function (p)
    local val = p
    SplineType(SpCordX)
    SetMod("CH:L:Y")
    for i=0,(splineamount-1) do
        SplineProp(i,(i-val)/val,SpLinear)
        ModSpline(i,-math.sin(i/127*math.pi*10)*.3)
    end
    SplineType(SpCordX)
    SetMod("CH:R:Y")
    for i=0,(splineamount-1) do
        SplineProp(i,(i-val)/val,SpLinear)
        ModSpline(i,math.sin(i/127*math.pi*10)*.3)
    end
end}
xero.setdefault{0.01,"CH:MSplit"}