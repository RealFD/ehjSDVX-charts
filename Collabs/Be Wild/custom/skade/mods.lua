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
	setAllFill(p)
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

xero.perframe{80,3,"hispeed"}
xero.set{80,300,"hispeedP"}
xero.set{82,OriginalHispeed,"hispeedP"}

local bs1 = .25
local bs2 = .5

xero.perframe{80,4,"baseScale"}
xero.ease{80,1/16,linear,1/bs1,"baseScaleY"}
xero.ease{81,1/16,linear,1/bs2,"baseScaleY"}
xero.ease{82,1/16,linear,1,"baseScaleY"}

xero.perframe{80,4,"helixPierce"}
xero.ease{80,1/16,linear,1,"helixPierceP"}

xero.perframe{80,4,"globalScale"}
xero.ease{80,1/16,linear,bs1,"globalScaleY"}
xero.ease{81,1/16,linear,bs2,"globalScaleY"}
xero.ease{82,1/16,linear,1,"globalScaleY"}

xero.perframe{81,4,"globalTrans"}
xero.set{81,mdv.TRACK_H*.5,"globalTransY"}
xero.ease{81,1-3/4,inCirc,mdv.TRACK_H*.25,"globalTransY"}
xero.set{82,0,"globalTransY"}
--
xero.perframe{80,2,"freeze"}
xero.set{80,1,"freezeP"}
--xero.set{80,1,"freezeS"}

xero.perframe{81,2,"reverse"}
xero.ease{81,1/16,linear,1,"reverseP"}
xero.set{82,0,"reverseP"}

-- impact --TODO this is not what I want
--xero.ease{82-3/4,3/4,inCirc,mdv.TRACK_H,"globalTransY"}
--xero.ease{82,1/16,linear,0,"globalTransY"}

xero.perframe{82-2/4,2,"spinImpact"}
xero.ease{82-2/4,2/4,inExpo,1,"spinImpactP"}
xero.set{82+1/4,0,"spinImpactP"}

xero.perframe{82,2,"spinImpactSlam"}
xero.set{82,50,"spinImpactSlamP"}
xero.ease{82,1/4,outExpo,0,"spinImpactSlamP"}
xero.set{82+1/4,0,"spinImpactSlamP"}
