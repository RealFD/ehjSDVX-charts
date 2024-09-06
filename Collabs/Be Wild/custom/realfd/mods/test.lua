mod.setEModSplineType(mdv.MST_X)
mod.addMod("test1",mdv.MT_T)
mod.setEMod("test1")
mod.createSpline(2)
mod.setModProperty(mdv.ML_ALL,mdv.MA_ALL)

xero.definemod {"test","testP", function (b,p)
    local val = p
    mod.setEModSplineType(mdv.MST_X)
    mod.setEMod("test1")
    for i = 0, 1 do
        mod.setModSpline(i,val)
    end
end}

xero.setdefault{0,"testP"}

xero.linkmod{"test",{"test1"}}