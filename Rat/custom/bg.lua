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

local ModelTable = {
	{naming="gen",path="\\modelgen\\"},
}

local GameplayTable = {
	{naming="track",path="\\track\\"},
	{naming="button",path="\\button\\"},
	{naming="laser",path="\\laser\\"},
}

local ShaderTable = {
	{naming="grid",path="\\grid\\"},
	{naming="kaleidoscope",path="\\kaleidoscope\\"},
	{naming="pulse",path="\\pulse\\"},
	{naming="posturize",path="\\posturize\\"},
	{naming="spin",path="\\spin\\"},
}

local TrackSH
local LaserSH
local ButtonSH

local modelgen

local ObjectTable = {
	OBJ = "models/special/ellenjoe",
	Button = "models/Buttons/model",
	Laser = "models/Lasers/Laser"
}

local function validate_require(module_name)
    local success, result = pcall(require, module_name)
    if success then
        game.Print("Module '" .. module_name .. "' loaded successfully.")
        return result
    else
        game.Print("Error loading module '" .. module_name .. "': " .. result)
        return nil
    end
end

local OBJ = validate_require(ObjectTable.OBJ)
local Button = validate_require(ObjectTable.Button)
local Laser = validate_require(ObjectTable.Laser)

--all shorts are found in this file
dofile(BGPath.."template/vals.lua")

local function SetPipeLine(type,Shader)
	SetPipe(mdv.TP_MESH,type,Shader)
	SetPipe(mdv.TP_MATERIAL,type,Shader)
	SetPipe(mdv.TP_PARAMS,type,Shader)
end

local function CreateShader(shaderName, table, index, textureFileName, data, hasDepth, primitiveType, blendMode)
    local shaderInfo = table[index]
    local shaderPath = BGPath .. "shaders" .. shaderInfo.path

    shaderName = gfx.CreateShadedMesh(shaderName, shaderPath)
	if textureFileName then
    shaderName:AddTexture("myTexture", shaderPath .. textureFileName)
	end
	
	if data then
		shaderName:SetData(data)
	end

    if primitiveType then
        shaderName:SetPrimitiveType(shaderName.primitiveType)
    end

    if blendMode then
        shaderName:SetBlendMode(shaderName.blendMode)
    end

	if hasDepth then
	shaderName:SetDepthTest(hasDepth)
	end

    return shaderName
end


local function split_by_length(str, length)
    local result = {}
    for i = 1, #str, length do
        table.insert(result, str:sub(i, i + length - 1))
    end
    return result
end

