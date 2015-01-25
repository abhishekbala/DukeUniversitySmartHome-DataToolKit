clear;

windowLength = 101;
bufferLength = 10;

timeWindow = 1:windowLength;

midPoint = (windowLength + 1)/2;
bufferRange = midPoint - bufferLength : midPoint + bufferLength;

signal(1:midPoint - 1) = -1;
signal(midPoint + 1:windowLength) = 1;
signal(bufferRange) = 0;

measurement = zeros(1,101);
measurement(10:20) = 5;
measurement(21:29) = 0;
measurement(30:45) = 20;
measurement(46:56) = 30;
measurement(57:70) = 10;
measurement(71:101) = 0;

filteredSignal = signal .* measurement;

figure(1);
h(1) = subplot(3, 1, 1);
plot(timeWindow, filteredSignal,'b','linewidth',2) ;
h(2) = subplot(3, 1, 2);
plot(timeWindow, signal, 'g', 'linewidth', 2);
h(3) = subplot(3, 1, 3);
plot(timeWindow, measurement, 'k', 'linewidth', 3);
for i = 1:windowLength
    measurement = circshift(measurement, [0 1]);
    signal(1) = 0;
    filteredSignal = signal .* measurement;    
    set(h(1),'YData',filteredSignal);
    set(h(2),'YData',signal);
    set(h(3),'YData',measurement);
    refreshdata
    drawnow
end