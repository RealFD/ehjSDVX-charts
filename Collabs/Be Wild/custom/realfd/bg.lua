--TODO(fd)

local function loadDefMod(fileName)
	dofile(background.GetPath().."realfd/mods/"..fileName..".lua")
end
local function loadMod(fileName)
	dofile(background.GetPath().."realfd/"..fileName..".lua")
end

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
		gfx.FontSize(16)
	end
end

local bg = {
	renderDebugger = function(s)
		local r,b,g = game.GetLaserColor(0)
		local r1,b1,g1 = game.GetLaserColor(1)

		tr,tg,tb = r/255,g/255,b/255
		tr1,tg1,tb1 = r1/255,g1/255,b1/255
		
		local bpm = gameplay.bpm
		barTimer, _, trackTimer = background.GetTiming()
		local currBeat = background.GetBeat()
		local beat = currBeat+background.GetBarTime()

		gfx.Text(gameplay.gauge.value or "",100,500)
		gfx.Text("Laser",100,520)
		gfx.Text("L     : "..tr.." "..tb.." "..tg,100,540)
		gfx.Text("R     : "..tr1.." "..tb1.." "..tg1,100,560)

		gfx.Text("bpm   :"..bpm,100,580)
		gfx.Text("bTimer: "..beat_to_str(barTimer),100,600)
		gfx.Text("cBeat : "..currBeat,100,620)
		gfx.Text("Beat  : "..currBeat,100,640)
	end,
	cleanup = function (s)
	end,
	init = function (s)
		loadDefMod("test")
		loadMod("mods")
	end,
	render_bg = function (s,deltaTime)
		
	end,
	render_fg = function (s,deltaTime)
		
	end,
	render_ffg = function (s,deltaTime)
		
	end
}

return bg