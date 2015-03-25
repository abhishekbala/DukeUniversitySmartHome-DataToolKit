function liveDisaggregation()

     onFiles = prtUtilSubDir('OnFeatures','*.mat');
     fullOnSet = prtDataSetClass();
     for iFile = 1:length(onFiles)
         %cFile = onFiles{iFile};
         load(onFiles{iFile});
         fullOnSet = catObservations(fullOnSet, onFeatureSet);
         plot(onFeatureSet)
     end
%     
     offFiles = prtUtilSubDir('OffFeatures','*.mat');
     fullOffSet = prtDataSetClass();
     for iFile = 1:length(offFiles)
         %cFile = offFiles{iFile};
         load(offFiles{iFile});
         fullOffSet = catObservations(fullOffSet, offFeatureSet);
     end
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
     myOn = [];
     myOff = [];
     
     
    while 1
        liveData = importdata('../dataCollectors/shData.csv');
        % endRow = length(liveData(:,1));

        % Original data
        %figure(1);
        %plot(times, aggregatePower);

        % Keep window (for plotting) at 300seconds (can be changed to any value
        % upto 1800).
        % window = 300;
%        times = liveData(endRow-window:endRow,1);
        aggregatePower = sum(liveData(:,2:3),2);
        dataLength = length(aggregatePower);
        % Plot
        % refresh
%        figure(1);
%        plot(times,aggregatePower);

        % Event Detection
       
        % This portion updates myOn and myOff by shifting by -1
        myOn = myOn - 1;
        myOff = myOff - 1;
        
        myOn(myOn == 0) = [];
        myOff(myOff == 0) = [];
        
        [on, off, events] = GLR_EventDetection(aggregatePower,20,15,10,-20,1,0,4);
        trainingWindow = 10;
        
        % This section refreshes the event detection properly, ignoring
        % irrelevant points:
        if(isempty(myOn) && isempty(myOff)) 
            myOn = on;
            myOff = off;
        else
            myMaxEventIndex = max([myOn myOff]);
            on(on <= myMaxEventIndex) = [];
            off(off <= myMaxEventIndex) = [];
            
            myOn = [myOn on];
            myOff = [myOff off];
        end
        
        on = myOn;
        off = myOff;
        
        % Disaggregation
         for i = (1 + trainingWindow):(dataLength-trainingWindow)
            
                if on(i) == 1
                   eventWindow = aggregatePower(i-trainingWindow:i+trainingWindow)';
                   eventSlope = polyfit(1:length(eventWindow),eventWindow,1);
                   eventDelta = max(eventWindow) - min(eventWindow);
                   eventFeatures = prtDataSetClass([eventSlope(1) eventDelta]);
                   %eventFeatures = prtDataSetClass(eventWindow);
                 
                   knnClassOut = knnClassifierOn.run(eventFeatures);
                 
                   [~, dcsID] = max(knnClassOut.data);
                    
                   fprintf('%1.0f is the appliance ON at time %5.3f \n', dcsID, i);
                   
                   %text(i,aggregatePower(i),num2str(dcsID),'Color','red','FontSize',20,'FontSmoothing','on','Margin',8);
                end
                if off(i) == 1
                    eventWindow = aggregatePower(i-trainingWindow:i+trainingWindow)';
                    %eventFeatures = prtDataSetClass(eventWindow);
                    eventSlope = polyfit(1:length(eventWindow),eventWindow,1);
                    eventDelta = max(eventWindow) - min(eventWindow);
                    eventFeatures = prtDataSetClass([eventSlope(1) eventDelta]);
                    knnClassOut = knnClassifierOff.run(eventFeatures);
                 
                    [~, dcsID] = max(knnClassOut.data);
                    
                    fprintf('%1.0f is the appliance OFF at time %5.3f \n', dcsID, i);
                    
                    %text(i,aggregatePower(i),num2str(dcsID),'Color','green','FontSize',20,'FontSmoothing','on','Margin',8);
                end
             end
        %dcsID
        Pmax = max(max(find(on)),max(find(off)));
        % 1 second pause
        pause(1)
    end
end