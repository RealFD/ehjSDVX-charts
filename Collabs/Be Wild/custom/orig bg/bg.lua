
local delayedOperations = {
	u={},
	speed=nil
}
local dark = game.GetSkinSetting("dark_mode") or game.GetSkinSetting("dark_bgs")

-- backgroundTextures
local bt = {
	redDusk={"red_dusk.jpg", "red_dusk-c.jpg"},
	blank={"blank.png", "blank.png"}
}

-- backgroundComposition
local function bc(bt, opts)
	local out = {}
	for k,v in pairs(bt) do out[k] = v end
	for k,v in pairs(opts) do out[k] = v end
	return out
end

local pt = {
	lightsPink={"lights_pink.png", "lights_pink-c.png"}
}

local bgs = {
	waveRed={
		Bg={ Base={Tex=bt.redDusk, ScaleSoft=true}},
		Tunnel={
			Tex={"wave-red.png","wave-red-c.png"},
			u={Sides=4, Stretch=0.15, ScaleX=0.8, ScaleY=0.8, FlashEffect=true, Fog=20.0}
		},
		Center={ Tex={{"moon_pink.png","moon_pink-c.png"},{0}}, u={Scale=8.0, OffsetY=-0.05}, LayerEffect={Tex="moon_pink_shine.png", Glow=true, DodgeBlend=true, Scale=0.8} },
		Particle={ Tex=pt.lightsPink, u={OffsetY=-0.02, Amount=4, Speed=2.0} },
	}
}

local function stringToNumber(str)
	local number = 0
	for i = 1, string.len(str) do
		number = number + string.byte(str, i)
	end
	return number
end

local function sign(x)
	return x>0 and 1 or x<0 and -1 or 0
end

local function setUniform(key, value)
	local valueType = type(value)
	if valueType == "number" then
		background.SetParamf(key, value)
	elseif valueType == "boolean" then
		background.SetParami(key, value and 1 or 0)
	else
		game.Log("Weird param type was passed to setUniform", 1)
	end
end

-----------------
-- PARTICLE STUFF
-----------------

local resx, resy = game.GetResolution()
local portrait = resy > resx
local desw = portrait and 720 or 1280
local desh = desw * (resy / resx)
local scale = resx / desw

local shouldRenderParticles = false
local particleTextures = {}
local particles = {}
local psizes = {}

local particleCount = 30
local particleSizeSpread = 0.5

