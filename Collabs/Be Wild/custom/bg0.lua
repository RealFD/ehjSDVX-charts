local delayedOperations = {
	u={},
	speed=nil
}
local dark = game.GetSkinSetting("dark_mode") or game.GetSkinSetting("dark_bgs")

-- backgroundTextures
local bt = {
	cloudy={"cloudy.jpg", "cloudy-c.jpg"},
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
	lightsPink={"lights_yellowgreen.png", "lights_yellowgreen-c.png"}
}

local bgs = {
	waveRed={
		Bg={ Base={Tex=bt.cloudy, ScaleSoft=true}},
		Tunnel={
			Tex={"wave-green.png","wave-green-c.png"},
			u={Sides=4, Stretch=0.15, ScaleX=0.8, ScaleY=0.8, FlashEffect=true, Fog=20.0}
		},
		--Center={ Tex={{"moon_pink.png","moon_pink-c.png"},{0}}, u={Scale=8.0, OffsetY=-0.05}, LayerEffect={Tex="moon_pink_shine.png", Glow=true, DodgeBlend=true, Scale=0.8} },
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
