clear;

windowLength = 200;
bufferLength = 29;

timeWindow = 1:windowLength;
bufferStartIndex = 1;
bufferEndIndex = 1;

measurement = zeros(1,windowLength);
measurement(31:75) = 25;
measurement(76:110) = 100;
measurement(111:150) = 75;
noisyMeasurement = awgn(measurement, 50, 'measured');

h(1) = subplot(2, 1, 1);
plot(timeWindow, noisyMeasurement, 'k', 'linewidth', 3);

while bufferEndIndex < windowLength
    if bufferEndIndex - bufferStartIndex >= 30
        bufferRange = bufferStartIndex:bufferEndIndex;
        bufferMeasurement = noisyMeasurement(bufferRange);
        bufferMean = mean(bufferMeasurement);
        bufferStd = std(bufferMeasurement);
        
        nextPoint = noisyMeasurement(bufferEndIndex+1);
        z_score = abs((nextPoint - bufferMean) / bufferStd);
        if ( z_score > 2)
            bufferStartIndex = bufferEndIndex + 1;
            bufferEndIndex = bufferEndIndex + 1
            
            % EVENT DETECTED!
        else 
            bufferEndIndex = bufferEndIndex + 1;
        end
    else 
        bufferEndIndex = bufferEndIndex + 1;
    end
end