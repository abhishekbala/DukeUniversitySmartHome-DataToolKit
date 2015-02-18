function ROC(truthVals, dataSet)

clf;
Vt = 1:4:21; % Voting Thresholds
maxVt = 21;
PrDetection = zeros(size(Vt));
FAR = zeros(size(Vt));

%% This ROC Function runs the TPR_FPR multiple times and generates ROC Curves
% Based on the following values:
% w_BeforeAfterLength, w_GLRLength, v_Threshold, SignalNoiseRatio,
% preProcessOption, GLRSmoothingOption, ZScoreValue

% PVV ==> Parameter Variation Value
% 1 = ZScoreValue
% 2 = GLRSmoothingOption
% 3 = preProcessOption
% 4 = SignalNoiseRatio
% 5 = v_Threshold
% 6 = w_GLRLength
% 7 = w_BeforeAfterLength

% % %% This section assigns 'Val' a set of different varying values:
% % % Based off the specific parameter being called upon.
% % %
% % % For example, if PVV = 1, then it is logical for us to assign the varying
% % % parameters from 0 to only a few standard deviations away.
% % %
% % % In contrast, if PVV = 1, then it is only logical that we must assign the
% % % varying parameters from 0 to 4, because the specific elements are
% % % discrete
% % 
% % switch PVV
% %     case 1 % 1 = ZScoreValue
% %         Vals = linspace(0, 4, 4*4+1);
% %     case 2 % 2 = GLRSmoothingOption
% %         Vals = [0, 1, 2, 3, 4];
% %     case 3 % 3 = preProcessOption
% %         Vals = [0, 1, 2, 3, 4];
% %     case 4 % 4 = SignalNoiseRatio
% %         Vals = logspace(-3,3,21);
% %     case 5 % 5 = v_Threshold
% %         Vals = linspace(1,30,30);
% %     case 6 % 6 = w_GLRLength
% %         Vals = 2:2:100;
% %     case 7 % 7 = w_BeforeAfterLength
% %         Vals = 2:1:50;
% % end
% % 
% % mSqrD = zeros(size(Vals)); % Each varying parameter has a corresponding value
% %                            % that represents the squared distance of (TPR,
% %                            % FPR) to (1, 0).
% % 
% % figure(1);
% % hold on;
% % 
% % %% This section creates plots of ROC Curves and Parameters vs. Sqr Distance
% % switch PVV
% %     case 1 % 1 = ZScoreValue
% %         for(i = 1:length(Vals))
% %             [TPR, FPR] = TPR_FPR(truthVals, dataSet, 40, 30, 25, 1, 3, 0, Vals(i));
% %             mSqrD(i) = sqrt((1 - TPR).^2 + (0 - FPR).^2);
% %             plot(FPR, TPR, 'ro');
% %         end
% %         hold off;
% %         title('ROC Curve for Variation of Parameter Z-Score Value (GLRTestData4)');
% %         xlabel('False Positive Rate (FPR)');
% %         ylabel('True Positive Rate (TPR)');
% %         axis([-0.1 1.1 -0.1 1.1]);
% %         
% %         figure(2);
% %         plot(Vals, mSqrD);
% %         title('Z-Vals vs. Square Distance to Best Value (1, 0) for (TPR, FPR)');
% %         xlabel('Normalized Z Value');
% %         ylabel('Squared Distance to Best (TPR, FPR) Value');
% %     case 2 % 2 = GLRSmoothingOption
% %         for(i = 1:length(Vals))
% %             [TPR, FPR] = TPR_FPR(truthVals, dataSet, 40, 30, 25, 1, 3, Vals(i), 4);
% %             mSqrD(i) = sqrt((1 - TPR).^2 + (0 - FPR).^2);
% %             plot(FPR, TPR, 'ro');
% %         end
% %         hold off;
% %         title('ROC Curve for Variation of Parameter GLRSmoothing Value (GLRTestData4)');
% %         xlabel('False Positive Rate (FPR)');
% %         ylabel('True Positive Rate (TPR)');
% %         axis tight;
% %         
% %         figure(2);
% %         plot(Vals, mSqrD, 'MarkerSize', 14);
% %         title('GLRSmoothing Parameter vs. Square Distance to Best Value (1, 0) for (TPR, FPR)');
% %         xlabel('Smoothing Parameter');
% %         ylabel('Squared Distance to Best (TPR, FPR) Value');
% %     case 3 % 3 = preProcessOption
% %         for(i = 1:length(Vals))
% %             [TPR, FPR] = TPR_FPR(truthVals, dataSet, 40, 30, 25, 1, Vals(i), 0, 4);
% %             mSqrD(i) = sqrt((1 - TPR).^2 + (0 - FPR).^2);
% %             plot(FPR, TPR, 'ro');
% %         end
% %         hold off;
% %         title('ROC Curve for Variation of Parameter Preprocessing Value (GLRTestData4)');
% %         xlabel('False Positive Rate (FPR)');
% %         ylabel('True Positive Rate (TPR)');
% %         axis tight;
% %         
% %         figure(2);
% %         plot(Vals, mSqrD, 'ro', 'MarkerSize', 14);
% %         title('Preprocessing Parameter vs. Square Distance to Best Value (1, 0) for (TPR, FPR)');
% %         xlabel('Preprocessing Parameter');
% %         ylabel('Squared Distance to Best (TPR, FPR) Value')
% %     case 4 % 4 = SignalNoiseRatio
% %         for(i = 1:length(Vals))
% %             [TPR, FPR] = TPR_FPR(truthVals, dataSet, 40, 30, 25, Vals(i), 3, 0, 4);
% %             mSqrD(i) = sqrt((1 - TPR).^2 + (0 - FPR).^2);
% %             plot(FPR, TPR, 'ro');
% %         end
% %         hold off;
% %         title('ROC Curve for Variation of Signal to Noise Ratio Value (GLRTestData4)');
% %         xlabel('False Positive Rate (FPR)');
% %         ylabel('True Positive Rate (TPR)');
% %         axis tight;
% %         
% %         figure(2);
% %         semilogx(Vals, mSqrD);
% %         title('Signal to Noise Ratio vs. Square Distance to Best Value (1, 0) for (TPR, FPR)');
% %         xlabel('Signal to Noise Ratio');
% %         ylabel('Squared Distance to Best (TPR, FPR) Value')
% %     case 5 % 5 = v_Threshold
% %         for(i = 1:length(Vals))
% %             [TPR, FPR] = TPR_FPR(truthVals, dataSet, 40, 30, Vals(i), 1, 3, 0, 4);
% %             mSqrD(i) = sqrt((1 - TPR).^2 + (0 - FPR).^2);
% %             plot(FPR, TPR, 'ro');
% %         end
% %         hold off;
% %         title('ROC Curve for Variation of Voting Threshold Value (GLRTestData4)');
% %         xlabel('False Positive Rate (FPR)');
% %         ylabel('True Positive Rate (TPR)');
% %         
% %         figure(2);
% %         plot(Vals, mSqrD);
% %         title('Voting Threshold vs. Square Distance to Best Value (1, 0) for (TPR, FPR) with GLR Window 30');
% %         xlabel('Voting Threshold');
% %         ylabel('Squared Distance to Best (TPR, FPR) Value')
% %     case 6 % 6 = w_GLRLength
% %         for(i = 1:length(Vals))
% %             [TPR, FPR] = TPR_FPR(truthVals, dataSet, 40, Vals(i), floor(0.8*Vals(i)), 1, 3, 0, 4);
% %             mSqrD(i) = sqrt((1 - TPR).^2 + (0 - FPR).^2);
% %             plot(FPR, TPR, 'ro');
% %         end
% %         hold off;
% %         title('ROC Curve for Variation of GLR Window Length Value (GLRTestData4)');
% %         xlabel('False Positive Rate (FPR)');
% %         ylabel('True Positive Rate (TPR)');
% %         
% %         figure(2);
% %         plot(Vals, mSqrD);
% %         title('GLR Window Length vs. Square Distance to Best Value (1, 0) for (TPR, FPR) with Voting Threshold Ratio 0.8');
% %         xlabel('GLR Window Length');
% %         ylabel('Squared Distance to Best (TPR, FPR) Value');
% %     case 7 % 7 = w_BeforeAfterLength
% %         for(i = 1:length(Vals))
% %             [TPR, FPR] = TPR_FPR(truthVals, dataSet, Vals(i), 30, 25, 1, 3, 0, 4);
% %             mSqrD(i) = sqrt((1 - TPR).^2 + (0 - FPR).^2);
% %             plot(FPR, TPR, 'ro');
% %         end
% %         hold off;
% %         title('ROC Curve for Variation of Statistical Window Length Value (GLRTestData4)');
% %         xlabel('False Positive Rate (FPR)');
% %         ylabel('True Positive Rate (TPR)');
% %         
% %         figure(2);
% %         plot(Vals, mSqrD);
% %         title('Statistical Window Length vs. Square Distance to Best Value (1, 0) for (TPR, FPR)');
% %         xlabel('Statistical Window Length');
% %         ylabel('Squared Distance to Best (TPR, FPR) Value');     
% % end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% This section varies the parameter ZScoreValue
% 
% figure(1);
% hold on;
% for(zVal = 0:4)
%     for(i = 1:length(Vt))
%         [TPR, FPR] = TPR_FPR(truthVals, dataSet, 40, maxVt, Vt(i), 1, 3, 0, zVal);
%         PrDetection(i) = TPR;
%         FAR(i) = FPR;
%     end
%     plot(FAR, PrDetection);
% end
% hold off;
% title('ROC Curve for Various Z-Score Value');
% xlabel('False Alarm Rate (FAR)');
% ylabel('Probability of Detection (TPR)');
% legend('Z = 0', 'Z = 1', 'Z = 2', 'Z = 3', 'Z = 4');

