local splineamount = 64

SplineType(SpCordX)
AddMod(ModNames.TansitionTable.Lane.A,TransMod)
SetMod(ModNames.TansitionTable.Lane.A)
ModLayer(1)
MakeSpline(splineamount)
ModProp(BTA,TrackAF)

SplineType(SpCordX)
AddMod(ModNames.TansitionTable.Lane.B,TransMod)
SetMod(ModNames.TansitionTable.Lane.B)
ModLayer(1)
MakeSpline(splineamount)
ModProp(BTB,TrackAF)

SplineType(SpCordX)
AddMod(ModNames.TansitionTable.Lane.C,TransMod)
SetMod(ModNames.TansitionTable.Lane.C)
ModLayer(1)
MakeSpline(splineamount)
ModProp(BTC,TrackAF)

SplineType(SpCordX)
AddMod(ModNames.TansitionTable.Lane.D,TransMod)
SetMod(ModNames.TansitionTable.Lane.D)
ModLayer(1)
MakeSpline(splineamount)
ModProp(BTD,TrackAF)

SplineType(SpCordX)
AddMod(ModNames.TansitionTable.Lane.LL,TransMod)
SetMod(ModNames.TansitionTable.Lane.LL)
ModLayer(1)
MakeSpline(splineamount)
ModProp(LaserL,TrackAF)

SplineType(SpCordX)
AddMod(ModNames.TansitionTable.Lane.LR,TransMod)
SetMod(ModNames.TansitionTable.Lane.LR)
ModLayer(1)
MakeSpline(splineamount)
ModProp(LaserR,TrackAF)

xero.definemod {ModNames.TansitionTable.Lane.A, function(p)
    local val = p
    SplineType(SpCordX)
    SetMod(ModNames.TansitionTable.Lane.A)
    for i = 0, (splineamount - 1) do
        ModSpline(i, val)
    end
end}
xero.setdefault{0,ModNames.TansitionTable.Lane.A}

xero.definemod {ModNames.TansitionTable.Lane.B, function(p)
    local val = p
    SplineType(SpCordX)
    SetMod(ModNames.TansitionTable.Lane.B)
    for i = 0, (splineamount - 1) do
        ModSpline(i, val)
    end
end}
xero.setdefault{0,ModNames.TansitionTable.Lane.B}

xero.definemod {ModNames.TansitionTable.Lane.C, function(p)
    local val = p
    SplineType(SpCordX)
    SetMod(ModNames.TansitionTable.Lane.C)
    for i = 0, (splineamount - 1) do
        ModSpline(i, val)
    end
end}
xero.setdefault{0,ModNames.TansitionTable.Lane.C}

xero.definemod {ModNames.TansitionTable.Lane.D, function(p)
    local val = p
    SplineType(SpCordX)
    SetMod(ModNames.TansitionTable.Lane.D)
    for i = 0, (splineamount - 1) do
        ModSpline(i, val)
    end
end}
xero.setdefault{0,ModNames.TansitionTable.Lane.D}

xero.definemod {ModNames.TansitionTable.Lane.LL, function(p)
    local val = p
    SplineType(SpCordX)
    SetMod(ModNames.TansitionTable.Lane.LL)
    for i = 0, (splineamount - 1) do
        ModSpline(i, val)
    end
end}
xero.setdefault{0,ModNames.TansitionTable.Lane.LL}

xero.definemod {ModNames.TansitionTable.Lane.LR, function(p)
    local val = p
    SplineType(SpCordX)
    SetMod(ModNames.TansitionTable.Lane.LR)
    for i = 0, (splineamount - 1) do
        ModSpline(i, val)
    end
end}
xero.setdefault{0,ModNames.TansitionTable.Lane.LR}