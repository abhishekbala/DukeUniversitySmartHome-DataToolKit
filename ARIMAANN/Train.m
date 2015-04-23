function net = Train()

%Gets all historical sub-metered data from the month of March
smartHomeData = importdata('shHistoricalTestDataMarch29.csv');

%Extracts and formats the hvac data (or whatever is the correct appliance)
hvacColumn = smartHomeData(:,6) + smartHomeData(:,7) + ...
    smartHomeData(:,8) + smartHomeData(:,9);
hvac = [smartHomeData(:,1) hvacColumn];

%Interpolates missing data points
HistMatPre = fixMissingValues(hvac);

%Converts second level data to minute level averages
Hist = MinuteAverageFromSecondData(HistMatPre);

%Formats data
trainingData = Hist(:,2)';
oldSeries = num2cell(trainingData);

%Runs autocorrelation to determine ideal lags in data
[feedbackDelaysValuespre, feedbackDelayspre] = Correlation(trainingData, trainingData);

%Finds peak lags
[feedbackDelaysValues, feedbackDelays] = findpeaks(feedbackDelaysValuespre);
feedbackDelaysValues2 = zeros(1,10);

%Removes all lags greater than the size of whatever disagg. data
%Will be input in the future.
%Adds these lags to a vector.
lag0=[1];
for k = 1:10
    feedbackDelaysValues2(k) = max(abs(feedbackDelaysValues));
    if((feedbackDelays(find(abs(feedbackDelaysValues)==feedbackDelaysValues2(k))))<720)
        lag0(k) = feedbackDelays(find(abs(feedbackDelaysValues)==feedbackDelaysValues2(k)));
    end
    removeIndex = find(abs(feedbackDelaysValues)==feedbackDelaysValues2(k))
    feedbackDelaysValues(removeIndex) = min(abs(feedbackDelaysValues));
end

%Ensures there aren't duplicates or 0s
lag0(1,size(lag,2)+1) = 1;
lags1 = sort(lag);
lags2 = unique(lags1)
lags = lags2(lags2~=0);

hiddenLayerSize = 10;

%Creates hybrid ANN-ARIMA net
net = narnet(lags, hiddenLayerSize);

%Formats input data
[inputs, inputStates, layerStates, targets] = preparets(net, {}, {}, oldSeries);

%Trains neural net
[net, tr] = train(net, inputs, targets, inputStates, layerStates);

%Saves net
save 'netHVACsum.mat' net
end
