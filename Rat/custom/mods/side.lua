SplineType(SpCordX)
AddMod(ModNames.TansitionTable.Side.LS,TransMod)
SetMod(ModNames.TansitionTable.Side.LS)
ModLayer(1)
MakeSpline(64)
ModProp(LeftSide,TrackAF+BTAF)

SplineType(SpCordX)
AddMod(ModNames.TansitionTable.Side.RS,TransMod)
SetMod(ModNames.TansitionTable.Side.RS)
ModLayer(1)
MakeSpline(64)
ModProp(RightSide,TrackAF+BTAF)

xero.definemod {ModNames.TansitionTable.Side.LS, function(p)
    local val = p
    SplineType(SpCordX)
    SetMod(ModNames.TansitionTable.Side.LS)
    for i = 0, (64 - 1) do
        ModSpline(i, -val)
    end
end }
xero.setdefault{0,ModNames.TansitionTable.Side.LS}

xero.definemod { ModNames.TansitionTable.Side.RS, function(p)
    local val = p
    SplineType(SpCordX)
    SetMod(ModNames.TansitionTable.Side.RS)
    for i = 0, (64 - 1) do
        ModSpline(i, val)
    end
end }
xero.setdefault{0,ModNames.TansitionTable.Side.RS}

xero.definemod { ModNames.TansitionTable.Side.BH, function(p)
    local val = p
    SplineType(SpCordX)
    SetMod(ModNames.TansitionTable.Side.LS)
    for i = 0, (64 - 1) do
        ModSpline(i, -val)
    end
    SplineType(SpCordX)
    SetMod(ModNames.TansitionTable.Side.RS)
    for i = 0, (64 - 1) do
        ModSpline(i, val)
    end
end }
xero.setdefault{0,ModNames.TansitionTable.Side.BH}
