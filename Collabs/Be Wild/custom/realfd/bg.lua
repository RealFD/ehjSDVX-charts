--TODO(fd)

local BG_RealFD = background.GetPath().."realfd/"
local skin = game.GetSkin()
local skinpath = background.GetSkinsPath()..game.GetSkin()
local Baum = require("models.Tree")

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
	U_gate_color = {255./255,255./255,255./255},
	U_gate_size = 1,
	U_gate_pos = {0,3,-1},
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

ShaderResult = {}

local shaderPacks = {
    default = {},
    experimentalgear = {
        track = background.GetPath().."/shaders/exceedskin/",
        laser = background.GetPath().."/shaders/exceedskin/",
		texture = {
			entryL  = skinpath.."\\textures\\".."laser_entry_l.png",
			middleL = skinpath.."\\textures\\".."laser_l.png",
			exitL   = skinpath.."\\textures\\".."laser_exit_l.png",
			entryR  = skinpath.."\\textures\\".."laser_entry_r.png",
			middleR = skinpath.."\\textures\\".."laser_r.png",
			exitR   = skinpath.."\\textures\\".."laser_exit_r.png",
		}
    }
}

function Skinfilter(name)
    -- Extract the folder name (before the first hyphen) or use the full name if no hyphen exists
    local filteredName = string.lower(name:match("^[^-]+") or name:match("^.+"))
    
    game.Print(filteredName) -- Print the filtered name for debugging
    
    -- Check if the filtered name exists in the shaderPacks table
    if shaderPacks[filteredName] then
        ShaderResult = shaderPacks[filteredName]
        game.Print("Using shader pack: " .. filteredName)
    else
        game.Print("NOT ON THE LIST USING FALLBACK INSTEAD")
        ShaderResult = {
            track = background.GetPath().."/shaders/fallback/",
            laser = background.GetPath().."/shaders/fallback/",
            texture = {
                entryL  = background.GetPath().."/shaders/fallback/texture/laser_entry_l.png",
                middleL = background.GetPath().."/shaders/fallback/texture/laser_l.png",
                exitL   = background.GetPath().."/shaders/fallback/texture/laser_exit_l.png",
                entryR  = background.GetPath().."/shaders/fallback/texture/laser_entry_l.png",
                middleR = background.GetPath().."/shaders/fallback/texture/laser_l.png",
                exitR   = background.GetPath().."/shaders/fallback/texture/laser_exit_l.png",
            }
        }
    end
end


local function beat_to_str(t)
	if t < 0.25	then return	"♪___"
	elseif t < 0.5 then	return "_♪__"
	elseif t < 0.75	then return	"__♪_"
	else return	"___♪"
	end
end

local testTimer = 0

local LSshaderP = BG_RealFD.."/shaders/"

Skinfilter(skin)

