clear
%The data format preferences.
setdbprefs('DataReturnFormat', 'numeric');
setdbprefs('NullNumberRead', 'NaN');
setdbprefs('NullStringRead', 'null');
setdbprefs('FetchInBatches', 'yes');
setdbprefs('FetchBatchSize', '10000');

conn = database('shenergydata', 'student', 'bassconnex', ...
    'Vendor', 'MySQL', 'Server', '67.159.81.86', 'AuthType', 'Server',...
    'portnumber', 3306);
ping(conn)

%mySQLquery = ['SELECT 	timestamp'...
%    ' ,	b7139_01_r_01_phase1'...
%    ' FROM 	smarthome'];

% Timestamp from 1409544960 used to start from GMT-5hr (EST) Unix time for
% 09/01/2014 00:00 hrs with a 16 minute offset (as the data is offset by 16
% minutes).
mySQLquery = ['SELECT 	smarthome.timestamp'...
    ' ,	smarthome.b7139_01_r_01_phase1'...
    ' , smarthome.b7139_01_r_02_phase2'...
    ' , smarthome.b7139_01_r_03_solar1'...
    ' , smarthome.b7139_01_r_04_solar2'...
    ' , smarthome.b7139_05_r_01_ahu1'...
    ' , smarthome.b7139_05_r_03_ahu2'...
    ' , smarthome.b7139_05_r_05_cu1'...
    ' , smarthome.b7139_05_r_07_cu2'...
    ' FROM 	energydata.smarthome '...
    ' WHERE 	smarthome.timestamp >= 1420070400'... 
    ' ORDER BY 	smarthome.timestamp ASC'];

curs = exec(conn,mySQLquery);
% If 31 days
% curs = fetch(curs,2678400);
% If 30 days
curs = fetch(curs,2592000);
% For 7 days
shData = curs.Data;

close(curs);
shData1(:,1) = sum(shData(:,1),2);
shData1(:,2) = sum(shData(:,2:3),2) - sum(shData(:,4:5),2);
shData1(:,3) = shData(:,2);
shData1(:,4) = shData(:,3);
shData1(:,5) = shData(:,4);
shData1(:,6) = shData(:,5);
sum(sum(shData(:,2:4),2)>shData1(:,2))
shData2(:,1) = sum(shData(:,1),2);
shData2(:,2) = sum(shData(:,2:3),2) - sum(shData(:,4:5),2) - sum(shData(:,6:9),2);
sum(sum(shData1(:,2),2)>shData2(:,2))
sum(shData2(:,2)>=0)
%for i = 1:31
%    shDataPlot1(i,:) = shData1(1:86400,2);
%    shData1(1:86400,:) = [];
%end

% For 31 days
% for i = 1:744
%     shDataHourly1(i,1) = shData1(3600,1);
%     shDataHourly1(i,2) = mean(shData1(1:3600,2));
%     shData1(1:3600,:) = [];
% end
% clear shData1
% for i = 1:744
%     shDataHourly2(i,1) = shData2(3600,1);
%     shDataHourly2(i,2) = mean(shData2(1:3600,2));
%     shData2(1:3600,:) = [];
% end
% clear shData2
% for i = 1:31
%     shDataPlot1(i,:) = shDataHourly1(1:24,2);
%     shDataHourly1(1:24,:) = [];
% end
% for i = 1:31
%     shDataPlot2(i,:) = shDataHourly2(1:24,2);
%     shDataHourly2(1:24,:) = [];
% end

% For 30 days
for i = 1:720
    shDataHourly1(i,1) = shData1(3600,1);
    shDataHourly1(i,2) = mean(shData1(1:3600,2));
    shData1(1:3600,:) = [];
end
clear shData1
for i = 1:720
    shDataHourly2(i,1) = shData2(3600,1);
    shDataHourly2(i,2) = mean(shData2(1:3600,2));
    shData2(1:3600,:) = [];
end
clear shData2
for i = 1:30
    shDataPlot1(i,:) = shDataHourly1(1:24,2);
    shDataHourly1(1:24,:) = [];
end
for i = 1:30
    shDataPlot2(i,:) = shDataHourly2(1:24,2);
    shDataHourly2(1:24,:) = [];
end

clear shDataHourly1
clear shDataHourly2
clear shDataHourly
clear i
monthProfile(shDataPlot1)
%monthProfile(shDataPlot2)
clear conn curs
clear ans

figure;
averageDayProfile = mean(shDataPlot1);
% For 30 days
averageMonth = meshgrid(averageDayProfile, 1:30);
res = shDataPlot1-averageMonth;
res1 = [];
for i = 1:30
    v = length(res1);
    res1(v+1:v+24,1) = res(i,:);
end
hist = histfit(res1);
xlabel('Data');
ylabel('Density')
title('Fit of residuals to Normal Distribution');

figure;
plot(shDataPlot1', 'Color', [.5 .5 .5]);
line(1:24, averageDayProfile, 'Linewidth', 2, 'Color', 'r');
grid on; 
xlim([1 24]);
xlabel('hours');
ylabel('system load (W)');
title('Daily Profile (with mean)');
  
% Mean, Standard Deviation, and Confidence Intervals
[meanD,stdevD,ciD] = normfit(shDataPlot1 );    % across days
[meanH,stdevH,ciH] = normfit(shDataPlot1');    % across hours
plotCI(shDataPlot1,meanD,stdevD,ciD,meanH,stdevH,ciH);