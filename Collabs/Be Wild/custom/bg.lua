function loadMod(fileName)
	dofile(background.GetPath().."mods/"..fileName..".lua")
end

OriginalXspeed = mod.GetHispeed()
OrigianlHispeed = 0
function cleanup()
    mod.SetHispeed(OriginalXspeed)
    OriginalHispeed = OriginalXspeed*gameplay.bpm
end

resx, resy = game.GetResolution()

BGPath = background.GetPath()

local function beat_to_str(t)
    if t < 0.25 then return "♪___"
    elseif t < 0.5 then return "_♪__"
    elseif t < 0.75 then return "__♪_"
    else return "___♪"
    end
end

local function debuger(state,tab,pos)
	if state then
		gfx.BeginPath()
		gfx.FillColor(0,0,0)
		gfx.Rect(pos[1]-10,pos[2], 500 , pos[2]/2.5)
		gfx.Fill()
		gfx.FillColor(255,255,255)
		gfx.FontSize(32)
		for index, value in ipairs(tab) do
			gfx.Text(string.upper(value[1]),pos[1],pos[2]+(index*32))
			gfx.Text(tostring(value[2]),pos[1]+160,pos[2]+(index*32))
		end
	end
end

function init()
		mod.setDepthTest(mdv.MA_LS,false)
		mod.setDepthTest(mdv.MA_HLD,false)
		mod.setDepthTest(mdv.MA_BT,false)
		--mod.setMQTrack(1)
		--mod.setMQLaser(1)
		--mod.setMQHold(1)
		mod.setMQTrackNeg(1)
		mod.toggleModLines(0)

		-- xero
		xero.plr = 1

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

function render_bg(deltaTime)
	
	local state
	
	local bpm = gameplay.bpm
	barTimer, offSync, trackTimer = background.GetTiming()
	local currBeat = background.GetBeat()
	local beat = currBeat+background.GetBarTime()
	gDeltaTime = deltaTime

	bouncebeat = (bpm*gameplay.hispeed)
	smol = bouncebeat/5.0
	big = bouncebeat/10.0

	do 
		local gTable = {
			pos ={50,700},
			info = {{"bpm",bpm},{"barTimer",beat_to_str(barTimer)},{"offSync",offSync},{"trackTimer",trackTimer},{"currBeat",currBeat},{"beat",beat},{"gDeltaTime",gDeltaTime},{"TimeByBeat",background.GetTimeByBeat(39)}}
		}

		if gameplay.practice_setup then
			state = true
		else
			state = false
		end
	
		debuger(state,gTable.info,gTable.pos)
	end

	debuger(state,gTable.info,gTable.pos)

	--gfx.Text(gameplay.gauge.value or "",100,500)
	--gfx.Text("Laser",100,550)
	--gfx.Text("Left   : "..tr.." "..tb.." "..tg,100,575)
	--gfx.Text("Right: "..tr1.." "..tb1.." "..tg1,100,600)

	xero.update_command()
end

function render_fg(deltaTime)
end

function render_ffg(deltaTime)
	if gameplay.practice_setup ~= nil then
		gfx.ForceRender()
		local idt = {1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1}
		gfx.SetNVGmodMat(idt)

		_, _, trackTimer = background.GetTiming()
		local currBeat = background.GetBeat()
		local beat = (currBeat+background.GetBarTime())
		
		gfx.Text("beat "..string.format("%.3f",currBeat),100,790)
		gfx.Text("beat "..string.format("%.3f",beat),100,800)
		gfx.Text("time "..string.format("%.3f",trackTimer),100,810)
		xero.printmods{}
	end
end
