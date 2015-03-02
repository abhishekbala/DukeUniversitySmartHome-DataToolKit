function FastGLR(data)
clf;
% DETECT EVENTS USING GENERALIZED LIKELIHOOD RATIO

%% Defining Variables
wa = 40; % Window of the next 100 points
wb = 40; % Window of the previous 100 points
current = wb; % Initialize the point in which the pointer starts at
startIndex = current; % Initialize the start index at the 100th data point
wl = 30; % Window in which we calculate the GLR
vt = 25; % Voting threshold
dataLength = length(data); % Length of the data
l = zeros(1, dataLength); % GLR values for all the data points in set
s = zeros(1, dataLength); % Generalized voting statistic for data points
v = zeros(1, dataLength); % Votes for each particular data point

SNR = 20; % Signal to Noise Ratio

%% Preprocessing the Data: 
%%%%%% Testing Cases: Include adding white gaussian noise, ect. 1 OF 5
%%%%%% OPTIONS!!!!!
modifiedData = awgn(smooth(data, 'sgolay', 4), SNR); % First smoothing the data then adding additive white gaussian noise
%modifiedData = awgn(data, SNR);
%modifiedData = smooth(data);
%modifiedData = smooth(awgn(data, SNR), 'sgolay');
%modifiedData = data;

myDataStats = zeros(4, length(modifiedData)); 
% For each point in the data set, give the values of:
% Row 1: Mean of wa
% Row 2: Mean of wb
% Row 3: St.D of wa
% Row 4: St.D of wb

for i = (1 + wb):(length(modifiedData)-wa)
    xn = modifiedData(i);
    meana = mean(modifiedData((i+1):(i+wa)));
    meanb = mean(modifiedData((i-wb):(i-1)));
    sigmaa = std(modifiedData((i+1):(i+wa)));
    sigmab = std(modifiedData((i-wb):(i-1)));
    
     myDataStats(1, i) = meana;
     myDataStats(2, i) = meanb;
     myDataStats(3, i) = sigmaa;
     myDataStats(4, i) = sigmab;
    
    l(i) = - (xn - meana)^2 / (2*sigmaa) + (xn - meanb)^2 / (2*sigmab);
end
%%%%% Smoothing Additive (May Improve Performance)
%l = l;
%l = smooth(l, 'sgolay');
%l = smooth(l);


while startIndex + wl - 1 + wa < length(data) % As long as the GLR window + window of after doesn't exceed size of our data set.
    startIndex = startIndex + 1; 
    endIndex = startIndex + wl - 1;

    for wi = 1 : wl
        current = startIndex + wi;
        s(current) = sum(l(current : endIndex)); % A weighting of different GLR values to emphasize earlier values
    end
    
    smaxi = find(s(startIndex : endIndex) == max(s(startIndex : endIndex))); % We want to find the maximum stats value for each window
    smaxi = startIndex - 1 + smaxi;
    
    %% Transitional Priority:
    % This uses statistical confidence intervals to eliminate votes in
    % which the data point is surrounded by 'noise'
    Za = (modifiedData(smaxi) -  myDataStats(1, smaxi))./myDataStats(3, smaxi);
    Zb = (modifiedData(smaxi) -  myDataStats(2, smaxi))./myDataStats(4, smaxi);
    
    if(Za < 4 && Zb < 4) % 99.99% Interval
        v(smaxi) = v(smaxi) + 0;
    else
        v(smaxi) = v(smaxi) + 1; 
    end
    
    
    
end

%% Thresholding the vote counts. Normalizing vote count to data and plotting:
%sum(v);
v(v < vt) = 0;
v(v >= vt) = 1;
v = v.*(data');

%% Plotting Relevant Features

figure(1);
hold on;
plot(data);
plot(v, 'ro', 'linewidth', 2);
hold off;
title('Events detected');
xlabel('Time Series Values (s)');
ylabel('Power Values (W)');
legend('Data', 'Events');


% clf;
% figure(2);
% plot(v);
% title('Vote Counts');

 figure(3);
 plot(l);
 title('Likelihood Ratio');
 xlabel('Time Values (s)');
 ylabel('Ratio');

 figure(4);
 hold on;
 plot(myDataStats(1, :));
 plot(myDataStats(2, :), 'r-');
 hold off;
 legend('Mean of After', 'Mean of Before');
 title('Mean Values');
 xlabel('Time Series Values (s)');
 ylabel('Average Power Values (W)')
 
end