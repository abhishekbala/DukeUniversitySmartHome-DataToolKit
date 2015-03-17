function trainingDisaggregation(trainingDataSet, applianceLabel)

    dataLength = length(trainingDataSet);
    
    % Event Detection
    [on, off, events] = GLR_EventDetection(trainingDataSet,40,30,25,-10,3,0,6);

    trainingWindow = 10;
%     onFilePath = cat(2, applianceLabel, 'OnFeatures.mat');
%     offFilePath = cat(2, applianceLabel, 'OffFeatures.mat');
    onFilePath = cat(2, applianceLabel, 'OnFeatures');
    offFilePath = cat(2, applianceLabel, 'OffFeatures');
    
    % Load features if exist
    if exist(onFilePath, 'file')
        onFeatures = load(onFilePath);
        onFeatureSet = onFeatures.featureSet;
    else
        onFeatureSet = prtDataSetClass();
    end
    
    if exist(offFilePath, 'file')
        offFeatures = load(offFilePath);
        offFeatureSet = offFeatures.featureSet;
    else
        offFeatureSet = prtDataSetClass();
    end
    
    % Collect Features
    for i = 1:dataLength
        if on(i) == 1
            eventWindow = trainingDataSet(i-trainingWindow:i+trainingWindow);
            eventFeatures = prtDataSetClass(eventWindow);
            onFeatureSet = catObservations(onFeatureSet, eventFeatures);
        end
        if off(i) == 1
            eventWindow = trainingDataSet(i-trainingWindow:i+trainingWindow);
            eventFeatures = prtDataSetClass(eventWindow);
            offFeatureSet = catObservations(offFeatureSet, eventFeatures);
        end
    end
    
    
    % Added by Aus
    eval(sprintf('%s = onFeatureSet', onFilePath));
    eval(sprintf('%s = offFeatureSet', offFilePath));
    
    % Resave features
    save('featureSet', onFilePath, offFilePath);
    %save('featureSet', offFilePath);
    
end