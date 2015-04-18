function [values, output] = Correlation(inputs, targets) 

clf;
%Hist = importdata('shHistoricalTestDataMarch29.csv');
%Rec = importdata('shRecentTestDataMarch29.csv');



%targets = Hist(1:367019,12)';
%inputs = Rec(:,12)';
%inputs = cell2mat(X);
%targets = cell2mat(T);

number_obs = size(targets, 2);
ZT = zscore(targets,1);
ZX = zscore(inputs,1);
index_95 = floor(0.95*(2*number_obs-1));
for i = 1:100
    rand_norm = zscore(randn(1,number_obs),1);
      [Coeff1_norm,  Coeff1_norm_lags] = xcorr(ZT, rand_norm, 'coeff');
           % Also, could use
%autocorrT = nncorr(ZT,ZT,N-1);
%crosscorrXTR = nncorr(ZX,ZT,N-1); % Incorrectly symmetric
%crosscorrXTL = nncorr(ZT,ZX,N-1); % Incorrectly symmetric
%crosscorrXT = [ crosscorrXTL(1:N-1), crosscorrXTR(N:end) ];
      %sorted_Coeff1_norm = sort(abs(Coeff1_norm));
      %CI_95 = sorted_Coeff1_norm(index_95);
      %CI_95_vector(i) = CI_95;
  end
%CI_95_average = mean(CI_95_vector);
[TargetTargetCoeff, TargetTargetCoeff_lags] = xcorr(ZT, 'coeff');

% Plot the corr. coefficients and the 95% CI
%CI_ForGraph = CI_95_average*ones(size(TargetTargetCoeff_lags,2), 1);
figure(1)
plot(TargetTargetCoeff_lags', TargetTargetCoeff');%, TargetTargetCoeff_lags', CI_ForGraph);
title('Target-target auto-correlation')


count = 0;
counter = 0;
for i = TargetTargetCoeff_lags
    
    if i>0
        count = count+1;
        output(count) = i;
        values(count) = TargetTargetCoeff(counter);
    end
    counter=counter+1;
end
        
%maxLag = TargetTargetCoeff_lags(find(TargetTargetCoeff)==(max(TargetTargetCoeff)));