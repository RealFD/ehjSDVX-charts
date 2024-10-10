--TODO(fd)

local BG_RealFD = background.GetPath().."realfd/"

-- Global Uniforms From RealFD
FD_U = {
	USM_data = {
				{{-1, -1}, {0, 0}},
				{{1, -1}, {1, 0}},
				{{-1, 1}, {0, 1}},
				{{1, -1}, {1, 0}},
				{{1, 1}, {1, 1}},
				{{-1, 1}, {0, 1}},
			},
	U_distort = 0,
	U_fuzzy = 0,
	U_gate_color = {255/255,255/255,255/255},
	U_gate_size = 1,
	U_gate_fade = 1,
}


local TAP_REC = require('realfd/tap_recep/tap_rec')
local tap_rec = TAP_REC.new(false)
local tapFX_rec = TAP_REC.new(true)

local g_res_x,g_res_y = game.GetResolution() 

local function loadDefMod(fileName)
	dofile(BG_RealFD.."/mods/"..fileName..".lua")
end
local function loadMod(fileName)
	dofile(BG_RealFD..fileName..".lua")
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
	SM_Distort = gfx.CreateShadedMesh("distort",BG_RealFD.."/shaders/"),
	SM_Fuzzy = gfx.CreateShadedMesh("fuzzy",BG_RealFD.."/shaders/"),
	SM_Gate = track.CreateShadedMeshOnTrack("gate",BG_RealFD.."/shaders/"),
	FBText = gfx.CreatefbTexture("FD_bgfb",g_res_x,g_res_y),
	renderDebugger = function(s)
		local r,b,g = game.GetLaserColor(0)
		local r1,b1,g1 = game.GetLaserColor(1)

		tr,tg,tb = r/255,g/255,b/255
		tr1,tg1,tb1 = r1/255,g1/255,b1/255
		
		local bpm = gameplay.bpm
		local barTimer, _, trackTimer = background.GetTiming()
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
		s.SM_Distort:SetData(FD_U.USM_data)
		s.SM_Distort:AddfbTexture("u_fb","FD_bgfb")
		s.SM_Fuzzy:SetData(FD_U.USM_data)
		s.SM_Fuzzy:AddfbTexture("u_fb","FD_bgfb")

	if U_REALFD then
		s.SM_Gate:SetPosition(0,10,0)
		s.SM_Gate:SetScale(5,5,5)
		s.SM_Gate:SetRotation(0,0,90)
		s.SM_Gate:SetData(FD_U.USM_data)
		--s.SM_Gate:SetPrimitiveType(s.SM_Gate.PRIM_TRIFAN)
		--s.SM_Gate:SetBlendMode(s.SM_Gate.BLEND_ADD)
	end
	
		loadDefMod("nerd")
		loadDefMod("swish")
		loadDefMod("test")
		loadDefMod("laser")
		loadDefMod("cam_ease")
		loadMod("mods")
	end,
	render_bg = function (s,deltaTime)
		if U_REALFD then
		local _ , _, trackTimer = background.GetTiming()
		s.SM_Gate:SetParam("u_time",trackTimer)
		s.SM_Gate:SetParamVec3("color",table.unpack(FD_U.U_gate_color))
		s.SM_Gate:SetParamVec2("u_resolution",g_res_x,g_res_y)
		s.SM_Gate:SetParam("u_gateSize",FD_U.U_gate_size)
		s.SM_Gate:SetParam("u_gateAlpha",FD_U.U_gate_fade)
		s.SM_Gate:Draw()
	end
	end,
	render_bfg = function (s,deltaTime)
		tapFX_rec:render(deltaTime)
		tap_rec:render(deltaTime)
	end,
	render_fg = function (s,deltaTime)

	end,
	render_ffg = function (s,deltaTime)
		gfx.ForceRender()
		gfx.SetfbTexture("FD_bgfb",0,0)
		s.SM_Distort:Draw()
		s.SM_Distort:SetParam("u_fade",FD_U.U_distort)
		s.SM_Fuzzy:Draw()
		s.SM_Fuzzy:SetParam("u_fade",FD_U.U_fuzzy)
	end
}

return bg