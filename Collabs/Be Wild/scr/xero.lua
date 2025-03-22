---@meta

---> The [xero](xero.lua) class provides various things used in the Fork.
--->
--->
--->
---------------------------------------------------------
---> - `setdefault`
---> - `set`
---> - `ease`
---> - `add`
---> - `definemod`
---> - `reset`
---> - `perframe`
---> - `func`
---> - `func_ease`
---------------------------------------------------------
xero = {}

---------------------------------------------------------
---### Example
--- ```
--- xero.setdefault(20,"awesomeMod")
---
--- ```
---------------------------------------------------------
--- @param value number Set value to apply
--- @param mod string   The mod to apply.
function xero.setdefault(table)
end

---------------------------------------------------------
---### Example
--- ```
--- xero.set(20,5,"awesomeMod")
---
--- ```
---------------------------------------------------------
--- @param start number Starting beat of the ease
--- @param length number Lenght of the ease in beats
--- @param mod string	The mod to apply.
function xero.set(table)
end

--- @param start number Starting beat of the ease
--- @param length number Lenght of the ease in beats
--- @param easing function Easing function
--- @param percent number The target amount to set the mod to
--- @param mod string	The mod to apply.
--------------------------------------------------------
---### Example
--- ```
--- xero.ease{10, 5, "outExpo", 1, "awesomeMod"}
--- 
--- ```
function xero.ease(table)
end

--- @param start number Starting beat of the ease
--- @param length number Length of the ease in beats
--- @param easing function Easing function
--- @param percentR number Sets the target amount of the `mod` Relativ
--- @param mod string	The mod to apply.
---------------------------------------------------------
---## Example
--- ```
--- xero.add{10, 5, "outExpo", 1, "awesomeMod"}
--- ```
function xero.add(table)
end

--- @param modname string  Name of the mod when called perframe
--- @param funcs table    Can be 1 or multiple functions that are called every time the mod is changed perframe
---------------------------------------------------------
---## Example
--- ```
--- xero.definemod{modname, mod1, mod2, ..., function(beat, mod1, mod2, ...)
---     -- implementation
--- end}
--- ```
function xero.definemod(modname,funcs)
end

---@overload fun(beat: number)
---@overload fun(beat: number, exclude: table)
---@overload fun(beat: number, length: number, easing: function)
---@overload fun(beat: number, length: number, easing: function, exclude: table)
--- @param beat number Starting beat of the function
--- @param length number How long the function stays active
--- @param easing function Easing function
--- @param exlude function wich function to not reset
---------------------------------------------------------
---## Example
--- ```
--- xero.reset{50}
--- xero.reset{50, 2, "outExpo"}
--- xero.reset{50, exlude = "awesomeMod"}
--- xero.reset{50, 2, "outExpo", exclude = 'awesomeMod'}
--- ```
function xero.reset(...)
end

--- @param beat number Starting beat of the function
--- @param length number How long the function stays active
--- @param func table Can be a `function` or a `mod`
---------------------------------------------------------
---## Example
--- ```
--- xero.perframe{1, 2, "awesomeMod"}
--- ```
function xero.perframe(beat, length, func)
end

--- @param beat number Starting beat of the function
--- @param func function The function to run
---------------------------------------------------------
---### Example
--- ```
--- xero.func {1, function()
---     -- implementation
--- end}
--- ```
function xero.func(beat,func)
end

--- @param beat number	    The song beat when the function should begin being called.
--- @param length number	The length of beats when the function should be called.
--- @param easing function  Easing function
--- @param startP number     Starting value of the ease
--- @param endingP number    value of the ease is Ending on
--- @param func function	The function to run every frame in the range.
---------------------------------------------------------
---### Example
--- ```
--- xero.func_ease{0, 4, "outExpo", 0, 1, function(p)
---     -- implementation
--- end}
--- ```
function xero.func_ease(beat,length,easing,startP,endingP,func)
end