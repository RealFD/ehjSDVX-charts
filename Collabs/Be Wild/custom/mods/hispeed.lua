xero.definemod{"xspeed","xspeedP",function(b,p)
	mod.SetHispeed(p)
end}

xero.setdefault{OriginalXspeed,"xspeedP"}

xero.definemod{"hispeed","hispeedP",function(b,p)
	mod.SetHispeed(p/gameplay.bpm)
end}

xero.setdefault{OriginalXspeed*gameplay.bpm,"hispeedP"}

xero.definemod{"spinSpeed","spinSpeedP",function(b,p)
	mod.SetSpinSpeed(p)
end}

xero.setdefault{1,"spinSpeedP"}
