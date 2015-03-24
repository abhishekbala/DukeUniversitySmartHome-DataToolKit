function [PrDetection, FalseAlarmRate] = ROCRates(truthVals, dataSet, votes, vt)

% Assumptions using this ROC function:
% 1. The accepted truthVal must be a vector of length ceil(length(myVals)/10)

%% Preprocessing of Data Set:
dataSetLength = length(dataSet);
totalTrueEvents = sum(truthVals);

votes(votes < vt) = 0;
votes(votes >= vt) = 1;
EventsDetected = votes;
votes = votes.*(dataSet');

%% Misc Plotting:

% clf; % Clear Relevant Figures
% 
% figure(1);
% hold on;
% plot(dataSet);
% plot(votes, 'ro', 'linewidth', 2);
% hold off;
% title('Events detected');
% xlabel('Time Series Values (s)');
% ylabel('Power Values (W)');
% legend('Data', 'Events');

%% Next Stuff:

myEvents = zeros(1, ceil((length(EventsDetected)+0.01)/10));

for(k = 1:length(EventsDetected))
    if(EventsDetected(k) == 1)
        myEvents(ceil((k+0.001)/10)) = 1;
    end
end

TP = 0; FP = 0; TN = 0; FN = 0;
% TP = True Pos. FP = False Pos. TN = True Neg. FN = False Neg.

for(i = 1:length(truthVals))
        if(truthVals(i) == 1 && myEvents(i) == 1)
            TP = TP + 1;
        end
        if(truthVals(i) == 0 && myEvents(i) == 1)
            FP = FP + 1;
        end
        if(truthVals(i) == 1 && myEvents(i) == 0)
            FN = FN + 1;
        end
        if(truthVals(i) == 0 && myEvents(i) == 0)
            TN = TN + 1;
        end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PrDetection = TP./totalTrueEvents;
FalseAlarmRate = FP./dataSetLength;



end

% Probability of properly detecting an event = (# TP)/(#True events total)
% False Alarm Rate = (#FP)/length(dataSet) ==> Gives us # false alarms/second