local function initializeParticle(initial)
	local particle = {}
	particle.x = math.random()
	particle.y = math.random() * 1.2 - 0.1
	if not initial then particle.y = -0.1 end
	particle.r = math.random()
	particle.s = (math.random() - 0.5) * particleSizeSpread + 1.0
	particle.xv = 0
	particle.yv = 0.1
	particle.rv = math.random() * 2.0 - 1.0
	particle.p = math.random() * math.pi * 2
	particle.t = math.random(1, #psizes)
	return particle
end

local function renderParticles(deltaTime)
	local alpha = 0.3 + 0.5 * background.GetClearTransition()
	for i,p in ipairs(particles) do
		p.x = p.x + p.xv * deltaTime
		p.y = p.y + p.yv * deltaTime
		p.r = p.r + p.rv * deltaTime
		p.p = (p.p + deltaTime) % (math.pi * 2)
		
		p.xv = 0.5 - ((p.x * 2) % 1) + (0.5 * sign(p.x - 0.5))
		p.xv = math.max(math.abs(p.xv * 2) - 1, 0) * sign(p.xv)
		p.xv = p.xv * p.y
		p.xv = p.xv + math.sin(p.p) * 0.01
		
		gfx.Save()
		gfx.ResetTransform()
		gfx.Translate(p.x * resx, p.y * resy)
		gfx.Rotate(p.r)
		gfx.Scale(p.s * scale, p.s * scale)
		gfx.BeginPath()
		gfx.GlobalCompositeOperation(gfx.BLEND_OP_LIGHTER)
		gfx.ImageRect(-psizes[p.t]/2, -psizes[p.t]/2, psizes[p.t], psizes[p.t], particleTextures[p.t], alpha, 0)
		gfx.Restore()
		if p.y > 1.1 then 
			particles[i] = initializeParticle(false)
		end
	end
	gfx.ForceRender()
end

local function getRandomItemFromArray(array, seed)
	if #array == 1 then return array[1] end

	local weightedArray = {}
	for i, value in ipairs(array) do
		local weight = value.weight or 1
		for j = 1, weight do
			weightedArray[#weightedArray+1] = value
		end
	end

	math.randomseed(stringToNumber(seed))
	return weightedArray[math.random(#weightedArray)]
end

local function getImageDimensions(imagePath)
	return gfx.ImageSize( gfx.CreateImage(background.GetPath().."textures/"..imagePath, 0) )
end

local function filterArray(array, propertyToRemove)
	local newArray = {}
	for i, v in ipairs(array) do
		if not v[propertyToRemove] then newArray[#newArray+1] = v end
	end
	return newArray
end

local function filterTable(table, propertyToRemove)
	local newTable = {}
	for k, v in pairs(table) do
		if not v[propertyToRemove] then newTable[k] = v end
	end
	return newTable
end

local function loadTextures(prefix, tex, subFolder, checkAnim, noAnimCallback, setNormalVersion)
	local texture
	if type(tex) == "string" then
		texture = {tex}
	elseif type(tex[1]) == "string" then
		texture = tex
	else
		if dark then tex = filterArray(tex, "bright") end
		if bgNestedIndices and bgNestedIndices[prefix] then
			texture = tex[bgNestedIndices[prefix]]
		else
			texture = getRandomItemFromArray(tex, prefix..gameplay.title..gameplay.artist) -- todo: improve seeding
		end
	end

	if texture[1] == 0 then
		return false
	end

	if texture[1] then
		if setNormalVersion then
			setUniform(prefix.."NormalVersion", true)
		end
		background.LoadTexture(prefix.."Tex", "textures/"..subFolder.."/"..texture[1])
	end
	if texture[2] then
		setUniform(prefix.."ClearVersion", true)
		background.LoadTexture(prefix.."ClearTex", "textures/"..subFolder.."/"..texture[2])
	end
	if checkAnim and texture[1] then
		local w, h = getImageDimensions(subFolder.."/"..texture[1])
		if w / h > 2 then
			setUniform(prefix.."Anim", true)
			setUniform(prefix.."AnimFramesCount", math.floor(w / 600))
		elseif noAnimCallback then
			noAnimCallback(w, h)
		end
	end

	if texture.u then
		for k,v in pairs(texture.u) do
			delayedOperations.u[k] = v
		end
	end
	if texture.speed then delayedOperations.speed = texture.speed end
	return true
end

local function setUniformsRaw(uniforms)
	for k,v in pairs(uniforms) do setUniform(k, v) end
end

local function setUniforms(prefix, uniforms, subFolder, checkAnim, noAnimCallback)
	for k, v in pairs(uniforms) do
		if k == "Tex" then
			loadTextures(prefix, v, subFolder, checkAnim, noAnimCallback)
		else
			setUniform(prefix..k, v)
		end
	end
end

local function loadPart(prefix, part, subFolder, checkAnim, setNormalVersion)
	local loaded
	if part.Tex then
		loaded = loadTextures(prefix, part.Tex, subFolder, checkAnim, nil, setNormalVersion)
	else
		loaded = true
	end
	if loaded then
		setUniform(prefix, true)
	end
	if part.u then
		setUniforms(prefix, part.u, subFolder)
	end
end

local function randomItemFromTable(table)
	local keys = {}
	for key, value in pairs(table) do
		local weight = value.weight or 1
		for i = 1, weight do
			keys[#keys+1] = key
		end
	end
	local index = keys[math.random(#keys)]
	return table[index], index
end

local function processDelayedOperations()
	setUniformsRaw(delayedOperations.u)
	if delayedOperations.speed then background.SetSpeedMult(delayedOperations.speed) end
end

local function loadBackground(bg)
	if bg.Bg then
		local part = bg.Bg
		local prefix = "Bg"
		loadPart(prefix, part, "background")
		if part.Base then
			setUniform(prefix.."Base", true)
			setUniforms(prefix.."Base", part.Base, "background", true, function(w,h) setUniform(prefix.."Base".."AR", w / h) end)
		end
		if part.Overlay then
			setUniform(prefix.."Overlay", true)
			setUniforms(prefix.."Overlay", part.Overlay, "background")
		end
		if part.Layer then
			setUniform(prefix.."Layer", true)
			setUniforms(prefix.."Layer", part.Layer, "layer", true)
		end
	end
	if bg.Center then
		local part = bg.Center
		local prefix = "Center"
		loadPart(prefix, part, "center", true, true)
		if part.LayerEffect then
			setUniform(prefix.."LayerEffect", true)
			setUniforms(prefix.."LayerEffect", part.LayerEffect, "center")
		end
	end
	if bg.Tunnel then
		local part = bg.Tunnel
		local prefix = "Tunnel"
		loadPart(prefix, part, "tunnel")
	end
	if bg.Particle then
		local part = bg.Particle
		local prefix = "Particle"
		loadPart(prefix, part, "particle")
	end

	background.SetSpeedMult(bg.speed or 1.0)

	processDelayedOperations()

	if bg.luaParticleEffect then
		shouldRenderParticles = true
		for i, p in ipairs(bg.luaParticleEffect.particles) do
			particleTextures[i] = gfx.CreateImage(background.GetPath().."textures/luaparticle/" .. p[1], 0)
			psizes[i] = p[2]
		end
		for i=1,particleCount do
			particles[i] = initializeParticle(true)
		end
	end
end

if dark then
	bgs = filterTable(bgs, "bright")
end

math.randomseed(stringToNumber(gameplay.title))
local bg, k = randomItemFromTable(bgs)
game.Log("bg:", 0)
game.Log(tostring(k), 0)
if bgTrumpcard then bg = bgTrumpcard end
loadBackground(bg)

----
-- render
----

-- images
local ABB1 = gfx.CreateImage(background.GetPath() .. "bg/1.png", 0)
local ABB2 = gfx.CreateImage(background.GetPath() .. "bg/2.png", 0)
local ABB3 = gfx.CreateImage(background.GetPath() .. "bg/3.png", 0)
local ABB4 = gfx.CreateImage(background.GetPath() .. "bg/4.png", 0)
local ABB5 = gfx.CreateImage(background.GetPath() .. "bg/5.png", 0)
local ABB6 = gfx.CreateImage(background.GetPath() .. "bg/6.png", 0)
local ABBN = gfx.CreateImage(background.GetPath() .. "bg/night.png", 0)
local ABBC = gfx.CreateImage(background.GetPath() .. "bg/cover.png", 0)
local ABBB = gfx.CreateImage(background.GetPath() .. "bg/black.png", 0)

local bgw = 2048
local bgh = 2048

-- chads
local bg_alpha = 0
local bg_alpha1 = 0
local bg_alpha2 = 0
local bg_alpha3 = 0
local bg_alpha4 = 0
local bg_alpha5 = 0
local bg_alphaN = 0
local ABscale = 0.5

-- timer
local timer = 0
local barTimer = 0
local offSync = 0
local blink_timer = 0
local shake_timer = 0
local fade_timer = 0

local oldTimer = 0
local function getDeltaTimeChart(timer)
	local result = timer - oldTimer
	oldTimer = timer
	return result
end

local echoTimer = 0
function echo(x, y, w, h, tex, a, duration, deltaTimeChart)
	
	gfx.Save()
	if echoTimer < duration then
	
		echoTimer = echoTimer + deltaTimeChart
		echoAlpha = a - (echoTimer/duration)*a
		
		gfx.Translate(0,50);
		
		gfx.BeginPath()
		gfx.Scale(1+echoTimer, 1+echoTimer)
		gfx.ImageRect(x,y-50,w,h,tex, echoAlpha*0.4, 0)
		
		gfx.BeginPath()
		gfx.Scale(1+echoTimer, 1+echoTimer)
		gfx.ImageRect(x,y-50,w,h,tex, echoAlpha*0.3, 0)
		
		gfx.BeginPath()
		gfx.Scale(1+echoTimer, 1+echoTimer)
		gfx.ImageRect(x,y-50,w,h,tex, echoAlpha*0.2, 0)
	end
	
	gfx.Restore()
end

function echoReset()
	echoTimer = 0
	echoAlpha = 1
end

local bpm = 219.2

function render_bg(deltaTime)
	
	-- timing stuff
	barTimer, offSync, timer = background.GetTiming()
	deltaTimeChart = getDeltaTimeChart(timer)
	
	if shouldRenderParticles then renderParticles(deltaTime) end
	
	gfx.Save()
	gfx.ResetTransform()
	gfx.BeginPath()
	
	
	if timer < 23 then
		background.DrawShader()
	end
	
	--gfx.GlobalCompositeOperation(gfx.BLEND_OP_LIGHTER)
	
	--
	-- render after shader
	--
	
	laser, spin = background.GetTilt()
	
	if timer >= 1 and timer <= 23 then
		
		-- borders
		gfx.Translate((resx/2),(resy/3))
		gfx.Scale(scale*ABscale,scale*ABscale)
		gfx.ImageRect(-bgw/2+bgw, -bgh/2, bgw, bgh, ABBB, bg_alpha*1.5, 0)
		gfx.BeginPath()
		gfx.ImageRect(-bgw/2-bgw, -bgh/2, bgw, bgh, ABBB, bg_alpha*1.5, 0)
		-- borders		
	end
	
	gfx.Save()
	gfx.ResetTransform()
	gfx.BeginPath()
	gfx.Translate((resx/2),(resy/3))
	gfx.Scale(scale*ABscale,scale*ABscale)
	
	if timer >= 7 and timer < 10 then
		bg_alpha = bg_alpha + deltaTimeChart*0.1
		gfx.ImageRect(-bgw/2, -bgh/2, bgw, bgh, ABB4, bg_alpha, 0)
	end
	
	if timer >= 10 and timer < 23 then
		bg_alpha = bg_alpha + deltaTimeChart*0.054
		gfx.ImageRect(-bgw/2, -bgh/2, bgw, bgh, ABB4, bg_alpha, 0)
	end
	
	if timer >= 23 and timer < 52 then
		bg_alpha3 = bg_alpha3 + deltaTimeChart*0.035
		gfx.ImageRect(-bgw/2, -bgh/2, bgw, bgh, ABB4, bg_alpha, 0)
		gfx.ImageRect(-bgw/2, -bgh/2, bgw, bgh, ABB3, bg_alpha3, 0)
		
		if timer >= 38 and timer <= 38.5 then
			echo(-bgw/2, -bgh/2, bgw, bgh, ABB3, bg_alpha, 0.5, deltaTimeChart)
		end
		
		if timer >= 38.5 and timer <= 40 then echoReset() end
		
		if timer >= 40 and timer <= 40.5 then
			echo(-bgw/2, -bgh/2, bgw, bgh, ABB3, bg_alpha, 0.5, deltaTimeChart)
		end
		
		if timer >= 40.5 and timer <= 42.2 then echoReset() end
		
		if timer >= 42.2 and timer <= 42.7 then
			echo(-bgw/2, -bgh/2, bgw, bgh, ABB3, bg_alpha, 0.5, deltaTimeChart)
		end
		
		if timer >= 42.7 and timer <= 44.5 then echoReset() end
		
		if timer >= 44.5 and timer <= 45 then
			echo(-bgw/2, -bgh/2, bgw, bgh, ABB3, bg_alpha, 0.5, deltaTimeChart)
		end
		
		if timer >= 45 then echoReset() end
		
	end
	
	if timer >= 38 and timer < 51 then
		shake_timer = shake_timer + deltaTimeChart
		ABscale = 0.5+math.abs((math.sin(shake_timer*math.pi*3.653)))*0.05*(1-(shake_timer/13)^4)
	end
	
	if timer >= 52 and timer < 71 then
		bg_alpha2 = bg_alpha2 + deltaTimeChart*0.053
		gfx.ImageRect(-bgw/2, -bgh/2, bgw, bgh, ABB3, bg_alpha3, 0)
		gfx.ImageRect(-bgw/2, -bgh/2, bgw, bgh, ABB2, bg_alpha2, 0)
	end
	
	if timer >= 71 and timer < 90 then
		bg_alpha1 = bg_alpha1 + deltaTimeChart*0.053
		gfx.ImageRect(-bgw/2, -bgh/2, bgw, bgh, ABB2, bg_alpha2, 0)
		gfx.ImageRect(-bgw/2, -bgh/2, bgw, bgh, ABB1, bg_alpha1, 0)
	end
	
	if timer >= 90 and timer < 132 then
		bg_alpha5 = bg_alpha5 + deltaTimeChart*0.023
		gfx.ImageRect(-bgw/2, -bgh/2, bgw, bgh, ABB1, bg_alpha1, 0)
		gfx.ImageRect(-bgw/2, -bgh/2, bgw, bgh, ABB5, bg_alpha5, 0)
	end
	
	if timer >= 132 and timer < 152 then
		bg_alphaN = bg_alphaN + deltaTimeChart*0.05
		gfx.ImageRect(-bgw/2, -bgh/2, bgw, bgh, ABB5, bg_alpha5, 0)
		gfx.ImageRect(-bgw/2, -bgh/2, bgw, bgh, ABBN, bg_alphaN, 0)
	end
	
	-- cover
	gfx.ImageRect(-bgw/2, -bgh/2, bgw, bgh, ABBC, bg_alpha, 0)
		
	gfx.ResetTransform()
	gfx.FillColor(255,255,255,255)
	gfx.Text(timer, 100, 530)
	gfx.Text(gameplay.progress, 100, 510)
	gfx.Text(deltaTimeChart, 100, 550)
	gfx.Text(laser, 100, 560)
	gfx.Text(spin, 100, 570)

	--gfx.GlobalCompositeOperation(gfx.BLEND_OP_SOURCE_OVER)
	
	gfx.Restore()
	gfx.ForceRender()
end
