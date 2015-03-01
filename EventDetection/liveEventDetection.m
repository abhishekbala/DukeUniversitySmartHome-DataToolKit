function liveEventDetection()
    liveData = csvread('../dataCollectors/shData.csv');
    times = liveData(:,1);
    aggregatePower = sum(liveData(:,2:3),2);
    
    % Original data
    figure(1);
    plot(times,aggregatePower);
    
    % Event Detection
    
end