%% This Section Varies the Parameter GLRSmoothing
% % 0 ==> No smoothing
% % 1 ==> Moving Average Smoothing
% % 2 ==> 'sgolay' Savitsky-Golay
% % 3 ==> 'rloess' Quadratic Fit
% % 4 ==> 'rlowess' Linear Fit
% 
% Vals = [0, 1, 2, 3, 4];
% 
% figure(1);
% hold on;
% for(i = 1: length(Vals))
%     for(j = 1:length(Vt))
%         [TPR, FPR] = TPR_FPR(truthVals, dataSet, 40, maxVt, Vt(j), 1, 3, Vals(i), 4);
%         PrDetection(j) = TPR;
%         FAR(j) = FPR;
%     end
%     plot(FAR, PrDetection);
% end
% 
% hold off;
% title('ROC Curve for Various GLR Smoothing Parameters');
% xlabel('False Alarm Rate (FAR)');
% ylabel('Probability of Detection (TPR)');
% legend('Parameter 0', 'Parameter 1', 'Parameter 2', 'Parameter 3', 'Parameter 4');


%% This Section Varies Preprocessing Option
% % 0 ==> No preprocessing
% % 1 ==> Adding only White Gaussian Noise
% % 2 ==> Only Savitsky-Golay Smoothing
% % 3 ==> First add WGN, then Savitsky-Goly Smoothing
% % 4 ==> Firsts smooths using Savitsky-Golay, then adding wgn.
% 
% Vals = [0, 1, 2, 3, 4];
% 
% figure(1);
% hold on;
% for(i = 1:length(Vals))
%     for(j = 1:length(Vt))
%         [TPR, FPR] = TPR_FPR(truthVals, dataSet, 40, maxVt, Vt(j), 1, Vals(i), 0, 4);
%         PrDetection(j) = TPR;
%         FAR(j) = FPR;
%     end
%     plot(PrDetection, FAR);
% end
% hold off;
% title('ROC Curve for Variation of Preprocessing Parameters');
% xlabel('False Alarm Rate (FAR)');
% ylabel('Probability of Detection');
% legend('Parameter 0', 'Parameter 1', 'Parameter 2', 'Parameter 3', 'Parameter 4');


