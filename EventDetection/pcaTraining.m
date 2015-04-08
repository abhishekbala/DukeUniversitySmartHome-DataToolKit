function [onMatrix, offMatrix] = pcaTraining(data, on, off)
%% Extract 61 points around each ON Event
onIndex = find(on);
offIndex = find(off);
onMatrix = zeros(length(onIndex), 61);
offMatrix = zeros(length(offIndex), 61);
%% Normalize on/off windows
for i = 1:length(onIndex)
    onMean = mean(data(onIndex(1,i)-30:onIndex(1,i)+30,1));
    onStd = std(data(onIndex(1,i)-30:onIndex(1,i)+30,1));
    onMatrix(i, :) = ((data(onIndex(1,i)-30:onIndex(1,i)+30,1) - onMean))'; % / onStd)';
end
onMatrix;
for i = 1:length(offIndex)
    offMean = mean(data(offIndex(1,i)-30:offIndex(1,i)+30,1));
    offStd = std(data(offIndex(1,i)-30:offIndex(1,i)+30,1));
    offMatrix(i, :) = ((data(offIndex(1,i)-30:offIndex(1,i)+30,1) - offMean))'; % / offStd)';
end
offMatrix;
