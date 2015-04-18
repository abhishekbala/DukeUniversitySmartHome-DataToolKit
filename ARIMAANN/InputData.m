function result = InputData(net)
result = 'No Anomaly';
load('refrigeratorContinuous.mat');
recDisaggMatrixPre = fixMissingValues(refrigerator);
MinuteAverageFromSecondData(recDisaggMatrixPre);
recPre = importdata('data.csv');
rec = recPre(1:end-10,2)';
trainingData1 = recPre(1:end,2);


%xblock1 = 1:((2345-616)/60);
%xblock2 = 1:((3869-2345)/60);
%xblock3 = 1:((4901-3869)/60);

%yvalue1 = 130.*ones(1,length(xblock1));
%yvalue2 = 100.*ones(1,length(xblock2));
%yvalue3 = 5.*ones(1,length(xblock3));

%y = [yvalue1 yvalue2 yvalue3];
%trainingData1 = [];
%for i = 1:20;
    %trainingData1 = [trainingData1 y];
%end
%rec = trainingData1(1:705);


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
compare = trainingData1;
predict = old(1,end-9:end)
plot(1:length(compare),compare, 4311:(length(predict)+4310),predict)%,1:length(compare),compare-std(rec), 1:length(compare),compare+std(rec))
xlabel('Time (minutes)')
ylabel('Refrigerator Power  (Watts)')
title('Graph of Actual vs. Predicted Power Values')
axis([4250 4320 -300 200])
legend('Actual Real-time Disaggregated Data', 'Predicted Disagregatted Data',0)%, 'Anomaly Benchmark', 'Anomaly Benchmark')
if(any((compare(end+1-length(predict):end)-predict)>std(rec))) result = 'ANAMOLY';

end
result
end