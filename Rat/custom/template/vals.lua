--- ModAffection Types ---

--[[
># Effects following Layers #
---------------------------------------------------------
* Buttons
* Holds
* Lasers
* Track
* Lines
]]
AllAF            = mdv.MA_ALL

--[[
># Effects following Layers #
---------------------------------------------------------
* Buttons
]]
BTAF             = mdv.MA_BT

--[[
># Effects following Layers #
---------------------------------------------------------
* Holds
]]
HoldAF           = mdv.MA_HLD

--[[
># Effects following Layers #
---------------------------------------------------------
* Lasers
]]
LaserAF          = mdv.MA_LS

--[[
># Effects following Layers #
---------------------------------------------------------
* Track
]]
TrackAF          = mdv.MA_TRK

--[[
># Effects following Layers #
---------------------------------------------------------
* Lines
]]
LineAF           = mdv.MA_LIN

--[[
># Effects following Layers #
---------------------------------------------------------
* Button Hit Effect
]]
BHEAF            = mdv.MA_BHE


--- Ways of Moving / Rotation / Scaling ---

--[[
># Translation Modification #
]]
TransMod         = mdv.MT_T

--[[
># Rotation Modification #
]]
RotMod           = mdv.MT_R

--[[
># Scaling Modification #
]]
ScaleMod         = mdv.MT_S

--[[
># Spline Easing #
---------------------------------------------------------
* Linear
]]
SpLinear         = mdv.SIT_LIN

--[[
># Spline Easing #
---------------------------------------------------------
* Cosine
]]
SpCosine         = mdv.SIT_COS

--[[
># Spline Easing #
---------------------------------------------------------
* Cubic
]]
SpCubic          = mdv.SIT_CUB

--[[
># Spline Easing #
---------------------------------------------------------
* Nothing
]]
SpNo             = mdv.SIT_NON

--[[
># Creating Splines #
---------------------------------------------------------
>* Needs a Value in the ()
---------------------------------------------------------
># Example
> MakeSpline(64)
]]
MakeSpline       = mod.createSpline

--[[
># Spline Property #
---------------------------------------------------------
> Sets the Spline Property
>* (i, value, easing)
]]
SplineProp       = mod.setSplineProperty

--[[
># Setting Spline Type #
---------------------------------------------------------
> Sets the Type to one of the Following
>* "SpCordX" goes to the Right
>* "SpCordY" goes up from the Critline
>* "SpCordZ" goes up from the Track
---------------------------------------------------------
># Example
> SplineType(SpCordX)
]]
SplineType       = mod.setEModSplineType

--[[
># Modificating Spline #
---------------------------------------------------------
> Needs the Following
>* i = spline index from a for loop
>* value
---------------------------------------------------------
># Example
> ModSpline(i, val)
]]
ModSpline        = mod.setModSpline

--[[
># Layering Modificating #
---------------------------------------------------------
> For setting the Mods on there own Layers
---------------------------------------------------------
># Example
> ModLayer(0)
]]
ModLayer         = mod.setModLayer

--[[
># Adding Modificatings #
---------------------------------------------------------
> Add your Own Mods by Simply putting a string in the ()
---------------------------------------------------------
># Example
> AddMod("Test") |--> "Test was added to list of mods"
]]
AddMod           = mod.addMod

--[[
># Setting Modificatings up #
---------------------------------------------------------
> Make the Code after this line be bound to the Mod in the ()
---------------------------------------------------------
># Example
> SetMod("Test")
---------------------------------------------------------
> AddMod("Test",TransMod)
> SetMod("Test")
> ModLayer(0)
> MakeSpline(64)
]]
SetMod           = mod.setEMod             -- Makes the code after be bound to the mod in the ()
EnableMod        = mod.setModEnable
ModProp          = mod.setModProperty      -- Set the Properties of the mod (lane,object type)
SetSpeed         = mod.SetHispeed          -- Apply current Speed set in the ()

EvalueModTrans   = mod.evaluateModTransform -- needs 4 things (Vector3, Offset, Button Index, ModAffection)

-- Ways the Highway can move on givin Axis --

--[[
># Axis Movement #
---------------------------------------------------------
> Sets the Type to go to the Right
]]
SpCordX          = mdv.MST_X

--[[
># Axis Movement #
---------------------------------------------------------
> Sets the Type to go up from the Critline
]]
SpCordY          = mdv.MST_Y -- Foward or Backward ????

--[[
># Axis Movement #
---------------------------------------------------------
> Sets the Type to go up from the Track
]]
SpCordZ          = mdv.MST_Z -- Up or Down

All              = mdv.ML_ALL -- All Types
AllBT            = mdv.ML_BT -- All Buttons
AllFX            = mdv.ML_FX -- All FX Buttons
AllL             = mdv.ML_LS -- All Lasers

-- Just Key --

LaserL           = mdv.LSL -- Laser Left
LaserR           = mdv.LSR -- Laser Right

BTA              = mdv.BTA -- Button A
BTB              = mdv.BTB -- Button B
BTC              = mdv.BTC -- Button C
BTD              = mdv.BTD -- Button D

FXL              = mdv.FXL -- FX Button Left
FXR              = mdv.FXR -- FX Button Right

-- Combies --

LeftBT           = BTA + BTB
RightBT          = BTC + BTD

LeftSide         = LaserL + BTA + BTB + FXL
RightSide        = LaserR + BTC + BTD + FXR

-- later look for pipe line for track mesh

local Buttontype = {
    BT   = "Button",
    LN   = "Lane",
    SIDE = "Side"
}

