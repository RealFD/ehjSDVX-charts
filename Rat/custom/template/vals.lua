AllAF            = mdv.MA_ALL
BTAF             = mdv.MA_BT
HoldAF           = mdv.MA_HLD
LaserAF          = mdv.MA_LS
TrackAF          = mdv.MA_TRK
LineAF           = mdv.MA_LIN
BHEAF            = mdv.MA_BHE

TransMod         = mdv.MT_T
RotMod           = mdv.MT_R
ScaleMod         = mdv.MT_S

SpLinear         = mdv.SIT_LIN
SpCosine         = mdv.SIT_COS
SpCubic          = mdv.SIT_CUB
SpNo             = mdv.SIT_NON

MakeSpline       = mod.createSpline

SplineProp       = mod.setSplineProperty

SplineType       = mod.setEModSplineType

ModSpline        = mod.setModSpline

ModLayer         = mod.setModLayer

AddMod           = mod.addMod

SetMod           = mod.setEMod
EnableMod        = mod.setModEnable
ModProp          = mod.setModProperty
SetSpeed         = mod.SetHispeed

EvalueModTrans   = mod.evaluateModTransform

SetPipe          = mod.setTrackPipe
ResetPipe        = mod.resetTrackPipe

-- Ways the Highway can move on givin Axis --

SpCordX          = mdv.MST_X

SpCordY          = mdv.MST_Y

SpCordZ          = mdv.MST_Z

All              = mdv.ML_ALL
AllBT            = mdv.ML_BT
AllFX            = mdv.ML_FX
AllL             = mdv.ML_LS

-- Just Key --

LaserL           = mdv.LSL
LaserR           = mdv.LSR

BTA              = mdv.BTA
BTB              = mdv.BTB
BTC              = mdv.BTC
BTD              = mdv.BTD

FXL              = mdv.FXL
FXR              = mdv.FXR

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
