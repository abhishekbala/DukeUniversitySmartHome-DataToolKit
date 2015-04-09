function [ ONdcsID, OFFdcsID, TOTdcsID, MaxChebDistance, MeanChebDistance, MaxDistance, MeanDistance ] = FullDisaggregation( data, onEvents, offEvents, allEvents )
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

load ..\EventDetection\OnFeatures\onFeatures.mat
fullOnSet = prtDataSetClass();
fullOnSet = onFeatures;

load ..\EventDetection\pcaON.mat

maxONSlope = max(fullOnSet.data(:,2));
maxONDelta = max(fullOnSet.data(:,3));
fullOnSet.data(:,2) = fullOnSet.data(:,2)/maxONSlope;
fullOnSet.data(:,3) = fullOnSet.data(:,3)/maxONDelta;

% figure(1)
% plot(fullOnSet)
% hold on

% Loading Off Files
offFiles = prtUtilSubDir('OffFeatures','*.mat');
fullOffSet = prtDataSetClass();
for iFile = 1:length(offFiles)
    %cFile = offFiles{iFile};
    load(offFiles{iFile});
    fullOffSet = catObservations(fullOffSet, offFeatureSet);
end



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

trainingWindow = 30;

% The below line makes two vectors which, when the classification ends,
% ideally the the on events will correspond to their specific dcIDs and so
% will the off events

MaxDistance = [];
MeanDistance = [];
%chebDistance = prtDistanceChebychev(eventFeatures,filterFeatures);
MaxChebDistance = [];
MeanChebDistance = [];
       
ONdcsID = zeros(1, dataLength);
OFFdcsID = zeros(1, dataLength);
count = 0;
for i = (1 + trainingWindow):(dataLength-trainingWindow)
    
    if myOn(i) == 1
        %knnClassOut = DisagClassifier(aggregatePower, knnClassifierOn, i, trainingWindow);
        eventWindow = aggregatePower(i-trainingWindow:i+trainingWindow);
        c = median(find(eventWindow));
        window1 = eventWindow(c-10:c+10);
        eventSlope = polyfit(1:length(window1),window1,1)/maxONSlope;
        eventDelta = (max(window1) - min(window1))/maxONDelta;
        eventPCAwindow = prtDataSetClass;
        eventPCAwindow.data = eventWindow;
        pcaONFeature = pcaON.run(eventPCAwindow);
        eventFeatures = prtDataSetClass([pcaONFeature.data(1,1) eventSlope(1) eventDelta]);
        %eventFeatures = prtDataSetClass(eventWindow);
        knnClassOut = knnClassifierOn.run(eventFeatures);
        [~, dcsID] = max(knnClassOut.data);
        
%         if dcsID == 1;
%             index = 1;
%         elseif dcsID == 2;
%             index = 5;
%         elseif dcsID == 3;
%             index = 7;
%         elseif dcsID == 4;
%             index = 9;
%         %elseif dcsID == 5;
%         %    index = 9;
%         end
        
%         filterFrom = fullOnSet;
%         filterFeatures = filterFrom.retainClasses(dcsID);
            
%         distance = prtDistanceEuclidean(eventFeatures,filterFeatures);
%         maxDistance = max(distance);
%         meanDistance = mean(distance);
%         chebDistance = prtDistanceChebychev(eventFeatures,filterFeatures);
%         maxChebDistance = max(chebDistance);
%         meanChebDistance = mean(chebDistance);
%         MaxDistance = [MaxDistance maxDistance];
%         MeanDistance = [MeanDistance meanDistance];
%         MaxChebDistance = [MaxChebDistance maxChebDistance];
%         MeanChebDistance = [MeanChebDistance meanChebDistance];
%         
%         % Printing Out Appliance Classification
%         if or(dcsID == 3, dcsID == 4)
%             if and(dcsID == 3, maxDistance > 0.1)
%                 ONdcsID(i) = dcsID + 1;
%             else
%                 ONdcsID(i) = dcsID;
%             end
% %         elseif dcsID == 1
% %             if meanDistance < 0.015
% %                 ONdcsID(i) = dcsID;
% %             end
%          elseif meanDistance < 0.005;
%              ONdcsID(i) = dcsID; % Classifies the ith detected on-event
%         end
%         count = count + 1;
        

        ONdcsID(i) = dcsID;
        
%         figure(1)
%         hold on
%         featurePoint = plot(eventSlope(1),eventDelta,'o','MarkerSize',100);
%         set(featurePoint,'xdata',eventSlope(1),'ydata',eventDelta);
%         dcsID
%         delete(featurePoint);
        
    elseif myOff(i) == 1
        %knnClassOut = DisagClassifier(aggregatePower, knnClassifierOff, i, trainingWindow);
        eventWindow = aggregatePower(i-trainingWindow:i+trainingWindow);
        eventSlope = polyfit(1:length(eventWindow),eventWindow,1);
        eventDelta = max(eventWindow) - min(eventWindow);
        eventFeatures = prtDataSetClass([eventSlope(1) eventDelta]);
        %eventFeatures = prtDataSetClass(eventWindow);
        knnClassOut = knnClassifierOff.run(eventFeatures);
        [~, dcsID] = max(knnClassOut.data);
        
        % Printing Out Appliance Classification
        OFFdcsID(i) = dcsID; % Classifies the ith detected off-event
    end
end

%% Post Processing:
% This post processing operates under the assumption that:
% 1. Labels are formatted as follows:
% On events for specific appliances having decision ID q means that
% Off events for the same appliance has a decision ID of q + 0.5.

% 2. For each element i in both ONdcsID and OFFdcsID, either both are 0,
% ONdcsID(i) is nonzero (OFFdcsID(i) is 0), or OFFdcsID(i) is nonzero (ONdcsID(I) is 0)  
OFFdcsID = OFFdcsID + 0.5;
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
