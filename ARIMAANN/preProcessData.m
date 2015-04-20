function processedData = preProcessData(recentData)
% Applies two functions to preprocess data:
%   fixMissingValues
%   MinuteAverageFromSecondData

processedData = fixMissingValues(recentData);
processedData = MinuteAverageFromSecondData(processedData);

end