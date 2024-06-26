SplineType(SpCordX)
AddMod("BTA_M",TransMod)
SetMod("BTA_M")
ModLayer(4)
MakeSpline(128)
ModProp(BTA,BTAF)

SplineType(SpCordX)
AddMod("BTB_M",TransMod)
SetMod("BTB_M")
ModLayer(4)
MakeSpline(128)
ModProp(BTB,BTAF)

xero.definemod {"BTA_M", function (p)
    local val = p
    SplineType(SpCordX)
    SetMod("BTA_M")
    for i=0,127 do
        SplineProp(i,(i-val)/val,SpLinear)
        ModSpline(i,(i/127*math.pi*10)*.3)
    end
end}
xero.definemod {"BTB_M", function (p)
    local val = p
    SplineType(SpCordX)
    SetMod("BTB_M")
    for i=0,127 do
        SplineProp(i,(i-val)/val,SpLinear)
        ModSpline(i,(i/127*math.pi*10)*.3)
    end
end}