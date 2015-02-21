load('1dayplusdata.mat');
%time = datestr(unixDateNum(untitled(:,1)));
time = unixDateNum(untitled(:,1));
timestr = datestr(time);
gridPower = sum(untitled(:,2:3),2);
powerData = timeseries(gridPower, time);
powerDatastr = timeseries(gridPower, timestr);

tData = importcsv('tempdata.csv');
tTime = datenum(tData(:,end));
temptTime = linspace(tTime(end),tTime(1));
tTimestr = datestr(tTime);
tData = cell2mat(tData(:,5));
% for i = 1:length(temptTime)
%     if temptTime(i,1) == tTime(i);
%         tempData(i,2) = tData(i);
%     end
% end
tSeries = timeseries(tData, tTime);
tSeriesStr = timeseries(tData, tTimestr);

%mergedData = merge(gridPower,temp);

f2=figure(2);
cla
h2=plot(powerData,'Color','red');
ax1 = gca;
set(ax1,'XColor','r','YColor','r')
hold on
ax2 = axes('position',get(ax1,'position'));
plot(tSeries)
set(ax2, 'YAxisLocation','right', 'Color','none','xlim', get(ax1, 'xlim'));
set(f2,'CurrentAxes',ax2);

f3=figure(3);
cla
h3=plot(powerDatastr,'Color','red');
ax3 = gca;
set(ax3,'XColor','r','YColor','r')
hold on
ax4 = axes('position',get(ax3,'position'));
plot(tSeriesStr)
set(ax4, 'YAxisLocation','right', 'Color','none','xlim', get(ax3, 'xlim'));
set(f3,'CurrentAxes',ax4);
xlabel(ax4,'Date and Time');
ylabel(ax3,'Power');
ylabel(ax4,'Temperature F');
title(ax3,'Plot of Temperature (F) and Power (W)');
title(ax4,'Plot of Temperature (F) and Power (W)');