local bg = {
	SM_Tree = track.CreateShadedMeshOnTrack("tree",BG_RealFD.."/shaders/"),
	treeCam = {1,0,0,0,
	           0,1,0,0,
			   0,0,1,0,
			   0,0,0,1},
	SM_Distort = gfx.CreateShadedMesh("distort",BG_RealFD.."/shaders/"),
	SM_Fuzzy = gfx.CreateShadedMesh("fuzzy",BG_RealFD.."/shaders/"),
	SM_Gate = track.CreateShadedMeshOnTrack("gate",BG_RealFD.."/shaders/"),
	FBText = gfx.CreatefbTexture("FD_bgfb",g_res_x,g_res_y),

	LaserSH = gfx.CreateShadedMesh("laser", ShaderResult.laser),
	TrackSH = gfx.CreateShadedMesh("track", ShaderResult.track),

	renderDebugger = function(s)
		local r,b,g = game.GetLaserColor(0)
		local r1,b1,g1 = game.GetLaserColor(1)

		tr,tg,tb = r,g,b
		tr1,tg1,tb1 = r1,g1,b1
		
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

		s.SM_Gate:SetPosition(table.unpack(FD_U.U_gate_pos))
		s.SM_Gate:SetScale(7,7,7)
		s.SM_Gate:SetRotation(0,0,90)
		s.SM_Gate:SetData(FD_U.USM_data)
		--s.SM_Gate:SetPrimitiveType(s.SM_Gate.PRIM_TRIFAN)
		--s.SM_Gate:SetBlendMode(s.SM_Gate.BLEND_MULT)
	
		s.SM_Tree:SetData(Baum)
		s.SM_Tree:AddTexture("tex1",background.GetPath().."models/test.png")
		s.SM_Tree:SetDepthTest(true)
		s.SM_Tree:SetDepthMask(true)

		s.LaserSH:AddTexture("l_entry", ShaderResult.texture.entryL)
		s.LaserSH:AddTexture("l_middle", ShaderResult.texture.middleL)
		s.LaserSH:AddTexture("l_exit", ShaderResult.texture.exitL)
		s.LaserSH:AddTexture("r_entry", ShaderResult.texture.entryR)
		s.LaserSH:AddTexture("r_middle", ShaderResult.texture.middleR)
		s.LaserSH:AddTexture("r_exit", ShaderResult.texture.exitR)

		s.LaserSH:SetPrimitiveType(s.LaserSH.PRIM_TRILIST)
		s.LaserSH:SetBlendMode(s.LaserSH.BLEND_ADD)

--[[

		local mt = debug.getmetatable(globals)

		if mt and type(mt.__index) == "function" then
			local keysToCheck = {
				"songInfoFillC", "scoreFillC", "critLineFillC", 
				"consoleFillC", "gaugeFillC", "bannerFillC", 
				"LaserLeftFillC", "LaserRightFillC"
			}
		
			for _, baseName in ipairs(keysToCheck) do
				local exists = false
				local index = 1
				local key = baseName .. tostring(index)
		
				-- Check if at least one entry exists
				while mt.__index(globals, key) ~= nil do
					if index == 1 then
						print(baseName .. " exists and contains:")
						exists = true
					end
					print("  " .. key .. ":", mt.__index(globals, key))
					index = index + 1
					key = baseName .. tostring(index)
				end
		
				if not exists then
					print(baseName .. " does not exist")
				end
			end
		else
			print("Metatable does not exist or __index is not a function")
		end
]]

		--mod.setTrackPipe(mdv.TP_MATERIAL,mdv.MA_LS,s.LaserSH)
		--mod.setTrackPipe(mdv.TP_PARAMS,mdv.MA_LS,s.LaserSH)

		loadDefMod("ln_swapper")
		loadDefMod("zigzag")
		loadDefMod("swish")
		loadDefMod("test")
		loadDefMod("cam_ease")
		loadMod("mods")
	end,
	render_bg = function (s,deltaTime)
		testTimer = testTimer + deltaTime
		local _ , _, trackTimer = background.GetTiming()
		treeCam = gfx.MultMat(gfx.GetRotMat({0,0,0}),gfx.GetTransMat({0,8,126}),gfx.GetRotMat({-90,0,0}))
		s.SM_Tree:SetParamMat4("u_cam",treeCam)
		s.SM_Tree:SetParam("u_time",testTimer)
		s.SM_Tree:Draw()
		s.SM_Gate:SetParam("u_time",trackTimer)
		s.SM_Gate:SetParamVec3("color",table.unpack(FD_U.U_gate_color))
		s.SM_Gate:SetParamVec2("u_resolution",g_res_x,g_res_y)
		s.SM_Gate:SetParam("u_gateSize",FD_U.U_gate_size)
		s.SM_Gate:SetParam("u_gateAlpha",FD_U.U_gate_fade)
		s.SM_Gate:Draw()

		if globals["LaserLeftFillC1"] or globals["LaserRightFillC1"] then
			local lr,lg,lb,la = table.unpack(Sgt.get("LaserLeftFillC",4))
			local rr,rg,rb,ra = table.unpack(Sgt.get("LaserRightFillC",4))
	
			s.LaserSH:SetParamVec4("l_color",lr/255.,lg/255.,lb/255.,la/255.)
			s.LaserSH:SetParamVec4("r_color",rr/255.,rg/255.,rb/255.,ra/255.)

			mod.setTrackPipe(mdv.TP_MATERIAL,mdv.MA_LS,s.LaserSH)
			mod.setTrackPipe(mdv.TP_PARAMS,mdv.MA_LS,s.LaserSH)

			s.TrackSH:SetParamVec4("l_color",lr/255.,lg/255.,lb/255.,la/255.)
			s.TrackSH:SetParamVec4("r_color",rr/255.,rg/255.,rb/255.,ra/255.)

			mod.setTrackPipe(mdv.TP_MATERIAL,mdv.MA_TRK,s.TrackSH)
			mod.setTrackPipe(mdv.TP_PARAMS,mdv.MA_TRK,s.TrackSH)

			--game.Print(string.format("LEFT  =  %s / %s / %s / %s",lr,lg,lb,la))
			--game.Print(string.format("RIGHT =  %s / %s / %s / %s",rr,rg,rb,ra))
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