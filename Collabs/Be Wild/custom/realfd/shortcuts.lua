local short = {
    Create = function (name,mst,mt,ml,ma,amount,layer)
        mod.setEModSplineType(mst)
        mod.addMod(name,mt)
        mod.setEMod(name)
        mod.setModLayer(layer)
        mod.createSpline(amount)
        mod.setModProperty(ml,ma)
    end,
    
    LaserL           = mdv.LSL,
    LaserR           = mdv.LSR,
    
    BTA              = mdv.BTA,
    BTB              = mdv.BTB,
    BTC              = mdv.BTC,
    BTD              = mdv.BTD,
    
    FXL              = mdv.FXL,
    FXR              = mdv.FXR,
    
    -- Combies --
    
    LeftBT           = mdv.BTA + mdv.BTB,
    RightBT          = mdv.BTC + mdv.BTD,
    
    LeftSide         = mdv.LSL + mdv.BTA + mdv.BTB + mdv.FXL,
    RightSide        = mdv.LSR + mdv.BTC + mdv.BTD + mdv.FXR,
}

return short