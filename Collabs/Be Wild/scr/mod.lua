---@meta

---> The [mod](mod.lua) class provides various things used in the Fork.
--->
--->
--->
---------------------------------------------------------
---># Spline's:
---------------------------------------------------------
---> - `createSpline` Creats Spline
---> - `setSplineProperty` Sets the Spline Properties
---> - `setEModSplineType` Sets the Type
---> - `setModSpline` Modifies Spline
--- 
---------------------------------------------------------
---># Modding:
---------------------------------------------------------
---> - `addMod` Make a new Mod
---> - `setEMod` Makes the code after this be Focused on the current Mod
---> - `setModEnable` Enables the Current Mod
---> - `setModProperty` Sets the Mod Properties
---> - `setModLayer` Sets the Mod on their Own Layer
---> - `evaluateModTransform` //TODO Find out how to describe it
---------------------------------------------------------
---># Pipe:
---------------------------------------------------------
---> - `setTrackPipe`
---> - `resetTrackPipe`
---------------------------------------------------------
---># Speed:
---------------------------------------------------------
---> - `SetHispeed` You can Change the Speed on the Fly
mod = {}

--# Creating Splines 
---------------------------------------------------------
--- @param i integer Spline Amount
function mod.createSpline(i)
end

---# Spline Property 
---------------------------------------------------------
--- @param i integer The index of the spline.
--- @param offset number `yOffset`, where critline is 0 and track end is 1
--- @param interpolationType easing Example 
--- @see mdv.SIT_LIN or any other SIT_
function mod.setSplineProperty(i, offset, interpolationType)
end

---# Setting Spline Types
---------------------------------------------------------
--- @param Transform integer Once that can be used
--- @see mdv.MST_X 
--- @see mdv.MST_Y 
--- @see mdv.MST_Z 
function mod.setEModSplineType(Transform)
end

---# Modifying Splines
---------------------------------------------------------
--- @param i integer spline index from a for loop
--- @param value integer value
function mod.setModSpline(i, value)
end

---# Adding Modifications 
---------------------------------------------------------
--- Add your Own Mods by Simply putting a string in the ()
--- @param ModName string Needs to be a String
function mod.addMod(ModName)
end


---# Setting Modifications up 
---------------------------------------------------------
--- @param ModName string Is the Mod Name that's gonna be Focused
function mod.setEMod(ModName)
end

---# Modification Toggeling 
---------------------------------------------------------
--- @param state boolean Toggles the Current Mod with `true` or `false`
function mod.setModEnable(state)
end

---# Modification Properties
---------------------------------------------------------
--- @param ModLane integer found in `mdv.lua` under any of the `mdv.ML_` or `mdv.BTA`
--- @param ModAffection integer found in `mdv.lua` under any of the `mdv.MA_`
--- @ Below you will
---  @see mdv.ML_ALL All Button Lanes
---  @see mdv.BTA Just the A Button Lane
---  @see mdv.MA_ALL All Button Affection
---  @see mdv.MA_BT All FX Buttons Affection
function mod.setModProperty(ModLane,ModAffection)
end

---# Modification Layer 
---------------------------------------------------------
--- @param int integer When `int` >= 0, higher layers get applied after lower layers
function mod.setModLayer(int)
end

---# Evaluating Modification Transformation 
---------------------------------------------------------
--- @param Position Vector3 Needs {`x`,`y`,`z`} Table Transformation applied in TickLayer
--- @param Offset integer `yOffset` used for Spline Evaluating
--- @param ButtonIndex integer Something related to Buttons
--- @param ModAffection integer found in `mdv.lua` under any of the `mdv.MA_`
function mod.evaluateModTransform(Position, Offset, ButtonIndex, ModAffection)
end

---# Modification Track Pipeline
---------------------------------------------------------
--- @param TrackPipeType integer used to set custom shaders
--- @param ModAffection integer found in `mdv.lua` under any of the `mdv.MA_`
--- @param ShadedMesh mesh where the parameters are taken from
function mod.setTrackPipe(TrackPipeType,ModAffection,ShadedMesh)
end

---# Reseting Track Pipeline
---------------------------------------------------------
--- @param TrackPipeType integer used to set custom shaders
--- @param ModAffection integer found in `mdv.lua` under any of the `mdv.MA_`
function mod.resetTrackPipe(TrackPipeType,ModAffection)
end

---# Speed Modification
---------------------------------------------------------
--- @param Speed number The `number` thats put in it will change the `Highway Speed` can also be `Negative`
function mod.SetHispeed(Speed)
end


return mod
