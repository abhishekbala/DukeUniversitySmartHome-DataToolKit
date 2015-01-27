
clear;

dataset = load('smartHomeData.mat');
smartHomeData = dataset.smartHomeData;
phaseAData = smartHomeData(:,2);

startInterval = 200;
smartHomeLength = length(phaseAData);
ds.data = phaseAData(1:startInterval);
index = startInterval+1;
timeWindow = 1:startInterval;

ds.windowLength = 51;
ds.bufferLength = 6;
ds.threshold = 0.25;
ds.smoothFactor = 0.5;

ds.onEvents = nan(startInterval,1);
ds.offEvents = nan(startInterval,1);

h(1) = plot(timeWindow,ds.data,'k','linewidth',2) ; hold on ;
h(2) = plot(timeWindow,ds.onEvents, 'ob', 'linewidth',4);
h(3) = plot(timeWindow,ds.offEvents, 'or', 'linewidth',4);
xlabel('Time')
ylabel('Magnitude')
set(gca, 'xdir', 'reverse');

while 1
    ds.data = circshift(ds.data,[1,0]);
    if index > smartHomeLength
        break;
    else
        ds.data(1) = phaseAData(index);
        index = index + 1;
    end
    
    ds.onEvents = nan(startInterval,1);
    ds.offEvents = nan(startInterval,1);    
    detectedEvents = detectEvents(ds);
    detectedOnEvents = detectedEvents.onEvents;
    detectedOffEvents = detectedEvents.offEvents;
    detectedOnIndex = detectedEvents.onEventsIndex;
    detectedOffIndex = detectedEvents.offEventsIndex;
    ds.onEvents(detectedOnIndex) = detectedOnEvents;
    ds.offEvents(detectedOffIndex) = detectedOffEvents;
    set(h(1),'YData',ds.data);
    set(h(2),'YData',ds.onEvents);
    set(h(3),'YData',ds.offEvents);
    
    refreshdata
    drawnow
    
end