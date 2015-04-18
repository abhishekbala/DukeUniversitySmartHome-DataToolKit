clear;


old = [0,1.1,2,1,0.8,0.7,0.6];


oldSeries = num2cell(old);

lags = 1:5

hiddenLayerSize = 10;

net = narnet(lags, hiddenLayerSize);

[inputs, inputStates, layerStates, targets] = preparets(net, {}, {}, oldSeries);
[net, tr] = train(net, inputs, targets, inputStates, layerStates);

oldnewlast = [];
for i = 1:10;

old = [old oldnewlast];

%if(i==1)
    y(1:size(old,2)) = old(1:end);
%else
%    y(1:size(old,2)-i+1) = old(i:end);
%end

%y(1:6) = old(end-5:end);
Ypred = num2cell(y);

gotHere = 1
nets = removedelay(net);
[a1, b1, c1, d1] = preparets(nets, {}, {}, Ypred);

gotHere = 2
outputer = nets(a1,b1,c1);

gotHere = 3;
oldnew = cell2mat(outputer);
oldnewlast = oldnew(1,end);
end

