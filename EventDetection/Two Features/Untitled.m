TPRVals = zeros(1, 32);
FARVals = zeros(1, 32);

for(j = 0 : 31)

[eventsDetected_on, eventsDetected_off, eventsDetected] = GLR_EventDetection(refrigerator, 40, 30, j, -20, 3, 0, 4);

eventsDetected = find(eventsDetected == 1);
q = eventsDetected;

TPR = 0;

for i = 1:length(truthTimes)
    q = eventsDetected;
    q = q - truthTimes(i);
    q(abs(q) > 10) = 0;
    
    if(any(q))
        TPR = TPR + 1;
    end
end

TPR = TPR/20;

q = truthTimes;

FAR = 0;

for i = 1:length(eventsDetected)
    q = truthTimes;
    q = q - eventsDetected(i);
    q(abs(q) < 10) = 0;
    
    if(any(q))
        FAR = FAR + 1;
    end
end

FAR = FAR / 43000;

TPRVals(j+1) = TPR;
FARVals(j+1) = FAR;
end