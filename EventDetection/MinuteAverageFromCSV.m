%   Input: Read from CSV with second event data for each appliance
%   Output: - Write to CSV with minute averaged data for each appliance

pathToStartRow = 'csvEndRow';
if exist(pathToStartRow, 'file') == 2
    csvStartRow = load('csvEndRow');
else
    csvStartRow = 1;
end

pathToInputData = 'minuteData.csv';
secondData = csvread(pathToInputData, csvStartRow, 1);
sizeOfData = size(secondData);
lengthOfData = length(sizeOfData);

iMinute = 1;
for iSecond=1:lengthOfData
    time = secondData(iSecond,1);
    if(mod(secondData(iSecond,1), 60) == 0 && iSecond > 60)
        minutes(iMinute,1) = time / 60;
        minutes(iMinute,2) = mean(secondData(iSecond-59:iSecond,2));
        minutes(iMinute,3) = mean(secondData(iSecond-59,iSecond,3));
        minutes(iMinute,4) = mean(secondData(iSecond-59,iSecond,4));
        iMinute = iMinute + 1;
    end
end

csvEndRow = csvStartRow + lengthOfData;
save('csvEndRow');
dlmwrite('minuteData.csv',minutes,'-append');