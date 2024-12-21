local s = dofile(background.GetPath().."/realfd/shortcuts.lua")

local t = {}

local cord = mdv.MST_Y
local affection = mdv.MA_ALL-mdv.MA_TICK

for i = 1, 4, 1 do
    table.insert(t,"zigzag"..i)
end

s.Create(t[1],cord,mdv.MT_T,s.BTA,affection,5,0)
s.Create(t[2],cord,mdv.MT_T,s.BTB,affection,5,0)
s.Create(t[3],cord,mdv.MT_T,s.BTC,affection,5,0)
s.Create(t[4],cord,mdv.MT_T,s.BTD,affection,5,0)

xero.definemod {"zigzag","zigzagP","zigzagD", function (b,p,d)
    local beat = b
    local val = p
    local dex = d

    if dex % 2 ~= 0 then
        val = -val
    end

    mod.setEModSplineType(mdv.MST_Y)
    mod.setEMod(t[dex])
    for i = 0, 127 do
        local ii = i / 127
        mod.setModSpline(i,math.sin(val*math.pi*ii))
    end
end}

xero.setdefault{0,"zigzagP"}
xero.setdefault{1,"zigzagD"}

xero.linkmod{"zigzag",t}