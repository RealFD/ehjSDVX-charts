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
