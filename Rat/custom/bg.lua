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

--all shorts are found in this file
dofile(background.GetPath().."template/vals.lua")

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

local setLaneMod = {
    {19.25, 1000, {ModNames.TansitionTable.Lane.A, ModNames.TansitionTable.Lane.B, ModNames.TansitionTable.Lane.C, ModNames.TansitionTable.Lane.D, ModNames.TansitionTable.Lane.LL, ModNames.TansitionTable.Lane.LR}},
    {19.50, 0, {ModNames.TansitionTable.Lane.A}},
	{19.55, 1000, {ModNames.TansitionTable.Lane.A}},
    {19.60, 0, {ModNames.TansitionTable.Lane.B}},
	{19.65, 1000, {ModNames.TansitionTable.Lane.B}},
    {19.75, 0, {ModNames.TansitionTable.Lane.C}},
	{19.80, 1000, {ModNames.TansitionTable.Lane.C}},
	{19.85, 0, {ModNames.TansitionTable.Lane.A}},
	{19.90, 1000, {ModNames.TansitionTable.Lane.A}},
	{20.0, 0, {ModNames.TansitionTable.Lane.A}},
	{20.05, 1000, {ModNames.TansitionTable.Lane.A}},
    {20.06, 0, {ModNames.TansitionTable.Lane.B}},
	{20.11, 1000, {ModNames.TansitionTable.Lane.B}},
    {20.12, 0, {ModNames.TansitionTable.Lane.C}},
	{20.17, 1000, {ModNames.TansitionTable.Lane.C}},
	{20.19, 0, {ModNames.TansitionTable.Lane.D}},
	{20.22, 1000, {ModNames.TansitionTable.Lane.D}},
	{20.50, 0, {ModNames.TansitionTable.Lane.A,ModNames.TansitionTable.Lane.B,ModNames.TansitionTable.Lane.C,ModNames.TansitionTable.Lane.D,ModNames.TansitionTable.Lane.LL,ModNames.TansitionTable.Lane.LR}},
}

--somhow add color pulse length + chromatic

local colorLibrary = {
	start = {	
		happy= {
			bg    = {242/255,151/255,194/255},
			stars = {241/255,180/255,71/255},
			obj   = {
				a = {230/255,140/255,174/255},
				b = {122/255,180/255,210/255},
				c = {242/255,196/255,96/255},
				d = {251/255,237/255,142/255},
				e = {249/255,246/255,233/255},
			},
		},
		sad = {
			bg    = {20/255,24/255,30/255},
			stars = {248/255,47/255,67/255},
			obj   = {
				a = {40/255,49/255,56/255},
				b = {12/255,13/255,16/255},
				c = {15/255,15/255,21/255},
				d = {53/255,41/255,64/255} -- on the split
			},
		},
	}, -- till time 24.139
	bgswitches = {
		a = {231/255,134/255,174/255},
		b = {251/255,198/255,81/255},
	}
}

--somehow make them sawp between the timer sceens


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

local bInit = false
function init()
	bInit = true
end

xero = {
	foreground = self,
	dir = background.GetPath()
}
dofile(background.GetPath().."template/std.lua")
dofile(background.GetPath().."template/sort.lua")
dofile(background.GetPath().."template/ease.lua")
dofile(background.GetPath().."template/template.lua")

local timbg = 0

function render_bg(deltaTime)
	timbg = timbg + deltaTime

	local counter = 0
	local acounter = 0
	local bcounter = 0
	local ccounter = 0

	background.DrawShader()
	
	local bpm = gameplay.bpm
	barTimer, offSync, trackTimer = background.GetTiming()
	local currBeat = background.GetBeat()
	local beat = currBeat+background.GetBarTime()
	gDeltaTime = deltaTime

	local gTable = {
		pos ={50,700},
		info = {{"bpm",bpm},{"barTimer",beat_to_str(barTimer)},{"offSync",offSync},{"trackTimer",trackTimer},{"currBeat",currBeat},{"beat",beat},{"gDeltaTime",gDeltaTime},{"TimeByBeat",background.GetTimeByBeat(39)}}
	}

	debuger(true,gTable.info,gTable.pos)

	--mod.LaneHide(0)

	timbg = timbg + impulse(background.GetBarTime()*2%1) * deltaTime * 10

	background.SetParamf("LUAtimer", timbg)

	if not bInit then
		mod.setDepthTest(mdv.MA_LS,false)
		mod.setDepthTest(mdv.MA_HLD,false)
		mod.setDepthTest(mdv.MA_BT,false)
		background.SetParamf("LUAalpha", 1)
		init()
		--mod.setMQTrack(1)
		--mod.setMQLaser(1)
		--mod.setMQHold(1)
		mod.setMQTrackNeg(1)
		mod.toggleModLines(0)

		-- xero
		xero.plr = 1
		dofile(background.GetPath().."defMods.lua")

		loadMod("setspeed")
		--loadMod("rotate")
		--loadMod("lanes")
		loadMod("lasermove")
		--loadMod("buttonsmove")
		loadMod("side")
		--loadMod("Highway")

		--xero.setdefault{0.01,"BTA_M"}
		--xero.setdefault{0.01,"BTB_M"}

		for _, set in ipairs(setLaneMod) do
			local value1, value2, labels = set[1], set[2], set[3]
			for _, label in ipairs(labels) do
				--xero.set{value1, value2, label}
			end
		end

		xero.ease{4,100,outElastic,math.pi/2,ModNames.RotationTable.Side.BH}
		xero.set{5,100,ModNames.RotationTable.Side.BH}
		xero.ease{113.25,2,spike,0,ModNames.RotationTable.Side.BH}

		xero.ease{6,1,flip(linear),0.5,ModNames.TansitionTable.Side.LS}
		xero.ease{8.2,1,flip(linear),0.5,ModNames.TansitionTable.Side.RS}
		xero.ease{6,1,flip(linear),1,ModNames.RotationTable.Side.LS}
		xero.ease{8.2,1,flip(linear),1,ModNames.RotationTable.Side.RS}

		--xero.ease{79,1,linear,40,"CH"}

		--xero.ease{90,1,linear,0.1,"CH"}

		xero.ease{109.5,2.5,bounce,64,"LaserSetWaveX"}
		xero.set{110.75,10000,"LaserSetWaveX"}
		xero.ease{109.5,2.5,bounce,64,"LaserSetWaveY"}
		xero.set{110.75,10000,"LaserSetWaveY"}

		--xero.ease{109.5,1.5,bounce,.5,ModNames.TansitionTable.Side.BH}

		--xero.ease{47.85,2,outSine,0,"idk"} -- pixel version ???

		--xero.ease{49.65,1,bell,0.75,ModNames.TansitionTable.Side.LS}
		--xero.ease{49.65,1,bell,0.75,ModNames.TansitionTable.Side.RS}

		--xero.ease{113,0,instant,100,ModNames.TansitionTable.Side.BH}

		xero.init_command()
	end

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
	
	gfx.Text(math.floor(timbg),100,200)
	
	local st = math.sin(trackTimer)*.5+.5
	local sc = {st,st,1.}
	local scaleMat = gfx.GetScaleMat(sc)
	----mod.SetCamModMat(gfx.MultMat(m,gfx.GetInverse(scale)))
	local matZoom = .5+.5*math.sin(beat)
	--mod.SetCamModMat(scaleMat)
	--gfx.SetNVGprojMat(gfx.GetScaleMat({0,0,0}))
	gfx.SetNVGprojMat(gfx.GetIdentMat())

	xero.update_command()
	
end
