function MinuteAverageFromSecondData(secondData)
%   Input: Read from with second event data for one appliance
%   Output: - Write to CSV with minute averaged data for each appliance

iMinute = 1;
for iSecond=1:length(secondData)
    time = secondData(iSecond,1);
    if(mod(secondData(iSecond,1), 60) == 0 && iSecond > 60)
        minutes(iMinute,1) = time / 60;
        minutes(iMinute,2) = mean(secondData(iSecond-59:iSecond,2));
        iMinute = iMinute + 1;
        minuteTime = time;
    end
end

dlmwrite('dataminutes.csv',minutes);