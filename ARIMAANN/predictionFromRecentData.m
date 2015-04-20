function result = predictionFromRecentData(net, recPre)
%recPre is the .mat file of input data with two columns in it -
%preprocessed
timePredict = recPre(end-9:end, 1);
rec = recPre(1:end-10,2)';
alldata = recPre(1:end,2)';
mostRec = recPre(end-9:end,2)';

old = rec;
oldnewlast = [];
for i = 1:10;
old = [old oldnewlast];

%if(i==1)
y(1:size(old,2)) = old(1:end);
%else
    %y(1:size(old,2)-1) = old(2:end);
%end
    

Ypred = num2cell(y);

gotHere = 1;
nets = removedelay(net);
[a1, b1, c1, d1] = preparets(nets, {}, {}, Ypred);

gotHere = 2;
outputer = nets(a1,b1,c1);

gotHere = 3;
oldnew = cell2mat(outputer);
oldnewlast = oldnew(1,end);
end

old = [old oldnewlast];

predict = old(1,end-9:end)
plot(1:length(alldata),alldata, (length(rec)+1):length(alldata),predict)
xlabel('Time (minutes)')
ylabel('Refrigerator Power  (Watts)')
title('Graph of Actual vs. Predicted Power Values')
axis([length(alldata)-100 length(alldata) -200 200])
legend('Actual Real-time Disaggregated Data', 'Predicted Disagregatted Data',0)%, 'Anomaly Benchmark', 'Anomaly Benchmark')
anomalyVec = zeros(1,10)
for i = 1:10;
    if (mostRec(i)-predict(i))>std(rec)
        anomalyVec(i) = 1;
    end  
end
anomalyCol = anomalyVec';
predictCol = predict';
mostRec = mostRec';
result = [timePredict mostRec predictCol anomalyCol]
predLength = length(predict);
othLength = length(mostRec);

rms = sqrt(sum((mostRec(:)-predict(:)).^2))/numel(mostRec)
sub = mostRec(:)-predict(:);
view = mostRec(:);
div = sub./view;
nums = numel(mostRec(:));
first = sum(div);
percenterror = first/nums
%end

end