local function setAndEaseCustom(startTime, duration, easeDuration, easingType, modName, numIntervals, setValues, easeValues)
    -- Apply per-frame settings for the specified duration
    xero.perframe{startTime, duration, modName}

    -- Loop through each interval to set and ease the values
    for i = 0, numIntervals - 1 do
        -- Calculate the time for each set and ease step
        local currentSetTime = startTime + i * easeDuration

        -- Set the mod to the specified value
        xero.set{currentSetTime, setValues[i + 1], modName .. "D"}

        -- Apply the ease function using the specified easing parameters
        xero.ease{
            startTime + i * easeDuration,    -- Start time for the ease
            easeDuration,                     -- Duration for the ease
            easingType,                       -- Easing type
            easeValues[i + 1],               -- Ease amount
            modName .. "P"                   -- The mod to apply the ease on
        }
    end
end

local function setXeroAlternatingMods(t)
    if not t then
        return
    end
    local ModName1 = t.ModName1 or t[1]
    local ModName2 = t.ModName2 or t[2]
    local start = t.start or t[3]
    local ending = t.ending or t[4]
    local l_per = t.l_per or t[5]
    local l_ease = t.l_ease or t[6]
    local easing = t.easing or t[7]
    local signiture = t.signiture or t[8]
    local amount = t.amount or t[9]

    -- Normalize the signiture to a fraction of the measure, e.g., 1/4, 2/4
    local normalized_signiture = signiture * 4

    -- Apply per-frame settings for both mods
    xero.perframe{start, ending, ModName1}
    xero.perframe{start, ending, ModName2}

    -- Apply the ease function with alternating mods
    for i = 1, amount do
        -- Choose the mod name alternately
        local ModName = (i % 2 == 1) and ModName1 or ModName2
        
        -- Calculate the adjusted start time for each ease step
        local adjusted_start = start + (i - 1) * (normalized_signiture / 4)

        -- Apply the ease for the chosen mod
        xero.ease{
            adjusted_start,          -- Adjusted start time
            l_ease,                  -- Length of the ease
            easing,                  -- Easing type
            l_per,                   -- Effect amount
            ModName .. "P"           -- Mod name with suffix
        }
    end
end

local sgt = require('template/ehj/sharedGlobalTable')

local setAllFill = function(p)
	sgt.set("songInfoFillC",{p,p,p})
	sgt.set("scoreFillC",{p,p,p})

	sgt.set("critLineFillC",{p,p,p})
	sgt.set("consoleFillC",{p,p,p})
	sgt.set("gaugeFillC",{p,p,p})
	sgt.set("bannerFillC",{p,p,p})
end

-- Set parameters for the cam function (can be called multiple times)
local function setCameraEase(t,matrixFunc)
    -- Check if 't' is valid
    if not t then
        return
    end
    
    -- Store parameters in the cam object for later access
    local params = {
        start = t.start or t[1],
        length = t.length or t[2],
        ease = t.ease or t[3],
        Vstart = t.Vstart or t[4],
        Vend = t.Vend or t[5],
        Tmat = t.Tmat or t[6],
        Rmat = t.Rmat or t[7],
    }

    xero.func_ease {params.start, params.length, params.ease, params.Vstart, params.Vend, function(p)
        local _, _, trackTimer = background.GetTiming()
        
        -- Condition to check some real-time flag or timer
        if U_REALFD then
            local smSin = 10 * (math.sin(trackTimer) * 0.5 + 0.5)
            local smSin2 = -smSin * 0.5
            local smSin3 = 0
            
            local m = matrixFunc(p)

            -- Apply the matrix as camera modifier
            mod.SetCamModMat(m)
            gfx.SetNVGmodMat(m)

            -- Update the projection matrices
            local proj = mod.GetProjMatNVG()
            gfx.SetNVGprojMat(proj)
            gfx.SetNVGprojMatSkin(proj)
        end
    end}

    xero.func{params.start-1,function ()
        local idt = {
            1,0,0,0,
            0,1,0,0,
            0,0,1,0,
            0,0,0,1
        }
        mod.SetCamModMat(idt)
    end}
