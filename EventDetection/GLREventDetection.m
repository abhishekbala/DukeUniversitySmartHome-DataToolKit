function GLREventDetection(data)
% DETECT EVENTS USING GENERALIZED LIKELIHOOD RATIO

    wa = 50;
    wb = 50;
    current = wa + 1;
    startIndex = current;
    wl = 20;
    vt = 2;
    dataLength = length(data);
    l = zeros(1, dataLength);
    s = zeros(1, dataLength);
    v = zeros(1, dataLength);
    
    while current + wl - 1 + wa < length(data)
        startIndex = current;
        for wi = 1 : wl
            current = startIndex + wi;
            meana = mean(data(current : current + wa - 1));
            sigmaa = std(data(current : current + wa - 1));
            meanb = mean(data(current - wb + 1 : current));
            sigmab = std(data(current - wb + 1 : current));
            xn = data(current);
            l(current) = - (xn - meana)^2 / (2*sigmaa) + (xn - meanb)^2 / (2*sigmab);
        end
        
        for wi = 1 : wl
            current = startIndex + wi;
            s(current) = sum(l(current : startIndex + wl - 1));
        end
        
        smaxi = find(data == max(data(startIndex : startIndex + wl - 1)));
        v(smaxi) = v(smaxi) + 1;
        if v(smaxi) > vt
            disp(v(smaxi));
    end
end