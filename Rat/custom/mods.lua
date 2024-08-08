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


--xero.perframe{19,2,}
for _, set in ipairs(setLaneMod) do
	local value1, value2, labels = set[1], set[2], set[3]
	for _, label in ipairs(labels) do
		xero.set{value1, value2, label}
	end
end
--
--xero.ease{4,100,outElastic,math.pi/2,ModNames.RotationTable.Side.BH}
--xero.set{5,100,ModNames.RotationTable.Side.BH}
--xero.ease{113.25,2,spike,0,ModNames.RotationTable.Side.BH}
--
--xero.ease{6,1,flip(linear),0.5,ModNames.TansitionTable.Side.LS}
--xero.ease{8.2,1,flip(linear),0.5,ModNames.TansitionTable.Side.RS}
--xero.ease{6,1,flip(linear),1,ModNames.RotationTable.Side.LS}
--xero.ease{8.2,1,flip(linear),1,ModNames.RotationTable.Side.RS}
--
--xero.ease{79,1,linear,25,"CH:Z"}
--xero.ease{90,1,linear,0.1,"CH:Z"}
--
--xero.ease{4,0.5,outSine,{1,1},"Modify"}
--
--xero.ease{10,0.5,linear,{1,2},"Modify"}
--
--xero.ease{28.5,0.5,outSine,{1,1},"Modify"}
--
--xero.ease{28.5,1,linear,{0.25,5},"xspeedP"}

xero.perframe{109.5,1.3,"LaserSetWaveXB"}
xero.ease{109.5,1.3,bounce,1,"LaserSetWaveX"}
xero.perframe{110,75,"LaserSetWaveXB"}
xero.ease{110,75,instant,0,"LaserSetWaveX"}

xero.perframe{109.5,1.3,"LaserSetWaveYB"}
xero.ease{109.5,1.3,bounce,1,"LaserSetWaveY"}
xero.perframe{110,75,"LaserSetWaveYB"}
xero.ease{110,75,instant,0,"LaserSetWaveY"}

--xero.ease{109.5,1.5,bounce,.5,ModNames.TansitionTable.Side.BH}
--
--xero.ease{36.75,0.5,bounce,-0.5,ModNames.TansitionTable.Lane.LL}
--xero.ease{37.25,0.5,bounce,0.5,ModNames.TansitionTable.Lane.LR}
--
--xero.ease{39.65,0.5,bounce,-0.5,ModNames.TansitionTable.Lane.LL}
--xero.ease{39.75,0.5,bounce,0.5,ModNames.TansitionTable.Lane.LR}
--
----xero.ease{47.85,2,outSine,0,"idk"} -- pixel version ???
--
----xero.ease{49.65,1,inOutBounce,.75,ModNames.TansitionTable.Side.BH}
--
----xero.ease{56.48,1,outSine,.5,ModNames.TansitionTable.Side.BH}
--xero.ease{56.48,1,linear,{5,1},"xspeedP"}
----xero.ease{56.48,1,outSine,20,"CH:MSplit"} -- make it spline arround OBJ
--xero.ease{64.5,1,linear,{1,5},"xspeedP"}
----xero.ease{64.5,0.5,outSine,0.01,"CH:MSplit"}
--
--
--xero.ease{113,0,instant,100,ModNames.TansitionTable.Side.BH}