end

-- Usage:
-- setCameraEase(t) to set or update parameters multiple times

local function setEase(t,val,type)
    local params = {
        start = t.start or t[1],
        length = t.length or t[2],
        ease = t.ease or t[3],
        Vstart = t.Vstart or t[4],
        Vend = t.Vend or t[5],
        Tmat = t.Tmat or t[6],
        Rmat = t.Rmat or t[7],
    }
    xero.func_ease {params.start, params.length, params.ease, params.Vstart, params.Vend, function(p)
        FD_U[val] = p
    end}
    
end

xero.func_ease {-1, 7, linear, -1, 1, function(p)
    Ubgfs.alpha = p
    setAllFill(p)
end}

setEase({23.80,0.1,outExpo,100,.2},"U_gate_size")
setEase({23.80,0.1,instant,1,0.9},"U_gate_fade")

setEase({24-(1/16),0.5,outExpo,.2,0.1},"U_gate_size")

setEase({32-(1/16),0.5,outExpo,.9,100},"U_gate_size")
setEase({32-(1/16),0.5,outExpo,0.9,0},"U_gate_fade")

setEase({24-(4/16),0.25,inExpo,0,.25},"U_fuzzy")
setEase({32,0.25,outExpo,.25,-1},"U_fuzzy")

setEase({96+(4/16),0.25,bounce,-1,1},"U_fuzzy")
setEase({96+(12/16),0.25,bounce,-1,1},"U_fuzzy")

setEase({97+(4/16),0.25,bounce,-1,1},"U_fuzzy")
setEase({97+(12/16),0.25,bounce,-1,1},"U_fuzzy")

setEase({98+(4/16),0.25,bounce,-1,1},"U_fuzzy")
setEase({98+(12/16),0.25,bounce,-1,1},"U_fuzzy")

setEase({99+(4/16),0.25,bounce,-1,1},"U_fuzzy")
setEase({99+(12/16),0.25,bounce,-1,1},"U_fuzzy")

setEase({102+(8/16),0.25,bounce,-1,1},"U_fuzzy")


--[[
xero.ease{97+(12/16),0.25,bounce,1,"ShaderP"}
xero.ease{97+(12/16),0.25,bounce,.75,"ShaderN"}

xero.ease{98+(4/16),0.25,bounce,1,"ShaderP"}
xero.ease{98+(4/16),0.25,bounce,.75,"ShaderN"}

xero.ease{98+(12/16),0.25,bounce,1,"ShaderP"}
xero.ease{98+(12/16),0.25,bounce,.75,"ShaderN"}

xero.ease{99+(4/16),0.25,bounce,1,"ShaderP"}
xero.ease{99+(4/16),0.25,bounce,.75,"ShaderN"}

xero.ease{99+(12/16),0.25,bounce,1,"ShaderP"}
xero.ease{99+(12/16),0.25,bounce,.75,"ShaderN"}


xero.ease{102+(15/32),0.5,bounce,1,"ShaderP"}
xero.ease{102+(15/32),0.5,bounce,1,"ShaderN"}
]]


--xero.perframe{10,18,"test"}
--xero.ease{10,0.45,bounce,.5,"testP"}
--xero.ease{12,0.45,bounce,.5,"testP"}
--xero.ease{16,0.5,bounce,.5,"testP"}
--xero.ease{18,0.5,bounce,.5,"testP"}

setXeroAlternatingMods({ModName1 = "RightSide", ModName2 = "LeftSide", start = 70, ending = 5, l_per = 0.5, l_ease = 1/4, easing = bounce, signiture = 1/4, amount = 4})

xero.ease{72,1,bounce,-.5,"LeftSideP"}

