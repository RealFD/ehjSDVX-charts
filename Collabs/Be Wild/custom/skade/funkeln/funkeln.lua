
local function initializeParticle(initial,particleSizeSpread)

	local rand = function()
		return math.random()*2.-1.
	end

	local particle = {}
	particle.time = math.random()
	particle.x = rand()*20.
	particle.y = (math.random() * 1.2*5. - 0.1)
	particle.z = -2 - math.random() * 100.
	if not initial then particle.y = -0.1 end

	particle.r = math.random()
	particle.s = (math.random() - 0.5) * particleSizeSpread + 1.0
	particle.xv = 0
	particle.yv = 0.1
	particle.rv = math.random() * 2.0 - 1.0
	particle.p = math.random() * math.pi * 2
	particle.t = {
		1,0,0,0,
		0,1,0,0,
		0,0,1,0,
		0,0,0,1,
	}
	return particle
end

local function sign(x)
	return x>0 and 1 or x<0 and -1 or 0
end

local particleSystem = {
	sm = track.CreateShadedMeshOnTrack("star",P_SKADE.."funkeln/"),
	timer = 0,
	particleCount = 12,
	particleSizeSpread = 0.5,
	psize = 32,
	particles = {},
	init = function(s)
		s.sm:SetPrimitiveType(s.sm.PRIM_TRIFAN)
		s.sm:SetBlendMode(s.sm.BLEND_ADD)
		s.sm:SetData({
			{{-1,-1, 0},{0,0}},
			{{ 1,-1, 0},{1,0}},
			{{ 1, 1, 0},{1,1}},
			{{-1, 1, 0},{0,1}},
		})
		--TODO(skade)	s.sm:SetDepthTest(true)
		s.sm:SetScreenSpace(false)

		for i=1,s.particleCount do
			s.particles[i] = initializeParticle(true,s.particleSizeSpread)
		end
	end,
	render = function(s,deltaTime)
		local resx, resy = game.GetResolution()
		local portrait = resy > resx
		local desw = portrait and 720 or 1280
		local desh = desw * (resy / resx)
		local scale = resx / desw

		for i,p in ipairs(s.particles) do
			p.time = p.time + deltaTime*.8
			p.x = p.x + p.xv * deltaTime
			p.y = p.y + p.yv * deltaTime*10.
			p.r = p.r + p.rv * deltaTime -- rotation

			-- movement
			p.p = (p.p + deltaTime) % (math.pi * 2)
			p.xv = 0.5 - ((p.x * 2) % 1) + (0.5 * sign(p.x - 0.5))
			p.xv = math.max(math.abs(p.xv * 2) - 1, 0) * sign(p.xv)
			p.xv = p.xv * p.y
			p.xv = p.xv + math.sin(p.p) * 0.01
			
			--gfx.Save()
			--gfx.ResetTransform()
			--gfx.Translate(p.x * resx, p.y * resy)
			--gfx.Rotate(p.r)
			--gfx.Scale(p.s * scale, p.s * scale)
			--gfx.BeginPath()
			--gfx.GlobalCompositeOperation(gfx.BLEND_OP_LIGHTER)
			--TODO(skade) render shaded mesh
			--gfx.ImageRect(-s.psize/2, -s.psize/2, s.psize, s.psize, tex, math.max(1 - p.y*2,0), 0)

			p.t = {
				p.s,0,0,p.x,
				0,p.s,0,p.y,
				0,0,p.s,p.z,
				0,0,0  ,1,
			}
			p.t = gfx.MultMat(gfx.GetRotMat({90,0,0}),p.t)
			s.sm:SetParamMat4("u_t",p.t)

			s.sm:SetParam("u_time",p.time)
			s.sm:Draw()

			if p.y > 4 then
				s.particles[i] = initializeParticle(false,s.particleSizeSpread)
			end
		end
		--gfx.ForceRender()
	end,
}

return particleSystem