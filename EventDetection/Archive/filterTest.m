clear;

windowLength = 101;
bufferLength = 10;

timeWindow = 1:windowLength;

midPoint = (windowLength + 1)/2;
bufferRange = midPoint - bufferLength : midPoint + bufferLength;

signal(1:midPoint - 1) = -1;
signal(midPoint + 1:windowLength) = 1;
signal(midPoint + 1 + bufferLength:windowLength) = 1./([midPoint + bufferLength + 1:windowLength] - midPoint - bufferLength)
signal(bufferRange) = 0;

measurement = zeros(1,101);
measurement(10:20) = 5;
measurement(21:29) = 0;
measurement(30:45) = 20;
measurement(46:80) = 30 + 20 * exp(-([46:80] - 46)/5);
measurement(80:90) = 20;
measurement(91:101) = 0;

filteredSignal = signal .* measurement;

figure(1);
subplot(3, 1, 1);
h(1) = plot(timeWindow, filteredSignal,'b','linewidth',2) ;
title('Filtered Signal');
subplot(3, 1, 2);
set(gca, 'xdir', 'reverse');
h(2) = plot(timeWindow, signal, 'g', 'linewidth', 2);
subplot(3, 1, 3);
title('Filter');
h(3) = plot(timeWindow, measurement, 'k', 'linewidth', 3);
title('Input Data');
set(gca, 'xdir', 'reverse');


for i = 1:windowLength
    measurement = circshift(measurement, [0 1]);
    measurement(1) = 0;
    filteredSignal = signal .* measurement;    
    
    set(h(1),'YData',filteredSignal);
    set(h(2),'YData',signal);
    set(h(3),'YData',measurement);
    refreshdata
    drawnow
end