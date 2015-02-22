function eventsDetected = FastGLR_forEventDetectionMetrics(data, w_BeforeAfterLength, w_GLRLength, SignalNoiseRatio, preProcessOption, GLRSmoothingOption, ZScoreValue)
%% Parameters
% Output: eventsDetected => Binary array of when events turn on. 1 = event
% and 0 = non-event
%
% Data => inputted data
% w_BeforeAfterLength ==> Represents the window length for calculating
% statistics. Remember, in general, a window length of > 30 gets closer and
% closer to normally distributed.
%                   DEFAULT: 40
% w_GLRLength ==> Increase or decrease window which we calculate GLR.
%                   DEFAULT: 30
% SignalNoiseRatio ==> Determines how strong additive wgn is. 
%                   DEFAULT 1
% preProcessOption ==> Values 0 to 4. 
%                    DEFAULT 3: smoothing + additive
% GLRSmoothingOption ==> Values 0 to 4. 
%                   DEFAULT 0: No smoothing
% ZScoreValue ==> Threshold of transitional importance. 
%                   DEFAULT 4: 99.99% Noise elminiation

if(nargin == 1)
    w_BeforeAfterLength = 40;
    w_GLRLength = 30;
%     v_Threshold = 25;
    SignalNoiseRatio = 1;
    preProcessOption = 3;
    GLRSmoothingOption = 0;
    ZScoreValue = 4;
end

%% DETECT EVENTS USING GENERALIZED LIKELIHOOD RATIO

%% Defining Variables
wa = w_BeforeAfterLength; % Window of the next 100 points
wb = w_BeforeAfterLength; % Window of the previous 100 points
current = wb; % Initialize the point in which the pointer starts at
startIndex = current; % Initialize the start index at the 100th data point
wl = w_GLRLength; % Window in which we calculate the GLR

% We are getting rid of this parameter in order to vary and make the ROC
% Curves
% % % % % % % % % vt = v_Threshold; % Voting threshold


dataLength = length(data); % Length of the data
l = zeros(1, dataLength); % GLR values for all the data points in set
s = zeros(1, dataLength); % Generalized voting statistic for data points
v = zeros(1, dataLength); % Votes for each particular data point

SNR = SignalNoiseRatio; % Signal to Noise Ratio

%% Preprocessing the Data:
%%%%%% Testing Cases: Include adding white gaussian noise, ect. 1 OF 5
%%%%%% OPTIONS!!!!!
switch preProcessOption
    case 0 % No preprocessing
        modifiedData = data;
    case 1 % Adding only white gaussian noise
        modifiedData = awgn(data, SNR);
    case 2 % Only smoothing data
        modifiedData = smooth(data, 'sgolay');
    case 3 % First adding white gaussian noise, then smoothing
        modifiedData = smooth(awgn(data, SNR), 'sgolay');
    case 4 % First smoothing the data then adding additive white gaussian noise
        modifiedData = awgn(smooth(data, 'sgolay', 4), SNR);
end

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
switch GLRSmoothingOption
    case 0
        l = 1.*l;
    case 1
        smooth(l, 'moving');
    case 2
        smooth(l, 'sgolay');
    case 3
        smooth(l, 'rloess');
    case 4
        smooth(l, 'rlowess');
end

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
    
    if(abs(Za) < ZScoreValue && abs(Zb) < ZScoreValue) % 99.99% Interval
        v(smaxi) = v(smaxi) + 0;
    else
        v(smaxi) = v(smaxi) + 1;
    end
    
    
    
end

%% Thresholding the vote counts. Normalizing vote count to data and plotting:
%sum(v);
% % % % % % % v(v < vt) = 0;
% % % % % % % v(v >= vt) = 1;
% % % % % % % eventsDetected = v;
% % % % % % % v = v.*(data');

eventsDetected = v;

%% Plotting Relevant Features

% plot(v);

% clf; % Clear Relevant Figures
% 
% figure(1);
% hold on;
% plot(data);
% plot(v, 'ro', 'linewidth', 2);
% hold off;
% title('Events detected');
% xlabel('Time Series Values (s)');
% ylabel('Power Values (W)');
% legend('Data', 'Events');

% figure(2);
% plot(modifiedData);
% title('GLR Values for Each Point (No Smoothing)');
% xlabel('Time Series Values (s)');
% ylabel('GLR Values');

end