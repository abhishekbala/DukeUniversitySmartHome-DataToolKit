load test1Day.mat
[onEventsAgg, offEventsAgg, allEventsAgg] = GLR_EventDetection(agg, 80,15,10,-20,1,0,4);

[onEventsRef, offEventsRef, allEventsRef] = GLR_EventDetection(refrigerator, 80,15,10,-20,1,0,4);
[onEventsHot, offEventsHot, allEventsHot] = GLR_EventDetection(hotbox, 80,15,10,-20,1,0,4);
[onEventsH10P, offEventsHot, allEventsHot] = GLR_EventDetection(h10p, 80,15,10,-20,1,0,4);
[onEventsHVAC1, offEventsHot, allEventsHot] = GLR_EventDetection(HVAC1, 80,15,10,-20,1,0,4);
[onEventsHVAC2, offEventsHot, allEventsHot] = GLR_EventDetection(HVAC2, 80,15,10,-20,1,0,4);

figure(3)
hold on
subplot(2,1,1)
plot(onEventsAgg,'b')
title('All Aggregate ON events detected')
xlabel('Time of day (s)')
subplot(2,1,2)
title('Submetered Refrigerator ON events detected')
plot(onEventsRef,'r')
xlabel('Time of day (s)')
hold off

figure(4)
hold on
subplot(2,1,1)
plot(onEventsAgg,'b')
title('Aggregate ON events detected')
xlabel('Time of day (s)')
subplot(2,1,2)
plot(onEventsHot,'r')
xlabel('Time of day (s)')
title('Submetered Hot Box ON events detected')
hold off

figure(5)
hold on
subplot(2,1,1)
plot(onEventsAgg,'b')
title('Aggregate ON events detected')
xlabel('Time of day (s)')
subplot(2,1,2)
plot(onEventsHot,'r')
xlabel('Time of day (s)')
title('Submetered H10P ON events detected')
hold off


figure(6)
hold on
subplot(2,1,1)
plot(onEventsAgg,'b')
title('Aggregate ON events detected')
xlabel('Time of day (s)')
subplot(2,1,2)
plot(onEventsHot,'r')
xlabel('Time of day (s)')
title('Submetered HVAC1 ON events detected')
hold off

figure(7)
hold on
subplot(2,1,1)
plot(onEventsAgg,'b')
title('Aggregate ON events detected')
xlabel('Time of day (s)')
subplot(2,1,2)
plot(onEventsHot,'r')
xlabel('Time of day (s)')
title('Submetered HVAC2 ON events detected')
hold off

for i = 6:length(onEventsAgg)-5;
    if and(onEventsRef(1,i) == 1,onEventsAgg(1,i) == 1);
        onEventsAgg1(1,i) = 2;
    elseif and(onEventsRef(1,i) == 1, not(isempty(find(onEventsAgg(1,i-5:i+5),1))))
        onEventsAgg1(1,i-5 + find(onEventsAgg(1,i-5:i+5),1)) = 2;
    end
end
        