xero.ease{72,1,bounce,-.5,"RightSideP"}


--setAndEaseCustom(44,4,1/4,inSine,"nerd",4,{1, 2, 3, 4},{mdv.BT_W, mdv.BT_W, mdv.BT_W, mdv.BT_W})


xero.perframe{14,1,"LaserWave"}
xero.ease{14,0.45,bounce,1.5,"LWX"}

local matrixFuncTest0 = function(p)
    -- Camera transformation matrices
    local m = gfx.GetTransMat({0, 0, -p})  -- Translation matrix
    -- Combine rotation and translation matrices
    return gfx.MultMat(m)
end

setCameraEase({23,1,inExpo,0,1,{0,2,2}},matrixFuncTest0)

setCameraEase({24,1,outExpo,1,0,{0,2,2}},matrixFuncTest0)

local matrixFuncTest = function(p)
    -- Camera transformation matrices
    local m = gfx.GetTransMat({0, p * -2, p * -2})  -- Translation matrix
    local rot2 = gfx.GetRotMat({-p * 60, 0, 0})  -- Rotation matrix
    
    -- Combine rotation and translation matrices
    return gfx.MultMat(rot2, m)
end

setCameraEase({71,1,bounce,0,1,{0,2,2}},matrixFuncTest)

xero.func{71-1,function ()
    local idt = {
        1,0,0,0,
        0,1,0,0,
        0,0,1,0,
        0,0,0,1
    }
    mod.SetCamModMat(idt)
end}


xero.func_ease {78-1/4, 1/4, bounce, 0, 1, function(p)
    local _, _, trackTimer = background.GetTiming()
    if U_REALFD then
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
        local m = gfx.GetTransMat({0,0,-p})
        local rot2 = gfx.GetRotMat({0,0,-p*45})
        --local t3 = gfx.GetTransMat({0,0,-4})
        m = gfx.MultMat(m)
        mod.SetCamModMat(m)
        gfx.SetNVGmodMat(m)
        local proj = mod.GetProjMatNVG()
        gfx.SetNVGprojMat(proj)
        gfx.SetNVGprojMatSkin(proj)
    end
end}

xero.func{78-1+1/4,function ()
    local idt = {
        1,0,0,0,
        0,1,0,0,
        0,0,1,0,
        0,0,0,1
    }
    mod.SetCamModMat(idt)
end}

xero.func_ease {86-1/4, 1/4, bounce, 0, 1, function(p)
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
        local m = gfx.GetTransMat({0,0,-p})
        local rot2 = gfx.GetRotMat({0,0,p*45})
        --local t3 = gfx.GetTransMat({0,0,-4})
        --local m = gfx.MultMat(rot2)
        mod.SetCamModMat(m)
        gfx.SetNVGmodMat(m)
        local proj = mod.GetProjMatNVG()
        gfx.SetNVGprojMat(proj)
        gfx.SetNVGprojMatSkin(proj)
    end
end}

xero.func{86-1+1/4,function ()
    local idt = {
        1,0,0,0,
        0,1,0,0,
        0,0,1,0,
        0,0,0,1
    }
    mod.SetCamModMat(idt)
end}

xero.func_ease {88, 8, linear, 0, 1, function(p)
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
        local m = gfx.GetTransMat({0,-p*0.5,-p}) -- mine
        local rot2 = gfx.GetRotMat({0,0,p*45})
        --local t3 = gfx.GetTransMat({0,0,-4})
        --local m = gfx.MultMat(rot2)
        mod.SetCamModMat(m)
        gfx.SetNVGmodMat(m)
        local proj = mod.GetProjMatNVG()
        gfx.SetNVGprojMat(proj)
        gfx.SetNVGprojMatSkin(proj)
    end
end}

xero.func{100,function ()
    local idt = {
        1,0,0,0,
        0,1,0,0,
        0,0,1,0,
        0,0,0,1
    }
    mod.SetCamModMat(idt)
end}