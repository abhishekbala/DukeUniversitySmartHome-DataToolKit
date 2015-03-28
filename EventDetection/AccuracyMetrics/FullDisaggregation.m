function [ myDCIDs ] = FullDisaggregation( data, parameters )
%FULLDISAGGREGATION takes in a data set an GLR parameters and
%disaggregates on the data set.
%   data ==> should be a 1 x N or N x 1 vector of data.
%   parameters ==> MUST be a 1 x N vector consisting of the following
%       [w_BeforeAfterLength, w_GLRLength, v_Threshold, SignalNoiseRatio
%       preProcessOption, GLRSmoothingOption, ZScoreValue]

[~, fullOnSet] = loadOnFiles();

[~, fullOffSet] = loadOffFiles();

%trainKNNClassifier

knnClassifierOn = prtClassKnn;
knnClassifierOn.k = 5;
knnClassifierOn = knnClassifierOn.train(fullOnSet);

knnClassifierOff = prtClassKnn;
knnClassifierOff.k = 5;
knnClassifierOff = knnClassifierOff.train(fullOffSet);

% Data Manipulation:
aggregatePower = data;
if(size(aggregatePower, 1) == 1 && size(aggregatePower, 2) ~= 1)
    aggregatePower = aggregatePower';
end

myOn = zeros(size(aggregatePower));
myOff = zeros(size(aggregatePower));
myEvents = zeros(size(aggregatePower));

%% Main Part of Function

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

function [knnClassOut] = DisagClassifier(aggregatePower, knnClassifier, n, trainingWindow)
eventWindow = aggregatePower(n-trainingWindow:n+trainingWindow)';
eventSlope = polyfit(1:length(eventWindow),eventWindow,1);
eventDelta = max(eventWindow) - min(eventWindow);
eventFeatures = prtDataSetClass([eventSlope(1) eventDelta]);
%eventFeatures = prtDataSetClass(eventWindow);

knnClassOut = knnClassifier.run(eventFeatures);