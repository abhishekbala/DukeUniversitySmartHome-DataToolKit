function eventDetectionMetrics(truthVals, myVals)
p = linspace(0.1,1,100);
TP = zeros(size(p));
FP = zeros(size(p));
TN = zeros(size(p));
FN = zeros(size(p));

normVals = abs(myVals);
normVals = normVals./max(normVals);

myMatx = zeros(length(p), length(truthVals));

for(i = 1:length(p))
    for(j = 1:length(normVals))
        if(normVals(j) >= p(i))
            myMatx(i, j) = 1;
%             if(j < length(normVals) - 5 && j > 5)
%                 myMatx(i, (j-4):(j+4)) = 1;
%             end
        end
    end
end

for(i = 1:length(p))
    for(j = 1:length(normVals))
        if(myMatx(i,j) == 1 && truthVals(j) == 1)
            TP(i) = TP(i) + 1;
        end
        if(myMatx(i,j) == 1 && truthVals(j) == 0)
            FP(i) = FP(i) + 1;
        end
        if(myMatx(i,j) == 0 && truthVals(j) == 1)
            FN(i) = FN(i) + 1;
        end
        if(myMatx(i,j) == 0 && truthVals(j) == 0)
            TN(i) = TN(i) + 1;
        end
    end
end

FPR = FP./(FP + TN);
TPR = TP./(TP + FN);

clf;

figure(1);
plot(normVals);
title('Normalized Values');

figure(2);
plot(p, TP);
title('True Positives');

figure(3);
plot(p, FP);
title('False Positives');

figure(4);
plot(p, FN);
title('False Negatives');

figure(5);
plot(p, TN);
title('True Negatives');

figure(6);
plot(FPR, TPR);
%plot(TPR)
title('ROC Curve');

end

