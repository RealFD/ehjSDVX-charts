dofile(background.GetPath().."bg0.lua")

dofile(background.GetPath().."user.lua")
local skade = require('skade/bg')
local realfd = require('realfd/bg')
Sgt = require('template/ehj/sharedGlobalTable')

OriginalXspeed = mod.GetHispeed()
function cleanup()
	mod.SetHispeed(OriginalXspeed)
	skade:cleanup()
	realfd:cleanup()

	do

		globals.bannerOpacity = 0
		globals.critLineAlpha = 1

		--  set("name",{r,g,b,a}) --
		Sgt.set("songInfoFillC",{1,1,1,1})
		Sgt.set("scoreFillC",{1,1,1,1})
		Sgt.set("critLineFillC",{1,1,1,1})
		Sgt.set("consoleFillC",{1,1,1,1})
		Sgt.set("gaugeFillC",{1,1,1,1})
		Sgt.set("bannerFillC",{1,1,1,1})

		if globals["LaserLeftFillCisSet"] then
			local r,g,b = game.GetLaserColor(0)
			Sgt.set("LaserLeftFillC",{r,g,b,255})
		end
		if globals["LaserRightFillCisSet"] then
			local r,g,b = game.GetLaserColor(1)
			Sgt.set("LaserRightFillC",{r,g,b,255})
		end
	end

	-- reset camera parameters
	local idt = {1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1}
	mod.SetCamModMat(idt)
	gfx.SetNVGprojMat(idt)
	gfx.SetNVGprojMatSkin(idt)
	gfx.SetNVGmodMat(idt)
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

	mod.setTickLayer(1)
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

-- background uniforms
Ubgfs = {
	alpha = 1,
}

function button_hit(btn, rating, delta)
	skade:button_hit(btn,rating,delta)
end

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

	background.SetParamf("u_alpha",Ubgfs.alpha)
	background.DrawShader()

	realfd:render_bg(deltaTime)

	xero.update_command()
end

function render_bfg(deltaTime)
	realfd:render_bfg(deltaTime)
	skade:render_bfg(deltaTime)
end

function render_fg(deltaTime)
	skade:render_fg(deltaTime)
end

function render_ffg(deltaTime)
	skade:render_ffg(deltaTime)
	realfd:render_ffg(deltaTime)
	gfx.ForceRender()
	local idt = {1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1}
	gfx.SetNVGmodMat(idt)

	local _, _, trackTimer = background.GetTiming()
	local currBeat = background.GetBeat()
	local beat = (currBeat+background.GetBarTime())
	
	if U_SKADE then
		if gameplay.practice_setup ~= nil then
			gfx.Text("beat "..string.format("%.3f",currBeat),100,790)
			gfx.Text("beat "..string.format("%.3f",beat),100,800)
			gfx.Text("time "..string.format("%.3f",trackTimer),100,810)
		end
	elseif U_REALFD then
		if gameplay.practice_setup ~= nil then
			local labels = {"Song Info", "Score", "Critline", "Console", "Gauge", "Banner","Laser Left","Laser Right"}
			local values = {
				Sgt.get("songInfoFillC", 4),
				Sgt.get("scoreFillC", 4),
				Sgt.get("critLineFillC", 4),
				Sgt.get("consoleFillC", 4),
				Sgt.get("gaugeFillC", 4),
				Sgt.get("bannerFillC", 4),
				Sgt.get("LaserLeftFillC",4),
				Sgt.get("LaserRightFillC",4)
			}
			
			local charWidth = 10
			local spacePadding = 10

			-- Calculate the maximum label width by multiplying the length of each label by the charWidth
			local maxLabelWidth = 0
			for i = 1, #labels do
				local labelWidth = #labels[i] * charWidth
				maxLabelWidth = math.max(maxLabelWidth, labelWidth)
			end

			-- Starting X position for the labels
			local xPosition = 100
			local yPosition = 790

			gfx.BeginPath()
			gfx.FillColor(255,255,255,255)
			local equalsPosition = xPosition + maxLabelWidth + spacePadding
			gfx.FontSize(32)
			-- Use a for loop to display the text
			for i = 1, #labels-2 do
				gfx.Text(string.format("%s", labels[i]), xPosition, yPosition)
				gfx.Text("=", equalsPosition, yPosition)
				gfx.Text(string.format(" %.1f / %.1f / %.1f / %.1f", values[i][1],values[i][2],values[i][3],values[i][4]), equalsPosition+xPosition/2, yPosition)
				yPosition = yPosition + 22  -- Adjust the vertical spacing between each line
			end
		end

		realfd:renderDebugger()
	end
	if gameplay.practice_setup ~= nil then
		gfx.FontSize(16)
		xero.printmods{}
	end
end
