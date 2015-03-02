clear;

windowLength = 200;
bufferLength = 29;

timeWindow = 1:windowLength;
bufferStartIndex = 1;
bufferEndIndex = 1;

measurement = zeros(1,windowLength);
measurement(31:60) = 25;
measurement(61:75) = 75;
measurement(76:110) = 100;
measurement(111:150) = 75;
noisyMeasurement = awgn(measurement, 23, 'measured');

figure(1);
clf;
h(1) = subplot(2, 1, 1);
plot(timeWindow, noisyMeasurement, 'k', 'linewidth', 3); hold on;

while bufferEndIndex < windowLength
    if bufferEndIndex - bufferStartIndex >= 15
        bufferRange = bufferStartIndex:bufferEndIndex;
        bufferMeasurement = noisyMeasurement(bufferRange);
        bufferMean = mean(bufferMeasurement);
        bufferStd = std(bufferMeasurement);
        
        nextPoint = noisyMeasurement(bufferEndIndex+1);
        z_score = abs((nextPoint - bufferMean) / bufferStd);
        if ( z_score > 3)
            bufferStartIndex = bufferEndIndex + 1;
            bufferEndIndex = bufferEndIndex + 1
            z_score = z_score
            % EVENT DETECTED!
            plot(bufferStartIndex, noisyMeasurement(bufferStartIndex), 'ro', 'linewidth', 4);
        else 
            bufferEndIndex = bufferEndIndex + 1;
        end
    else 
        bufferEndIndex = bufferEndIndex + 1;
    end
end