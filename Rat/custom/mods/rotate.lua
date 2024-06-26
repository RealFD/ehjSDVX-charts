SplineType(SpCordY)
AddMod(ModNames.RotationTable.Side.LS,RotMod)
SetMod(ModNames.RotationTable.Side.LS)
ModLayer(0)
MakeSpline(12)
ModProp(LeftSide,AllAF)

SplineType(SpCordY)
AddMod(ModNames.RotationTable.Side.RS,RotMod)
SetMod(ModNames.RotationTable.Side.RS)
ModLayer(0)
MakeSpline(12)
ModProp(RightSide,AllAF)

xero.definemod {ModNames.RotationTable.Side.LS, function (p)
    local val = p
    SplineType(SpCordY)
    SetMod(ModNames.RotationTable.Side.LS)
    for i = 0, (12-1) do
        ModSpline(i,1/val)
    end
end}
xero.setdefault{0,ModNames.RotationTable.Side.LS}

xero.definemod {ModNames.RotationTable.Side.RS, function (p)
    local val = p
    SplineType(SpCordY)
    SetMod(ModNames.RotationTable.Side.RS)
    for i = 0, (12-1) do
        ModSpline(i,1/val)
    end
end}
xero.setdefault{0,ModNames.RotationTable.Side.RS}

xero.definemod {ModNames.RotationTable.Side.BH, function (p)
    local val = p
    SplineType(SpCordY)
    SetMod(ModNames.RotationTable.Side.LS)
    for i = 0, (12-1) do
        ModSpline(i,1/val)
    end
    SetMod(ModNames.RotationTable.Side.RS)
    for i = 0, (12-1) do
        ModSpline(i,-(1/val))
    end
end}
xero.setdefault{0,ModNames.RotationTable.Side.BH}