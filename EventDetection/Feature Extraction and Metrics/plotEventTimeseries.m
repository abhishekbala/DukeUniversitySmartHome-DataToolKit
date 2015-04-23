%% PCA Training
load '..\kApplianceFeaturesAndSmartHomeData\smartHomeData.mat'

% Power data for the different appliances
refrigerator = [fridgeData1; fridgeData2; fridgeData3; fridgeData4; fridgeData5; fridgeData6];
clear fridgeData1 fridgeData2 fridgeData3 fridgeData4 fridgeData5 fridgeData6
hotbox = [hotBoxData1; hotBoxData2; hotBoxData3; hotBoxData4];
clear hotBoxData1 hotBoxData2 hotBoxData3 hotBoxData4
HVAC1 = [HVAC1Data1; HVAC1Data2; HVAC1Data3; HVAC1Data4];
clear HVAC1Data1 HVAC1Data2 HVAC1Data3 HVAC1Data4
HVAC2 = [HVAC2Data1; HVAC2Data2; HVAC2Data3; HVAC2Data4; HVAC2Data5; HVAC2Data6; HVAC2Data7; HVAC2Data8];
clear HVAC2Data1 HVAC2Data2 HVAC2Data3 HVAC2Data4 HVAC2Data5 HVAC2Data6 HVAC2Data7 HVAC2Data8
clear h10pData1 h10pData2 h10pData3 h10pData4

% Event detection
% [onEventsRef, offEventsRef, allEventsRef] = GLR_EventDetection(refrigerator, 40, 30, 25, -10, 3, 0, 6);
% onEventsRef(1,59831) = 0; onEventsRef(1,64444) = 0; onEventsRef(1,139059) = 0; onEventsRef(1,142925) = 0;
% offEventsRef(1,56310) = 0; offEventsRef(1,60039) = 0; offEventsRef(1,64657) = 0; offEventsRef(1,75364) = 0; offEventsRef(1,139260) = 0;
% offEventsRef(1,143129) = 0;
load '..\Two Features\refEvents.mat'

%[onEventsHot, offEventsHot, allEventsHot] = GLR_EventDetection(hotbox, 40,30,25,-30,3,0,4);
load '..\Two Features\hotEvents.mat'

%[onEventsHVAC1, offEventsHVAC1, allEventsHVAC1] = GLR_EventDetection(HVAC1, 40,30,25,-40,3,0,4);
load '..\Two Features\hvac1Events.mat'

%[onEventsHVAC2, offEventsHVAC2, allEventsHVAC2] = GLR_EventDetection(HVAC2, 40,20,15,-50,3,0,4);
%offEventsHVAC2(1,27631) = 0; 
load '..\Two Features\hvac2Events.mat'

clear allEventsRef allEventsHot allEventsHVAC1 allEventsHVAC2

[onMatrixRef, offMatrixRef] = pcaTraining(refrigerator,onEventsRef,offEventsRef);

[onMatrixHot, offMatrixHot] = pcaTraining(hotbox,onEventsHot,offEventsHot);

[onMatrixHVAC1, offMatrixHVAC1] = pcaTraining(HVAC1,onEventsHVAC1,offEventsHVAC1);

[onMatrixHVAC2, offMatrixHVAC2] = pcaTraining(HVAC2,onEventsHVAC2,offEventsHVAC2);

time = [1:1:61];

% Figure showing an example timeseries of an ON event separated by appliance
figure(1)
hold on
plot(time,onMatrixHot(1,:))
plot(time,onMatrixRef(1,:))
plot(time,onMatrixHVAC1(19,:))
plot(time,onMatrixHVAC2(1,:)) %else 41
legend('Hotbox','Refrigerator','HVACMode1','HVACMode2');
xlabel('Seconds'); ylabel('Power (W)');
hold off

% Figure showing an example timeseries of an ON event where Ref and
% HVACMode2 could be confused.
figure(2)
hold on
plot(time,onMatrixHot(1,:))
plot(time,onMatrixRef(1,:))
plot(time,onMatrixHVAC1(19,:))
plot(time,onMatrixHVAC2(41,:))
legend('Hotbox','Refrigerator','HVACMode1','HVACMode2');
xlabel('Seconds'); ylabel('Power (W)');
hold off