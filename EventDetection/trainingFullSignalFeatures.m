function trainingDisaggregation(trainingDataSet, applianceLabel, decisionIDs)

    dataLength = length(trainingDataSet);
    
    % Event Detection
    [on, off, events] = GLR_EventDetection(trainingDataSet,40,30,25,-10,3,0,6);

    trainingWindow = 10;
    onFilePath = cat(2, applianceLabel, 'OnFeatures');
    offFilePath = cat(2, applianceLabel, 'OffFeatures');
    
    % Load features if exist
    onExist = 0; offExist = 0;
    if exist(onFilePath, 'file')
        onFeatures = load(onFilePath);
        onFeatureSet = onFeatures.featureSet;
        onExist = 1;
    end    
    if exist(offFilePath, 'file')
        offFeatures = load(offFilePath);
        offFeatureSet = offFeatures.featureSet;
        offExist = 1;
    end
    
    % Collect Features
    for i = 1:dataLength
        if on(i) == 1
            eventWindow = trainingDataSet(i-trainingWindow:i+trainingWindow)';
            if onExist == 1
                onFeatureSet = catObservations(onFeatureSet, eventWindow);
            else 
                onFeatureSet = prtDataSetClass(eventWindow, decisionIDs(1));
            end
        end
        if off(i) == 1
            eventWindow = trainingDataSet(i-trainingWindow:i+trainingWindow)';
            if offExist == 1        
                offFeatureSet = catObservations(offFeatureSet, eventWindow);
            else
                offFeatureSet = prtDataSetClass(eventWindow, decisionIDs(2));
            end
        end
    end
    
    % Resave features
    save(onFilePath, 'onFeatureSet');
    save(offFilePath, 'offFeatureSet');

end