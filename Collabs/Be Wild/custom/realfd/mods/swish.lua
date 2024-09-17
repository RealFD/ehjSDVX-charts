local short = dofile(background.GetPath().."/realfd/shortcuts.lua")

short.Create("LFS",mdv.MST_X,mdv.MT_T,short.LeftSide,mdv.MA_ALL,2,0)
short.Create("RFS",mdv.MST_X,mdv.MT_T,short.RightSide,mdv.MA_ALL,2,0)

xero.definemod {"LeftSide","LeftSideP", function (b,p)
    local beat = b
    local val = p
    mod.setEModSplineType(mdv.MST_X)
    mod.setEMod("LFS")
    for i = 0, (2 - 1) do
        mod.setModSpline(i, -val)
    end
end}

xero.setdefault{0,"LeftSideP"}

xero.linkmod{"LeftSide",{"LFS"}}

xero.definemod {"RightSide","RightSideP", function (b,p)
    local beat = b
    local val = p
    mod.setEModSplineType(mdv.MST_X)
    mod.setEMod("RFS")
    for i = 0, (2 - 1) do
        mod.setModSpline(i, val)
    end
end}

xero.setdefault{0,"RightSideP"}

xero.linkmod{"RightSide",{"RFS"}}