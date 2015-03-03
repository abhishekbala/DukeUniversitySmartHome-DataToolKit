function liveDisaggregation()

    matFiles = prtUtilSubDir('','*.mat');
    fullSet = prtDataSetClass();
    for iFile = 1:length(matFiles)
        cFile = matFiles{iFile};
        load(cFile);
        fullSet = catObservations(fullSet, featureSet);
    end
    
    while 1
        liveData = csvread('../dataCollectors/shData.csv');
        endRow = length(liveData(:,1));

        % Original data
        %figure(1);
        %plot(times, aggregatePower);

        % Keep window (for plotting) at 300seconds (can be changed to any value
        % upto 1800).
        window = 300;
%        times = liveData(endRow-window:endRow,1);
        aggregatePower = sum(liveData(endRow-window:endRow,2:3),2);

        % Plot
        refresh
%        figure(1);
%        plot(times,aggregatePower);

        % Event Detection
        [on, off, events] = GLR_EventDetection(aggregatePower,40,30,25,-10,3,0,6);
        
        % Disaggregation
        for i = 1:window
            if on(i) == 1
                eventWindow = aggregatePower(i-trainingWindow:i+trainingWindow);
                eventFeatures = prtDataSetClass(eventWindow);
                
                knnClassifier = prtClassKnn;
                knnClassifier.k = 8;
                knnClassifier = knnClassifier.train(fullSet);
                knnClassOut = knnClassifier.run(eventFeatures);
                
                [~, dcsID] = max(knnClassOut.data);
            end
            if off(i) == 1
                eventWindow = aggregatePower(i-trainingWindow:i+trainingWindow);
                eventFeatures = prtDataSetClass(eventWindow);
                
                knnClassifier = prtClassKnn;
                knnClassifier.k = 8;
                knnClassifier = knnClassifier.train(fullSet);
                knnClassOut = knnClassifier.run(eventFeatures);
                
                [~, dcsID] = max(knnClassOut.data);
            end
        end

        % 1 second pause
        pause(1)
    end
end