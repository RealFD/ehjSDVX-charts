--TODO(fd)

local resx, resy = game.GetResolution()
local BGPath = background.GetPath()

local function beat_to_str(t)
	if t < 0.25	then return	"♪___"
	elseif t < 0.5 then	return "_♪__"
	elseif t < 0.75	then return	"__♪_"
	else return	"___♪"
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

local bg = {
	renderDebugger = function(s)
		local r,b,g = game.GetLaserColor(0)
		local r1,b1,g1 = game.GetLaserColor(1)

		--background.DrawShader()

		tr,tg,tb = r/255,g/255,b/255
		tr1,tg1,tb1 = r1/255,g1/255,b1/255
		
		local state
		
		local bpm = gameplay.bpm
		barTimer, offSync, trackTimer = background.GetTiming()
		local currBeat = background.GetBeat()
		local beat = currBeat+background.GetBarTime()
		gDeltaTime = deltaTime

		bouncebeat = (bpm*gameplay.hispeed)
		smol = bouncebeat/5.0
		big = bouncebeat/10.0

		local gTable = {
			pos ={50,700},
			info = {{"bpm",bpm},{"barTimer",beat_to_str(barTimer)},{"offSync",offSync},{"trackTimer",trackTimer},{"currBeat",currBeat},{"beat",beat},{"gDeltaTime",gDeltaTime},{"TimeByBeat",background.GetTimeByBeat(39)}}
		}

		if not gameplay.practice_setup then
			state = true
		else
			state = false
		end

		debuger(true,gTable.info,gTable.pos) --TODO(fd)

		--gfx.Text(gameplay.gauge.value or "",100,500)
		--gfx.Text("Laser",100,550)
		--gfx.Text("Left   : "..tr.." "..tb.." "..tg,100,575)
		--gfx.Text("Right: "..tr1.." "..tb1.." "..tg1,100,600)
	end,
}

return bg