function split_into_parts(str, num_parts)
    local result = {}
    local part_length = math.ceil(#str / num_parts)
    for i = 1, #str, part_length do
        table.insert(result, str:sub(i, i + part_length - 1))
    end
    return result
end

function split_by_space(str)
    local result = {}
    for word in string.gmatch(str, "%S+") do
        table.insert(result, word)
    end
    return result
end
	
local finaltext = ""
local lefttext = ""
local righttext = ""
local mmaker = ""

local SongTitle = gameplay.title
local ArtistTitle = gameplay.artist

local ArtistSplit = split_by_space(ArtistTitle)

local ArtistTitleSegmentL = ArtistSplit[1]
local ArtistTitleSegmentR = ArtistSplit[2]

local TextLib = {
	name = split_by_length(SongTitle,#SongTitle/2),
	artist = {split_into_parts(ArtistTitleSegmentL,3),split_into_parts(ArtistTitleSegmentR,3)}
}

local TT = {
	0.5,0.75,1.5,2.5,4.0
}

local arttal = {1.0,1.19,1.38}  --arttextappear left
local arttar = {2.0,2.19,2.38}  --arttextappear right
local modmaker = {3.0,3.19,3.38}
local ft     = {1.63,1.75,1.88} -- flash timer

local function setprop(amount)
	for i=0,amount do
		local ypos = (i)/amount
		ypos = ypos*ypos*ypos
		SplineProp(i,ypos,SpLinear)
	end

	for i = 0, amount do
		local val = inExpo(i/amount+0.25)*2
		val = -val
		ModSpline(i, val)
	end
end

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
		dofile(background.GetPath().."defMods.lua")

		--loadMod("setspeed")
		--loadMod("rotate")
		--loadMod("lanes")
		loadMod("lasermove")
		--loadMod("buttonsmove")
		--loadMod("side")
		--loadMod("Highway")
		--loadMod("change")

		--xero.setdefault{0.01,"BTA_M"}
		--xero.setdefault{0.01,"BTB_M"}

		TrackSH = CreateShader("track", GameplayTable, 1, "track2.png",nil,false, PRIM_TRIFAN, BLEND_NORM)

		ButtonSH = CreateShader("button",GameplayTable,2,nil,Button,true,nil,nil)

		LaserSH = CreateShader("laser",GameplayTable,3,nil,Laser,false,nil, nil)

		modelgen = track.CreateShadedMeshOnTrack("gen",background.GetPath().."shaders\\modelgen\\")

		modelgen:SetPrimitiveType(modelgen.PRIM_TRILIST)

		modelgen:AddTexture("Texture",background.GetPath().."shaders\\modelgen\\texture.png")

		modelgen:SetData(Button)

		modelgen:SetDepthTest(true)

		dofile(background.GetPath().."mods"..".lua")

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

local timbg = 0.0
local newbgtm = 0.0
local move = 0.0
local bouncebeat

function render_bg(deltaTime)
	timbg = timbg + deltaTime
	newbgtm = newbgtm + deltaTime
	move = move + deltaTime

	local r,b,g = game.GetLaserColor(0)
	local r1,b1,g1 = game.GetLaserColor(1)

	tr,tg,tb = r/255,g/255,b/255
	tr1,tg1,tb1 = r1/255,g1/255,b1/255

	local counter = 0
	local acounter = 0
	local bcounter = 0
	local ccounter = 0
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

	if gameplay.practice_setup then
		state = true
	else
		state = false
	end

	debuger(state,gTable.info,gTable.pos)

	timbg = timbg + impulse(background.GetBarTime()*2%1) * deltaTime * 10

	newbgtm = newbgtm + impulse(background.GetBarTime()) * deltaTime * 10

	--background.SetParamf("LUAtimer", timbg)

	TrackSH:SetParam("beat",background.GetBarTime()*2%1)
	TrackSH:SetParam("ksegments",8.0)
	TrackSH:SetParamVec4("color", 1.0, 1.0, 1.0, 0.5)
	TrackSH:SetParamVec4("color1", 0.0, 0.0, 0.0, 0.5)
	TrackSH:SetParamVec2("textureScale",1.0,1.0)
	TrackSH:SetParam("numColors",2)
	TrackSH:SetParam("bpm",bpm*0.01)

	LaserSH:SetParamVec3("colorL",r/255,b/255,g/255)
	LaserSH:SetParamVec3("colorR",r1/255,b1/255,g1/255)

	modelgen:SetPosition(0.0,1.25,1)
	modelgen:SetScale(1.0,1.0,1.0)
	--modelgen:SetRotation((1.0+bounce(background.GetBarTime()*4%1))*big,(1.0+bounce(background.GetBarTime()*2%1))*smol,(1.0+move)*90.0)
	modelgen:SetRotation((90.0*move)+0.0,0.0,0.0)

	--mod.LaneHide(bounce(background.GetBarTime()*4%1))

	SetPipeLine(mdv.MA_TRK,TrackSH)

	SetPipeLine(mdv.MA_BT,ButtonSH)

	SetPipeLine(mdv.MA_LS,LaserSH)

	gfx.Text(gameplay.gauge.value or "",100,500)

	gfx.Text("Laser",100,550)
	gfx.Text("Left   : "..tr.." "..tb.." "..tg,100,575)
	gfx.Text("Right: "..tr1.." "..tb1.." "..tg1,100,600)

	for index, value in ipairs(TT) do
		if beat >= value then
			counter = counter + 1
		end
	end

	for index, value in ipairs(arttal) do
		if beat >= value then
			acounter = acounter + 1
		end
	end
	
	for index, value in ipairs(arttar) do
		if beat >= value then
			bcounter = bcounter + 1
		end
	end

	for index, value in ipairs(modmaker) do
		if beat >= value then
			ccounter = ccounter + 1
		end
	end

	if counter == 1 then
		finaltext= TextLib.name[1]
	elseif counter == 2 then
		finaltext=TextLib.name[1]..TextLib.name[2]
	end

	if acounter == 1 then
		lefttext= TextLib.artist[1][1]
	elseif acounter == 2 then
		lefttext=TextLib.artist[1][1]..TextLib.artist[1][2]
	elseif acounter == 3 then
		lefttext=TextLib.artist[1][1]..TextLib.artist[1][2]..TextLib.artist[1][3]
	end

	if bcounter == 1 then
		righttext= TextLib.artist[2][1]
	elseif bcounter == 2 then
		righttext=TextLib.artist[2][1]..TextLib.artist[2][2]
	elseif bcounter == 3 then
		righttext=TextLib.artist[2][1]..TextLib.artist[2][2]..TextLib.artist[2][3]
	end

	if ccounter == 1 then
		mmaker = "Modchart"
	elseif ccounter == 2 then
		mmaker = "Modchart".." ".."made by"
	elseif ccounter == 3 then
		mmaker = "Modchart".." ".."made by".." ".."RealFD"
	end

	local scalebase = math.min(resx / 5, resy / 5)

	if beat <= 4.0 then
	gfx.TextAlign(gfx.TEXT_ALIGN_MIDDLE + gfx.TEXT_ALIGN_CENTER)
	gfx.FontSize(scalebase*0.9)
	gfx.Text(finaltext,resx/2,(resy/2)-scalebase*0.9)
	gfx.Text(lefttext.." "..righttext,resx/2,(resy/2)-scalebase*0.35)
	gfx.FontSize(scalebase*0.4)
	gfx.Text(mmaker,resx/2,(resy/2)+scalebase/4)
	end

	xero.update_command()
	
end

function render_ffg(deltaTime)
	modelgen:Draw()
	if gameplay.practice_setup ~= nil then
		gfx.ForceRender()
		xero.printmods{}
	end
end