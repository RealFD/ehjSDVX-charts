xero.definemod {"CameraEase","CameraEaseP", function (b,p)
    
    xero.func_ease {71, 1, bounce, 0, 1, function(p)
        local _, _, trackTimer = background.GetTiming()
        if U_REALFD then --trackTimer > 2.0 then
            local smSin = 10*(math.sin(trackTimer)*.5+.5)
            local smSin2 = 10*(math.cos(trackTimer)*.5+.5)
            smSin2 = -smSin*.5
            local smSin3 = 0
            --local t0 = gfx.GetTransMat({0,0,-smSin*.1})
            --local t1 = gfx.GetTransMat({0,-10,0})
            --local t2 = gfx.GetInverse(t1)
            --local rot = gfx.GetRotMat({-smSin,smSin2,smSin3})
            --local zscl = gfx.GetScaleMat({1,1,1})--+.5+.5*math.sin(trackTimer*.5)})
            --local m = gfx.MultMat(t1,rot,t2,t0,zscl) --TODO m is not affine (m[16] != 1) check and debug
            local m = gfx.GetTransMat({0,-p,-p}) -- mine
            local rot2 = gfx.GetRotMat({-p*30,0,0})
            --local t3 = gfx.GetTransMat({0,0,-4})
            m = gfx.MultMat(rot2,m)
            mod.SetCamModMat(m)
            gfx.SetNVGmodMat(m)
            local proj = mod.GetProjMatNVG()
            gfx.SetNVGprojMat(proj)
            gfx.SetNVGprojMatSkin(proj)
        end
    end}
end}

xero.setdefault{0,"CameraEaseP"}

xero.linkmod{"CameraEase",{"CameraEaseP"}}