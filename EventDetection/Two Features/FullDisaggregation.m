function [ ONdcsID, OFFdcsID, TOTdcsID, MaxDistanceON, MaxDistanceOFF, MeanDistanceON, MeanDistanceOFF ] = FullDisaggregation( data, onEvents, offEvents, allEvents )
%FULLDISAGGREGATION takes in a data set an GLR parameters and
%disaggregates on the data set.
%   data ==> should be a 1 x N or N x 1 vector of data.
%   parameters ==> MUST be a 1 x N vector consisting of the following
%       [w_BeforeAfterLength, w_GLRLength, v_Threshold, SignalNoiseRatio
%       preProcessOption, GLRSmoothingOption, ZScoreValue]

% Loading On Files
% onFiles = prtUtilSubDir('OnFeatures','*.mat');
% fullOnSet = prtDataSetClass();
% for iFile = 1:length(onFiles)
%     %cFile = onFiles{iFile};
%     load(onFiles{iFile});
%     fullOnSet = catObservations(fullOnSet, onFeatureSet);
%     %plot(onFeatureSet)
% end

load onFeatures;
fullOnSet = onFeatures;

maxONSlope = max(fullOnSet.data(:,1));
maxONDelta = max(fullOnSet.data(:,2));
fullOnSet.data(:,1) = fullOnSet.data(:,1)/maxONSlope;
fullOnSet.data(:,2) = fullOnSet.data(:,2)/maxONDelta;

figure(1)
plot(fullOnSet)
hold on

% Loading Off Files
% offFiles = prtUtilSubDir('..\OffFeatures','*.mat');
% fullOffSet = prtDataSetClass();
% for iFile = 1:length(offFiles)
%     %cFile = offFiles{iFile};
%     load(offFiles{iFile});
%     fullOffSet = catObservations(fullOffSet, offFeatureSet);
% end
load offFeatures;
fullOffSet = offFeatures;

minOFFSlope = min(fullOffSet.data(:,1));
maxOFFDelta = max(fullOffSet.data(:,2));
fullOffSet.data(:,1) = fullOffSet.data(:,1)/minOFFSlope;
fullOffSet.data(:,2) = fullOffSet.data(:,2)/maxOFFDelta;

figure(2)
plot(fullOffSet)
hold on

%trainKNNClassifier

knnClassifierOn = prtClassKnn;
knnClassifierOn.k = 5;
knnClassifierOn = knnClassifierOn.train(fullOnSet);

knnClassifierOff = prtClassKnn;
knnClassifierOff.k = 5;
knnClassifierOff = knnClassifierOff.train(fullOffSet);

% Data Manipulation:
aggregatePower = data;
if(size(aggregatePower, 1) ~= 1 && size(aggregatePower, 2) == 1)
    aggregatePower = aggregatePower';
end

%% Main Part of Function
dataLength = length(aggregatePower);
%[myOn, myOff, myEvents] = GLR_EventDetection(aggregatePower, parameters(1), parameters(2), parameters(3), parameters(4), parameters(5), parameters(6), parameters(7));
myOn = onEvents;
myOff = offEvents;
myEvents = allEvents;

trainingWindow = 10;

% The below line makes two vectors which, when the classification ends,
% ideally the the on events will correspond to their specific dcIDs and so
% will the off events

MaxDistanceON = [];
MeanDistanceON = [];
MaxDistanceOFF = [];
MeanDistanceOFF = [];
       
