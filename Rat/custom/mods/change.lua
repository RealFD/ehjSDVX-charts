xero.definemod {"Modify", function(b,p)
    background.SetParamf("NUMOCTAVES",b)
    background.SetParamf("LUAalpha", p)
end}

xero.setdefault{0,"Modify"}