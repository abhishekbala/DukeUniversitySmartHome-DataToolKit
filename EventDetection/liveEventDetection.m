function liveEventDetection()
    while 1
    liveData = csvread('../dataCollectors/shData.csv');
    endRow = length(liveData(:,1));
    
    % Keep window (for plotting) at 300seconds (can be changed to any value
    % upto 1800).
    window = 1800;
    times = liveData(endRow-window:endRow,1);
    aggregatePower = sum(liveData(endRow-window:endRow,2:3),2);
    
    % Original data
    %refresh
    %figure(1);
    %plot(times, aggregatePower);
    
    % Event Detection
    %FastGLR_forEventDetectionMetrics(aggregatePower,40,30,1,3,0,4);
    GLR_EventDetection(aggregatePower);
    
    % 1 second pause
    pause(1)
    end
end