-- Table for the Mods Namings FOR BUTTONS / LANES / SPLITS
ModTable         = {
    Button = {
        A   = Buttontype.BT .. ":A", -- Button:A
        B   = Buttontype.BT .. ":B", -- Button:B
        C   = Buttontype.BT .. ":C", -- Button:C
        D   = Buttontype.BT .. ":D", -- Button:D
        FXL = Buttontype.BT .. ":FXL", -- Button:FXL
        FXR = Buttontype.BT .. ":FXR", -- Button:FXR
        LL  = Buttontype.BT .. ":L", -- Button:L
        LR  = Buttontype.BT .. ":R", -- Button:R
    },
    Lane = {
        A   = Buttontype.LN .. ":A", -- Lane:A
        B   = Buttontype.LN .. "B",  -- Lane:B
        C   = Buttontype.LN .. ":C", -- Lane:C
        D   = Buttontype.LN .. ":D", -- Lane:D
        FXL = Buttontype.LN .. ":FXL", -- Lane:FXL
        FXR = Buttontype.LN .. ":FXR", -- Lane:FXR
        LL  = Buttontype.LN .. ":L", -- Lane:L
        LR  = Buttontype.LN .. ":R", -- Lane:R
    },
    Side = {
        LS = Buttontype.SIDE .. ":Left", -- Side:Left
        RS = Buttontype.SIDE .. ":Right", -- Side:Right
        BH = "Both"
    }
}

-- adding Modification prefixes for the ModTable to include TransMod/RotMod/ScaleMod
ModNames         = {
    -- Houses Mods with Key | :T |
    TansitionTable = {
        Button = {
            A   = ModTable.Button.A .. ":T",  -- Button:A:T
            B   = ModTable.Button.B .. ":T",  -- Button:B:T
            C   = ModTable.Button.C .. ":T",  -- Button:C:T
            D   = ModTable.Button.D .. ":T",  -- Button:D:T
            FXL = ModTable.Button.FXL .. ":T", -- Button:FXL:T
            FXR = ModTable.Button.FXR .. ":T", -- Button:FXR:T
            LL  = ModTable.Button.LL .. ":T", -- Button:L:T
            LR  = ModTable.Button.LR .. ":T", -- Button:R:T
        },
        Lane = {
            A   = ModTable.Lane.A .. ":T",  -- Lane:A:T
            B   = ModTable.Lane.B .. ":T",  -- Lane:B:T
            C   = ModTable.Lane.C .. ":T",  -- Lane:C:T
            D   = ModTable.Lane.D .. ":T",  -- Lane:D:T
            FXL = ModTable.Lane.FXL .. ":T", -- Lane:FXL:T
            FXR = ModTable.Lane.FXR .. ":T", -- Lane:FXR:T
            LL  = ModTable.Lane.LL .. ":T", -- Lane:L:T
            LR  = ModTable.Lane.LR .. ":T", -- Lane:R:T
        },
        Side = {
            LS = ModTable.Side.LS .. ":T",   -- Side:Left:T
            RS = ModTable.Side.RS .. ":T",   -- Side:Right:T
            BH = ModTable.Side.BH .. ":T"    -- Side:Both:T
        },

    },
    -- Houses Mods with Key | :R |
    RotationTable = {
        Button = {
            A   = ModTable.Button.A .. ":R",  -- Button:A:R
            B   = ModTable.Button.B .. ":R",  -- Button:B:R
            C   = ModTable.Button.C .. ":R",  -- Button:C:R
            D   = ModTable.Button.D .. ":R",  -- Button:D:R
            FXL = ModTable.Button.FXL .. ":R", -- Button:FXL:R
            FXR = ModTable.Button.FXR .. ":R", -- Button:FXR:R
            LL  = ModTable.Button.LL .. ":R", -- Button:L:R
            LR  = ModTable.Button.LR .. ":R", -- Button:R:R
        },
        Lane = {
            A   = ModTable.Lane.A .. ":R",  -- Lane:A:R
            B   = ModTable.Lane.B .. ":R",  -- Lane:B:R
            C   = ModTable.Lane.C .. ":R",  -- Lane:C:R
            D   = ModTable.Lane.D .. ":R",  -- Lane:D:R
            FXL = ModTable.Lane.FXL .. ":R", -- Lane:FXL:R
            FXR = ModTable.Lane.FXR .. ":R", -- Lane:FXR:R
            LL  = ModTable.Lane.LL .. ":R", -- Lane:L:R
            LR  = ModTable.Lane.LR .. ":R", -- Lane:R:R
        },
        Side = {
            LS = ModTable.Side.LS .. ":R",   -- Side:Left:R
            RS = ModTable.Side.RS .. ":R",   -- Side:Right:R
            BH = ModTable.Side.BH .. ":R"    -- Both:R
        },
    },
    -- Houses Mods with Key | :S |
    ScaleTable = {
        A   = ModTable.Button.A .. ":S",  -- Button:A:S
        B   = ModTable.Button.B .. ":S",  -- Button:B:S
        C   = ModTable.Button.C .. ":S",  -- Button:C:S
        D   = ModTable.Button.D .. ":S",  -- Button:D:S
        FXL = ModTable.Button.FXL .. ":S", -- Button:FXL:S
        FXR = ModTable.Button.FXR .. ":S", -- Button:FXR:S
        LL  = ModTable.Button.LL .. ":S", -- Button:L:S
        LR  = ModTable.Button.LR .. ":S", -- Button:R:S
        LS  = ModTable.Side.LS .. ":S",   -- Side:Left:S
        RS  = ModTable.Side.RS .. ":S",   -- Side:Right:S
        BH  = ModTable.Side.BH .. ":S"    -- Both:S
    }
}
