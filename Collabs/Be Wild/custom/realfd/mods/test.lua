mod.setEModSplineType(mdv.MST_X)
mod.addMod("test1",mdv.MT_T)
mod.setEMod("test1")
mod.createSpline(128)
mod.setModProperty(mdv.ML_ALL,mdv.ML_ALL)
mod.setModLayer(2)

mod.setEModSplineType(mdv.MST_Z)
mod.addMod("test2",mdv.MT_T)
mod.setEMod("test2")
mod.createSpline(128)
mod.setModProperty(mdv.ML_ALL,mdv.ML_ALL)
mod.setModLayer(2)

xero.definemod {"test","testP", function (b,p)
    local val = p
    mod.setEModSplineType(mdv.MST_X)
    mod.setEMod("test1")
    for i = 0, 127 do
        local ii = i / 127
        mod.setModSpline(i,val*math.sin(ii*math.pi*ii-b*math.pi*ii))
    end
    mod.setEModSplineType(mdv.MST_Z)
    mod.setEMod("test2")
    for i = 0, 127 do
        local ii = i / 127
        mod.setModSpline(i,val*math.sin(ii*math.pi*ii-b*math.pi*ii))
    end
end}

xero.setdefault{0,"testP"}

xero.linkmod{"test",{"test1","test2"}}