dofile(background.GetPath().."user.lua")
local skade = require('skade/bg')
local realfd = require('realfd/bg')

OriginalXspeed = mod.GetHispeed()
function cleanup()
	mod.SetHispeed(OriginalXspeed)
	skade:cleanup()
	realfd:cleanup()
end

function loadMod(fileName)
	dofile(background.GetPath().."mods/"..fileName..".lua")
end

OriginalHispeed = 0
function init()
	OriginalHispeed	= OriginalXspeed*gameplay.bpm
	loadMod("hispeed")

	skade:init()
	realfd:init()

	--TODO(skade) careful, overwrite global state variables
	mod.setDepthTest(mdv.MA_LS,false)
	mod.setDepthTest(mdv.MA_HLD,false)
	mod.setDepthTest(mdv.MA_BT,false)
	--mod.setMQTrack(1)
	--mod.setMQLaser(1)
	--mod.setMQHold(1)
	mod.setMQTrackNeg(1)
	mod.toggleModLines(0)

	-- xero
	xero.init_command()
end

xero = {
	foreground = self,
	dir = background.GetPath()
}
dofile(background.GetPath().."template/std.lua")
dofile(background.GetPath().."template/sort.lua")
dofile(background.GetPath().."template/ease.lua")
dofile(background.GetPath().."template/template.lua")
xero.plr = 1

function render_bg(deltaTime)
	do-- reapply manual hispeed changes
		if game.GetButton(game.BUTTON_STA) then
			if (LSR_L_OLD_ROT ~= game.GetKnob(0) or
				LSR_R_OLD_ROT ~= game.GetKnob(1)) then
				OriginalXspeed = mod.GetHispeed()
			end
		end
		LSR_L_OLD_ROT = game.GetKnob(0)
		LSR_R_OLD_ROT = game.GetKnob(1)
	end
	skade:render_bg(deltaTime)

	xero.update_command()
end

function render_bfg(deltaTime)
	skade:render_bfg(deltaTime)
end

function render_fg(deltaTime)
	skade:render_fg(deltaTime)
end

function render_ffg(deltaTime)
	skade:render_ffg(deltaTime)

	gfx.ForceRender()
	local idt = {1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1}
	gfx.SetNVGmodMat(idt)

	_, _, trackTimer = background.GetTiming()
	local currBeat = background.GetBeat()
	local beat = (currBeat+background.GetBarTime())
	
	if U_SKADE then
		if gameplay.practice_setup ~= nil then
			gfx.Text("beat "..string.format("%.3f",currBeat),100,790)
			gfx.Text("beat "..string.format("%.3f",beat),100,800)
			gfx.Text("time "..string.format("%.3f",trackTimer),100,810)
		end
	elseif U_REALFD then
		realfd:renderDebugger()
	end
	if gameplay.practice_setup ~= nil then
		xero.printmods{}
	end
end
