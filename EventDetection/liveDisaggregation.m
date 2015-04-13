function liveDisaggregation()

% Create an output CSV file
M = zeros(1,4);
csvwrite('eventData.csv',M);

% Create figures to call later
figure1 = figure('CloseRequestFcn',@figureCloseReq);
%figure1.WindowStyle = 'docked';
drawnow;

% Loading On Files
% onFiles = prtUtilSubDir('OnFeatures','*.mat');
% fullOnSet = prtDataSetClass();
% for iFile = 1:length(onFiles)
%     %cFile = onFiles{iFile};
%     load(onFiles{iFile});
%     fullOnSet = catObservations(fullOnSet, onFeatureSet);
%     %plot(onFeatureSet)
% end

load ..\EventDetection\OnFeatures\onFeatures.mat
fullOnSet = onFeatures;

% % Loading Off Files
% offFiles = prtUtilSubDir('OffFeatures','*.mat');
% fullOffSet = prtDataSetClass();
% for iFile = 1:length(offFiles)
%     %cFile = offFiles{iFile};
%     load(offFiles{iFile});
%     fullOffSet = catObservations(fullOffSet, offFeatureSet);
% end

load ..\EventDetection\OffFeatures\offFeatures.mat
fullOffSet = offFeatures;

maxONSlope = max(fullOnSet.data(:,1));
maxONDelta = max(fullOnSet.data(:,2));
fullOnSet.data(:,1) = fullOnSet.data(:,1)/maxONSlope;
fullOnSet.data(:,2) = fullOnSet.data(:,2)/maxONDelta;

minOFFSlope = min(fullOffSet.data(:,1));
maxOFFDelta = max(fullOffSet.data(:,2));
fullOffSet.data(:,1) = fullOffSet.data(:,1)/minOFFSlope;
fullOffSet.data(:,2) = fullOffSet.data(:,2)/maxOFFDelta;

%
knnClassifierOn = prtClassKnn;
knnClassifierOn.k = 5;
knnClassifierOn = knnClassifierOn.train(fullOnSet);

knnClassifierOff = prtClassKnn;
knnClassifierOff.k = 5;
knnClassifierOff = knnClassifierOff.train(fullOffSet);
Pmax = 2;
dcsID = 0;


% Creating fixed variables: myOn, myOff, myEvents
liveData = importdata('../dataCollectors/shData.csv');
aggregatePower = sum(liveData(:,2:3),2) - sum(liveData(:,4:5));

if(size(aggregatePower, 1) == 1 && size(aggregatePower, 2) ~= 1) % Making sure data is in right format
    aggregatePower = aggregatePower';
end

myOn = zeros(size(aggregatePower));
myOff = zeros(size(aggregatePower));
myEvents = zeros(size(aggregatePower));

% Indicator of 1st loop:
myIndicator = 0;

% Create a stop loop:
FS = stoploop({'Click me to:', 'Exit out of the Loop'});

