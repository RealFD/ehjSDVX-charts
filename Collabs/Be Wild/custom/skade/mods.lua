--TODO second section comment scanimate

--xero.perframe{0,1,"lsrScale"}
--xero.ease{0,10,linear,2,"lsrScaleP"}

local sgt = require('template/ehj/sharedGlobalTable')

--funkeln

xero.perframe{24-1/4,32-(24-1/4)+1,"reverse"}
xero.ease{24-1/4,1/4,inCirc,1,"reverseP"}
xero.ease{32-1/8,1/8,inExpo,0,"reverseP"}

xero.perframe{24-1/4,32-(24-1/4)+1,"starTarget"}
xero.ease{24-1/4,1/4,inCirc,1,"starTargetP"}
xero.func_ease{24-1/4,1/4,linear,1,0,function(p)
	Ubgfs.alpha = p
end}

local setAllFill = function(p)
	sgt.set("songInfoFillC",{p,p,p})
	sgt.set("scoreFillC",{p,p,p})

	sgt.set("critLineFillC",{p,p,p})
	sgt.set("consoleFillC",{p,p,p})
	sgt.set("gaugeFillC",{p,p,p})
	sgt.set("bannerFillC",{p,p,p})
end

xero.func_ease{24-1/4,1/4,linear,1,.1,function(p)
	--globals.bannerOpacity = 0
	--globals.critLineAlpha = 1
end}

xero.ease{32-1/8,1/8,inExpo,0,"starTargetP"}
xero.func_ease{32-1/8,1/8,inExpo,0,1,function(p)
	Ubgfs.alpha = p
end}
xero.func_ease{32-1/8,1/8,inExpo,.1,1,function(p)
	--globals.bannerOpacity = 0
	--globals.critLineAlpha = 1
	setAllFill(p)
end}

xero.func{80,function()
	mod.setEMod("reverseT")
	mod.setModProperty(mdv.ML_ALL,mdv.MA_ALL)
end}
--xero.perframe{80,2,"baseTrans"}
--xero.ease{80,1,linear,mdv.TRACK_H,"baseTransY"}
--xero.ease{81,1,linear,0,"baseTransY"}

local imgSkd1 = gfx.CreateImage(P_SKADE.."skd1.png",0)
local imgSkd2 = gfx.CreateImage(P_SKADE.."skd2.png",0)
xero.func_ease{80,1,linear,0,1,function(p)
	local rx,ry = game.GetResolution()
	local w = 1024;local h = 582
	local r = 0
	local x = rx*.25; local y = ry*.01

	local ny = y
	local pe = inExpo((p)/.8)
	r = pe
	ny = y-pe*4000
	do
		gfx.Save()
		gfx.Translate(w,h)
		gfx.Rotate(r)
		gfx.Translate(-w,-h)
		gfx.ImageRect(x,ny,w*1.15,h*1.15,imgSkd2,inExpo(1-p)*3.5,0)
		gfx.Restore()
	end
	local nx = x-pe*2000
	gfx.ImageRect(nx,y,w*1.15,h*1.15,imgSkd1,inExpo(1-p)*3.5,0)
end}
--
local slamImpact = function(b)

	xero.perframe{b+2-2/4,2,"spinImpact"}
	xero.ease{b+2-2/4,1/4,function(p) return inExpo(p) end,1,"spinImpactP"}
	xero.ease{b+2-1/4,1/4,function(p) return outExpo(p) end,0,"spinImpactP"}

	--xero.perframe{b+2-2/4,2,"globalTrans"}
	xero.ease{b+2-2/4,2/4,function(p) return inExpo(p) end,0,"globalTransZ"}
	xero.set{b+2,0,"globalTransZ"}

	xero.perframe{b+2,2,"spinImpactSlam"}
	xero.set{b+2,50,"spinImpactSlamP"}
	xero.ease{b+2,1/4,outExpo,0,"spinImpactSlamP"}
	xero.set{b+2+1/4,0,"spinImpactSlamP"}
end
local ewigerFrost = function(b)
	xero.perframe{b,3,"hispeed"}
	xero.set{b,300,"hispeedP"}
	xero.set{b+2,OriginalHispeed,"hispeedP"}
	local bs1 = .25
	local bs2 = .5

	xero.perframe{b,4,"baseScale"}
	xero.ease{b,1/16,linear,1/bs1,"baseScaleY"}
	xero.ease{b+1,1/16,linear,1/bs2,"baseScaleY"}
	xero.ease{b+2,1/16,linear,1,"baseScaleY"}

	xero.perframe{b,4,"helixPierce"}
	xero.ease{b,1/16,linear,1,"helixPierceP"}

	xero.perframe{b,4,"globalScale"}
	xero.ease{b,1/16,linear  ,bs1*.75,"globalScaleY"}
	xero.ease{b+1,1/16,linear,bs2*.75,"globalScaleY"}
	xero.ease{b+2,1/16,linear  ,1*.75,"globalScaleY"}

	xero.perframe{b+1,2,"globalTrans"}
	xero.set{b+1,mdv.TRACK_H*bs2*1.5,"globalTransY"}
	xero.ease{b+1,1-2/4,linear,mdv.TRACK_H*bs2*1.,"globalTransY"}
	xero.set{b+2,0,"globalTransY"}

	xero.perframe{b,2,"freeze"}
	xero.set{b,1,"freezeP"}
	xero.set{b+2-2/4,0,"freezeP"}
	--xero.set{80,1,"freezeS"}

	xero.perframe{b+1,2,"reverse"}
	xero.ease{b+1,1/16,linear,1,"reverseP"}
	xero.set{b+2,0,"reverseP"}

	-- impact --TODO this is not what I want
	--xero.ease{82-3/4,3/4,inCirc,mdv.TRACK_H,"globalTransY"}
	--xero.ease{82,1/16,linear,0,"globalTransY"}
	slamImpact(b)
end
ewigerFrost(80)
slamImpact(82)
ewigerFrost(84)

xero.func_ease{102,1/4,linear,1,0,function(p)
	Ubgfs.alpha = p
end}
xero.func_ease{102+1/4+1/8,1/4,linear,0,1,function(p)
	Ubgfs.alpha = p
end}
xero.func_ease{103,1/4,linear,1,0,function(p)
	Ubgfs.alpha = p
end}
xero.func_ease{103+1/4+1/8,1/4,linear,0,1,function(p)
	Ubgfs.alpha = p
end}
xero.func{120,function()
	Ubgfs.alpha = 0
end}
