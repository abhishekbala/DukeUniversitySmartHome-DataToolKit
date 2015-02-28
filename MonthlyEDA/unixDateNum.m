function dn = unixDateNum(t)
    dn = t/86400 + 719529 - (5 + 16/60)/24;         %# == datenum(1970,1,1)
end