% Create vector storing Appliance IDs for every event
appID = [];
eventType = [];
eventTimeStamp = [];
% Main Loop: 
while (~FS.Stop())
    liveData = importdata('../dataCollectors/shData.csv');
    unixTime = liveData(:,1);
    aggregatePower = sum(liveData(:,2:3),2) - sum(liveData(:,4:5));
    dataLength = length(aggregatePower);
    
    if (length(myOn) < dataLength)
        myOn(dataLength) = 0; % Matlab code automatically fills in zeros in between
        myOff(dataLength) = 0;
        myEvents(dataLength) = 0;
    elseif (length(myOn) > dataLength)
        delta = length(myOn) - dataLength;
        myOn(1:delta) = []; % Truncates data based on python
        myOff(1:delta) = [];
        myEvents(1:delta) = [];
    end
    
    % Event Detection
    
    % Max-Min Manipulations
    
    maxOn = find(myOn == 1, 1, 'last');
    maxOff = find(myOff == 1, 1, 'last');
    
    myMax = max([maxOn maxOff]);
    
    if(isempty(myMax))
        myMax = 0;
    end
    
    if(myIndicator == 0)
        [onDummy, offDummy, eventsDummy] = GLR_EventDetection(aggregatePower,80,15,10,-20,1,0,4);
        on = onDummy;
        off = offDummy;
        events = eventsDummy;
        myIndicator = 1;
    else
        dataSampleLength = dataLength - myMax;
        prev_On = myOn(1:myMax);
        prev_Off = myOff(1:myMax);
        prev_Events = myEvents(1:myMax);
        
        [onDummy, offDummy, eventsDummy] = GLR_EventDetection(aggregatePower((myMax+1):dataLength),80,15,10,-20,1,0,4);
        
        on = [prev_On' onDummy];
        off = [prev_Off' offDummy];
        events = [prev_Events' eventsDummy];
        
        onDummy = [zeros(1, myMax) onDummy];
        offDummy = [zeros(1, myMax) offDummy];
        eventsDummy = [zeros(1, myMax) eventsDummy];
    end
    trainingWindow = 10;
    
    GLRMax = find(events == 1, 1, 'last');
    
    if(isempty(GLRMax))
        GLRMax = 0;
    end
    
    % This section refreshes the event detection properly, ignoring
    % irrelevant points:
    if(GLRMax > myMax)
        on(1:maxOn) = 0;
        off(1:maxOff) = 0;
        
        myOn = myOn + on';
        myOff = myOff + off';
    end
    
    % Plotting
    clf; % Clear Relevant Figures
    % Call Figure 1 and update without stealing focus
    changeFigure(figure1);
    hold on;
    plot(aggregatePower);
    plotMyOn = myOn;
    plotMyOff = myOff;
    plotMyOn(plotMyOn == 0) = NaN;
    plotMyOff(plotMyOff == 0) = NaN;
    plot(plotMyOn.*aggregatePower, 'ro', 'linewidth', 2);
    plot(plotMyOff.*aggregatePower, 'go', 'linewidth', 2);
    hold off;
    title('Events detected');
    xlabel('Time Series Values (s)');
    ylabel('Power Values (W)');
    legend('Data', 'On Events', 'Off Events');
    
    % Disaggregation
    for i = (1 + trainingWindow):(dataLength-trainingWindow)
        
        if onDummy(i) == 1
            eventWindow = aggregatePower(i-trainingWindow:i+trainingWindow)';
            eventSlope = polyfit(1:length(eventWindow),eventWindow,1)/maxONSlope;
            eventDelta = max(eventWindow) - min(eventWindow)/maxONDelta;
            eventFeatures = prtDataSetClass([eventSlope(1) eventDelta]);
            knnClassOut = knnClassifierOn.run(eventFeatures);
            [~, dcsID] = max(knnClassOut.data);
            
            filterFrom = fullOnSet;
            filterFeatures = filterFrom.retainClasses(dcsID);
            
            distance = prtDistanceEuclidean(eventFeatures,filterFeatures);
            maxDistanceON = max(distance);
            meanDistanceON = mean(distance);
            MaxDistanceON = [MaxDistanceON maxDistanceON];
            MeanDistanceON = [MeanDistanceON meanDistanceON];
            
            if and(~or(dcsID == 3, dcsID == 4), meanDistanceON > 0.005)
                dcsID = 0; % Classifies the ith detected on-event as OTHER
            end
            
            fprintf('%1.0f is the appliance ON at time %5.3f \n', dcsID, i);
            
            appID = [appID dcsID];
            eventTimeStamp = [eventTimeStamp unixTime(i)];
            eventType = [eventType 1];
            M = [unixTime(i) dcsID eventDelta 1];
            dlmwrite('eventData.csv',M,'-append','newline','pc');
            
            % The below code works while live:
            % text(i,aggregatePower(i),num2str(dcsID),'Color','red','FontSize',20,'FontSmoothing','on','Margin',8);
        end
        if offDummy(i) == 1
            eventWindow = aggregatePower(i-trainingWindow:i+trainingWindow)';
            eventSlope = polyfit(1:length(eventWindow),eventWindow,1)/minOFFSlope;
            eventDelta = max(eventWindow) - min(eventWindow)/maxOFFDelta;
            eventFeatures = prtDataSetClass([eventSlope(1) eventDelta]);
            knnClassOut = knnClassifierOff.run(eventFeatures);
            [~, dcsID] = max(knnClassOut.data);
            
            filterFrom = fullOffSet;
            filterFeatures = filterFrom.retainClasses(dcsID);
            
            distance = prtDistanceEuclidean(eventFeatures,filterFeatures);
            maxDistanceOFF = max(distance);
            meanDistanceOFF = mean(distance);
            MaxDistanceOFF = [MaxDistanceOFF maxDistanceOFF];
            MeanDistanceOFF = [MeanDistanceOFF meanDistanceOFF];
            
            % Printing Out Appliance Classification
            if and(~or(dcsID == 3, dcsID == 4), meanDistanceOFF > 0.005)
                dcsID = 0; % Classifies the ith detected on-event as OTHER
            end
            
            fprintf('%1.0f is the appliance OFF at time %5.3f \n', dcsID, i);
            
            appID = [appID dcsID];
            eventTimeStamp = [eventTimeStamp unixTime(i)];
            eventType = [eventType 0];
            
            M = [unixTime(i) dcsID eventDelta 1];
            dlmwrite('eventData.csv',M,'-append','newline','pc');
            
            % The below code works while live:
            % text(i,aggregatePower(i),num2str(dcsID),'Color','green','FontSize',20,'FontSmoothing','on','Margin',8);
        end
    end

    % 1 second pause
     pause(1)
end
FS.Clear();
clear FS;
appLabels
end