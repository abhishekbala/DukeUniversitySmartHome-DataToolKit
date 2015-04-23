function result = predictionFromRecentData(net, recPre)

%Creates vector of timestamps for the last ten mins of disagg. data
timePredict = recPre(end-9:end, 1);


%Creates vector of all disagg. data power values (for graphing if desired)
alldata = recPre(1:end,2)';

%Creates vector of all disagg. data power values minus the last ten mins
rec = recPre(1:end-10,2)';

%Creates vector of the last ten mins of power values of disagg. data 
mostRec = recPre(end-9:end,2)';

inputData = rec;
inputDataNewest = [];

%Recursively predict the next 10 minutes of data
for i = 1:10;
    
%Adds predicted data point to old data    
inputData = [inputData inputDataNewest];

y(1:size(inputData,2)) = inputData(1:end);
preFormatted = num2cell(y);

nets = removedelay(net);
[a1, b1, c1, d1] = preparets(nets, {}, {}, preFormatted);

formattedInputData = nets(a1,b1,c1);

cellFormattedInputData = cell2mat(formattedInputData);
inputDataNewest = cellFormattedInputData(1,end);
end

inputData = [inputData inputDataNewest];

%Extracts most recent 10 minutes of data from old data + predictions
%These are the predicted data values
predict = inputData(1,end-9:end);

anomalyVec = zeros(1,10);

%Detects anomalies if the most recent 10 minutes of disagg. data
%Aren't within an acceptable range of the predicted data
for i = 1:10;
    if (mostRec(i)-predict(i))>std(rec)
        anomalyVec(i) = 1;
    end  
end

%Creates matrix of timestamps, predicted data values, and whether or not
%There is an anomaly at a given point

anomalyCol = anomalyVec';
predictCol = predict';
mostRec = mostRec';

result = [timePredict mostRec predictCol anomalyCol]
end