%% This Section Varies Signal to Noise Ratio
% Vals = -10:5:30;
% 
% figure(1);
% hold on;
% for(i = 1:length(Vals))
%     for(j = 1:length(Vt))
%         [TPR, FPR] = TPR_FPR(truthVals, dataSet, 40, maxVt, Vt(j), Vals(i), 3, 0, 4);
%         PrDetection(j) = TPR;
%         FAR(j) = FPR;
%     end
%     subplot(3,3,i); plot(FAR, PrDetection);
%     title(['ROC Curve for SNR ' num2str(Vals(i))]);
%     xlabel('False Alarm Rate (FAR)');
%     ylabel('Probability of Detection');
% end
% hold off;

%% This Section Varies the Statistical Window Length
Vals = 5:5:40;

figure(1);
hold on;
for(i = 1:length(Vals))
    for(j = 1:length(Vt))
        [TPR, FPR] = TPR_FPR(truthVals, dataSet, Vals(i), maxVt, Vt(j), 1, 3, 0, 4);
        PrDetection(j) = TPR;
        FAR(j) = FPR;
    end
    subplot(3,3,i); plot(FAR, PrDetection);
    title(['ROC Curve for SWL ' num2str(Vals(i))]);
    xlabel('False Alarm Rate (FAR)');
    ylabel('Probability of Detection');
end
hold off;

end