ONdcsID = zeros(1, dataLength);
OFFdcsID = zeros(1, dataLength);
count = 0;
for i = (1 + trainingWindow):(dataLength-trainingWindow)
    
    if myOn(i) == 1
        eventWindow = aggregatePower(i-trainingWindow:i+trainingWindow);
        eventSlope = polyfit(1:length(eventWindow),eventWindow,1)/maxONSlope;
        eventDelta = (max(eventWindow) - min(eventWindow))/maxONDelta;
        eventFeatures = prtDataSetClass([eventSlope(1) eventDelta]);
        knnClassOut = knnClassifierOn.run(eventFeatures);
        [~, dcsID] = max(knnClassOut.data);
        
        filterFrom = fullOnSet;
        filterFeatures = filterFrom.retainClasses(dcsID);
            
        distance = prtDistanceEuclidean(eventFeatures,filterFeatures);
        maxDistanceON = max(distance);
        meanDistanceON = mean(distance);
        MaxDistanceON = [MaxDistanceON maxDistanceON];
        MeanDistanceON = [MeanDistanceON meanDistanceON];
        
        % Printing Out Appliance Classification
        if or(dcsID == 3, dcsID == 4)
                ONdcsID(i) = dcsID;
         elseif meanDistanceON < 0.005;
             ONdcsID(i) = dcsID; % Classifies the ith detected on-event
        end
        
%         figure(1)
%         hold on
%         featurePoint = plot(eventSlope(1),eventDelta,'xk','MarkerSize',100);
%         set(featurePoint,'xdata',eventSlope(1),'ydata',eventDelta);
%         dcsID
%         delete(featurePoint);
        
    elseif myOff(i) == 1
        eventWindow = aggregatePower(i-trainingWindow:i+trainingWindow);
        eventSlope = polyfit(1:length(eventWindow),eventWindow,1)/minOFFSlope;
        eventDelta = (max(eventWindow) - min(eventWindow))/maxOFFDelta;
        eventFeatures = prtDataSetClass([eventSlope(1) eventDelta]);
        knnClassOut = knnClassifierOff.run(eventFeatures);
        [~, dcsID] = max(knnClassOut.data);
        
        filterFrom = fullOffSet;
        filterFeatures = filterFrom.retainClasses(dcsID);
            
        distance = prtDistanceEuclidean(eventFeatures,filterFeatures);
        maxDistanceOFF = max(distance);
        meanDistanceOFF = mean(distance);
        MaxDistanceOFF = [MaxDistanceOFF maxDistanceOFF];
        MeanDistanceOFF = [MeanDistanceOFF meanDistanceOFF];       
        
        % Printing Out Appliance Classification
        if or(dcsID == 3, dcsID == 4)
                OFFdcsID(i) = dcsID;
         elseif meanDistanceOFF < 0.005;
             OFFdcsID(i) = dcsID; % Classifies the ith detected on-event
        end
        
%         figure(2)
%         hold on
%         featurePoint = plot(eventSlope(1),eventDelta,'xk','MarkerSize',100);
%         set(featurePoint,'xdata',eventSlope(1),'ydata',eventDelta);
%         dcsID
%         delete(featurePoint);
    end
end

%% Post Processing:
% This post processing operates under the assumption that:
% 1. Labels are formatted as follows:
% On events for specific appliances having decision ID q means that
% Off events for the same appliance has a decision ID of q + 0.5.

% 2. For each element i in both ONdcsID and OFFdcsID, either both are 0,
% ONdcsID(i) is nonzero (OFFdcsID(i) is 0), or OFFdcsID(i) is nonzero (ONdcsID(I) is 0)  
OFFdcsID = OFFdcsID;
TOTdcsID = ONdcsID + OFFdcsID;
end

function PlotGraphs(myOn, myOff, aggregatePower)
clf; % Clear Relevant Figures

figure(1);
hold on;
plot(aggregatePower);
plotMyOn = myOn;
plotMyOff = myOff;
plotMyOn(plotMyOn == 0) = NaN;
plotMyOff(plotMyOff == 0) = NaN;
plot(plotMyOn.*aggregatePower, 'ro', 'linewidth', 2);
plot(plotMyOff.*aggregatePower, 'go', 'linewidth', 2);
hold off;
title('Events detected');
xlabel('Time Series Values (s)');
ylabel('Power Values (W)');
legend('Data', 'On Events', 'Off Events');
end
