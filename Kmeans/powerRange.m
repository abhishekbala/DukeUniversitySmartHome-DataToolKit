g_1 = zeros(7,1);
g_2 = zeros(21053,1);
g_3 = zeros(22583,1);

r1 = 0;
for i = 1:43643
    if groupedData(i,1)==1
        r1 = r1+1;
        g_1 (r1,1) = groupedData(i,5);
    end
end
    
r2 = 0;
for i = 1:43643
    if groupedData(i,1)==2
        r2 = r2+1;
        g_2 (r2,1) = groupedData(i,5);
    end
end

r3 = 0;
for i = 1:43643
    if groupedData(i,1)==3
        r3 = r3+1;
        g_3 (r3,1) = groupedData(i,5);
    end
end

powerRange = zeros(2,3);
powerRange(1,1)= min(g_1);
powerRange(2,1)= max(g_1);
powerRange(1,2)= min(g_2);
powerRange(2,2)= max(g_2);
powerRange(1,3)= min(g_3);
powerRange(2,3)= max(g_3);
