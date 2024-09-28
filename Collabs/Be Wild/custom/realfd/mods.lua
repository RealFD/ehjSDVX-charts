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

xero.perframe{10,18,"test"}
xero.ease{10,0.45,bounce,.5,"testP"}
xero.ease{12,0.45,bounce,.5,"testP"}
xero.ease{16,0.5,bounce,.5,"testP"}
--xero.ease{18,0.5,bounce,.5,"testP"}

setXeroAlternatingMods({ModName1 = "RightSide", ModName2 = "LeftSide", start = 70, ending = 5, l_per = 0.5, l_ease = 1/4, easing = bounce, signiture = 1/4, amount = 4})

xero.ease{72,1,linear,-.5,"LeftSideP"}

xero.ease{72,1,linear,-.5,"RightSideP"}


setAndEaseCustom(44,4,1/4,inSine,"nerd",4,{1, 2, 3, 4},{mdv.BT_W, mdv.BT_W, mdv.BT_W, mdv.BT_W})


xero.perframe{14,1,"LaserWave"}
xero.ease{14,0.45,bounce,1.5,"LWX"}