function training3Features(trainingDataSet, applianceLabel, decisionIDs, parameters)

    dataLength = length(trainingDataSet);
    
    % Event Detection
    a = parameters(1);
    b = parameters(2);
    c = parameters(3);
    d = parameters(4);
    e = parameters(5);
    f = parameters(6);
    g = parameters(7);
    [on, off, events] = GLR_EventDetection(trainingDataSet, a, b, c, d, e, f, g);

    trainingWindow = 30;
    onFilePath = cat(2, applianceLabel, 'OnFeatures.mat');
    offFilePath = cat(2, applianceLabel, 'OffFeatures.mat');
    
    % Load features if exist
    onExist = 0; offExist = 0;
    if exist(onFilePath, 'file') == 2
        onFeatures = load(onFilePath);
        onFeatureSet = onFeatures.featureSet;
        onExist = 1;
    end    
    if exist(offFilePath, 'file') == 2
        offFeatures = load(offFilePath);
        offFeatureSet = offFeatures.featureSet;
        offExist = 1;
    end
    
    % Collect Features
    for i = 1:dataLength
        if on(i) == 1
            eventWindow = trainingDataSet(i-trainingWindow:i+trainingWindow)';
            eventBefore = eventWindow(1:trainingWindow);
            eventAfter = eventWindow(trainingWindow+1:trainingWindow*2);
            eventDelta = max(eventWindow) - min(eventWindow);
            eventCenter = mean(eventBefore) + eventDelta / 2;
            eventBeforeAppend = [eventBefore eventCenter];
            eventAfterAppend = [eventCenter eventAfter];
            regressionBefore = polyfit(1:trainingWindow+1, eventBeforeAppend, 1);
            regressionAfter = polyfit(trainingWindow+1:trainingWindow*2+1, eventAfterAppend, 1);
            slopeBefore = regressionBefore(1);
            slopeAfter = regressionAfter(1);
            eventFeatures = prtDataSetClass([slopeBefore slopeAfter eventDelta],decisionIDs(1));
            if onExist == 1
                onFeatureSet = catObservations(onFeatureSet, eventFeatures);
            else 
                onFeatureSet = eventFeatures;
                onExist = 1;
            end
        end
        
        if off(i) == 1
            eventWindow = trainingDataSet(i-trainingWindow:i+trainingWindow)';
            eventBefore = eventWindow(1:trainingWindow);
            eventAfter = eventWindow(trainingWindow+1:trainingWindow*2);
            eventDelta = max(eventWindow) - min(eventWindow);
            eventCenter = mean(eventBefore) + eventDelta / 2;
            eventBeforeAppend = [eventBefore eventCenter];
            eventAfterAppend = [eventCenter eventAfter];
            regressionBefore = polyfit(1:trainingWindow+1, eventBeforeAppend, 1);
            regressionAfter = polyfit(trainingWindow+1:trainingWindow*2+1, eventAfterAppend, 1);
            slopeBefore = regressionBefore(1);
            slopeAfter = regressionAfter(1);
            eventFeatures = prtDataSetClass([slopeBefore slopeAfter eventDelta],decisionIDs(1));
            if offExist == 1
                offFeatureSet = catObservations(offFeatureSet, eventFeatures);
            else 
                offFeatureSet = eventFeatures;
                offExist = 1;
            end
        end
    end
    
    % Resave features
    save(onFilePath, 'onFeatureSet');
    save(offFilePath, 'offFeatureSet');

end