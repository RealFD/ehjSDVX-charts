mod.setEModSplineType(mdv.MST_X)
mod.addMod("test1",mdv.MT_T)
mod.setEMod("test1")
mod.createSpline(128)
mod.setModProperty(mdv.ML_ALL,mdv.MA_ALL)
mod.setModLayer(3)

xero.definemod {"test","testP", function (b,p)
    local beat = b
    local val = p
    mod.setEModSplineType(mdv.MST_X)
    mod.setEMod("test1")
    for i = 0, 127 do
        local ii = i / 127 * math.random()
        mod.setModSpline(i,val*math.sin(math.pi*i-b*math.pi*i))
    end
end}

xero.setdefault{0,"testP"}

xero.linkmod{"test",{"test1"}}