function net = Train()

smartHomeData = importdata('shHistoricalTestDataMarch29.csv');
hvacColumn = smartHomeData(:,6) + smartHomeData(:,7) + ...
    smartHomeData(:,8) + smartHomeData(:,9);
hvac = [smartHomeData(:,1) hvacColumn];
%addCols = [refrigeratorPre(:,1) refrigeratorPre(:,9)]; %forhvac
%refrigerator = [refrigeratorBefore; addCols]; %forhvac
HistMatPre = fixMissingValues(hvac);
Hist = MinuteAverageFromSecondData(HistMatPre);
trainingData = Hist(:,2)';

%xblock1 = 1:((2345-616)/60);
%xblock2 = 1:((3869-2345)/60);
%xblock3 = 1:((4901-3869)/60);

%yvalue1 = 130.*ones(1,length(xblock1));
%yvalue2 = 100.*ones(1,length(xblock2));
%yvalue3 = 5.*ones(1,length(xblock3));

%y = [yvalue1 yvalue2 yvalue3];
%trainingData = [];
%for i = 1:20;
   % trainingData = [trainingData y];
%end


oldSeries = num2cell(trainingData);
[feedbackDelaysValuespre, feedbackDelayspre] = Correlation(trainingData, trainingData);

[feedbackDelaysValues, feedbackDelays] = findpeaks(feedbackDelaysValuespre);
feedbackDelaysValues2 = zeros(1,10);
%lag = zeros(1);
lag=[1];
for k = 1:10
    feedbackDelaysValues2(k) = max(abs(feedbackDelaysValues));
    if((feedbackDelays(find(abs(feedbackDelaysValues)==feedbackDelaysValues2(k))))<720)
        lag(k) = feedbackDelays(find(abs(feedbackDelaysValues)==feedbackDelaysValues2(k)));
    end
    removeIndex = find(abs(feedbackDelaysValues)==feedbackDelaysValues2(k))
    feedbackDelaysValues(removeIndex) = min(abs(feedbackDelaysValues));
end
lag(1,size(lag,2)+1) = 1;
lags1 = sort(lag);
lags2 = unique(lags1)
lags = lags2(lags2~=0);
hiddenLayerSize = 10;

net = narnet(lags, hiddenLayerSize);

[inputs, inputStates, layerStates, targets] = preparets(net, {}, {}, oldSeries);
[net, tr] = train(net, inputs, targets, inputStates, layerStates);
save 'netHVACsum.mat' net
end
