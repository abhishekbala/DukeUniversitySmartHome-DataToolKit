importwuTempData
Temps = cell2mat(wuTempArchive1(:,2));
Dates = char(wuTempArchive1(:,14));

len = 19
Dates2(:,1:19) = Dates(:,1:len)

timestr = datestr(Dates2)

tempData = timeseries(Temps, timestr);

plot(tempData)
