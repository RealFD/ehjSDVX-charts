local short = {
    Create = function (NAME,AXIS,TRANSFORM,MODLANE,MODAFFACTION,AMOUNT,LAYER)
        mod.setEModSplineType(AXIS)
        mod.addMod(NAME,TRANSFORM)
        mod.setEMod(NAME)
        mod.setModLayer(LAYER)
        mod.createSpline(AMOUNT)
        mod.setModProperty(MODLANE,MODAFFACTION)
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