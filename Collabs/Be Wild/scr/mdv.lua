---@meta

---> The [mdv](mdv.lua) class provides various `Mod Values` for Mod Functions inside `mod.lua`
--->
---> Each constant represents a specific type of effect, which can be used to control
---> various elements such as buttons, holds, lasers, track, lines, button hit effects, and ticks.
---------------------------------------------------------
---> # ModAffection's:
---------------------------------------------------------
---> - `MA_BT`    Represents the Button Effect.
---> - `MA_HLD`   Represents the Hold Effect.
---> - `MA_LS`    Represents the Laser Effect.
---> - `MA_TRK`   Represents the Track Effect.
---> - `MA_LIN`   Represents the Line Effect.
---> - `MA_BHE`   Represents the Button Hit Effect.
---> - `MA_TICK`  Represents the Tick effect.
---> - `MA_ALL`   Represents all Effects combined.
--- 
---------------------------------------------------------
---> # Transformation's:
---------------------------------------------------------
---> - `MT_T` Represents Translation.
---> - `MT_R` Represents Rotation.
---> - `MT_S` Represents Scaling.
---
---------------------------------------------------------
---> # Easing's:
---------------------------------------------------------
---> - `SIT_LIN` Linear
---> - `SIT_COS` Cosine
---> - `SIT_CUB` Cubic
---> - `SIT_NON` Nothing
mdv = {}

---> # Effects the following Layer #
---------------------------------------------------------
--- @type integer
mdv.MA_BT = 1  --> Button

---> # Effects the following Layer #
---------------------------------------------------------
--- @type integer
mdv.MA_HLD = 2  --> Hold

---> # Effects the following Layer #
---------------------------------------------------------
--- @type integer
mdv.MA_LS = 4  --> Laser

---> # Effects the following Layer #
---------------------------------------------------------
--- @type integer
mdv.MA_TRK = 8  --> Track

---> # Effects the following Layer #
---------------------------------------------------------
--- @type integer
mdv.MA_LIN = 16  --> Line

---> # Effects the following Layer #
---------------------------------------------------------
--- @type integer
mdv.MA_BHE = 32  --> Button Hit Effect

---> # Effects the following Layer #
---------------------------------------------------------
--- @type integer
mdv.MA_TICK = 64  --> Tick

--[[
># Effects the following Layers #
---------------------------------------------------------
>* Buttons
>* Holds
>* Lasers
>* Track
>* Lines
>* Button Hit Effect
>* Tick
]]
--- @type integer
mdv.MA_ALL = 128-1

--- Scaling
--- @type integer
mdv.MT_S = 0

--- Rotation
--- @type integer
mdv.MT_R = 1

--- Translation
--- @type integer
mdv.MT_T = 2

--- Linear Easing 
--- @type integer
mdv.SIT_LIN = 0

--- Cosine Easing
--- @type integer
mdv.SIT_COS = 1

--- Cubic Easing
--- @type integer
mdv.SIT_CUB = 2

--- DONT USE
--- @type integer
mdv.SIT_NON = 0

--> # Axis Type
-- Goes to the Right
--- @type integer
mdv.MST_X = 0

--> # Axis Type
-- Goes up from the Critline
--- @type integer
mdv.MST_Y = 1

--> # Axis Type
-- Goes up from the Track
--- @type integer
mdv.MST_Z = 2

-- # Mod Lane
---------------------------------------------------------
-- A Button
--- @type integer
mdv.BTA = 1

-- # Mod Lane
---------------------------------------------------------
-- A Button
--- @type integer
mdv.BTB = 2

-- # Mod Lane
---------------------------------------------------------
-- C Button
--- @type integer
mdv.BTC = 4

-- # Mod Lane
---------------------------------------------------------
-- D Button
--- @type integer
mdv.BTD = 8

-- # Mod Lane
---------------------------------------------------------
-- Left FX Button
--- @type integer
mdv.FXL = 16

-- # Mod Lane
---------------------------------------------------------
-- Right FX Button
--- @type integer
mdv.FXR = 32

-- # Mod Lane
---------------------------------------------------------
-- Left Laser
--- @type integer
mdv.LSL = 64

-- # Mod Lane
---------------------------------------------------------
-- Right Laser
--- @type integer
mdv.LSR = 128

-- # Mod Lane Group's
---------------------------------------------------------
-- ALL Button Lanes
--- @type integer
mdv.ML_BT = 16-1

-- # Mod Lane Group's
---------------------------------------------------------
-- ALL Button Lanes
--- @type integer
mdv.ML_FX = 16+32

-- # Mod Lane Group's
---------------------------------------------------------
-- ALL Button Laser
--- @type integer
mdv.ML_LS = 64+128

-- # Mod Lane Group's
---------------------------------------------------------
-- ALL Lanes
--- @type integer
mdv.ML_ALL = 256-1

-- Track Pipe Material
--- @type integer
mdv.TP_MATERIAL = 0

-- Track Pipe Parameters
--- @type integer
mdv.TP_PARAMS = 1

-- Track Pipe Mesh
--- @type integer
mdv.TP_MESH = 2

return mdv
