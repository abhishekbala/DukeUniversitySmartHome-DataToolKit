function [values, output] = Correlation(inputs, targets) 

%Runs adapted autocorrelation.
clf;

number_obs = size(targets, 2);

%Has two different inputs so that the xcorr can easily be changed in line
%19 to correlate two different variables - this is useful if the net
%Is being trained on data far in the past in conjunction with a more
%Recent set of data. Identifying lags between these sets can help overcome
%This time gap by cross correlating instead of autocorrelating (line 27).

%However, in this script, autocorrelation is performed in line 27.
ZT = zscore(targets,1);
ZX = zscore(inputs,1);
index_95 = floor(0.95*(2*number_obs-1));

%Comes up with comparison metrics (can be graphed visually)
%Not necessary to generate output of the correlation function, but
%Helpful for error checking
for i = 1:100
    rand_norm = zscore(randn(1,number_obs),1);
      [Coeff1_norm,  Coeff1_norm_lags] = xcorr(ZT, rand_norm, 'coeff');
end

%Autocorrelates
[TargetTargetCoeff, TargetTargetCoeff_lags] = xcorr(ZT, 'coeff');

%Plots autocorrelation to visually check peaks
figure(1)
plot(TargetTargetCoeff_lags', TargetTargetCoeff');
title('Target-target auto-correlation')


count = 0;
counter = 0;

%Formats data correctly for outputting
for i = TargetTargetCoeff_lags
    if i>0
        count = count+1;
        output(count) = i;
        values(count) = TargetTargetCoeff(counter);
    end
    counter=counter+1;
end
        