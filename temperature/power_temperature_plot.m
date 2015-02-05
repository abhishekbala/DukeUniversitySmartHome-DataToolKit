%% Initialize Data:
clear; clc;
load('powerData.mat', 'powerData');
powerData = flip(powerData);
loadtempdata
temp = timeseries(DeviceSensorinFahrenheit1,TimestampRecord1);

%% Global Variables
timevec = powerData(:,1);
totalData = powerData(:,2);
sampleDataSet = [totalData];
sampleTime = timevec;
timetemp = [0:46]';
            figure(1)
            axis([1.420603341000000e+09 1.420689743000000e+09 0 12000]);
            startTime = datestr(timevec(1,1)/86400+719529,15);
            endTime = datestr(timevec(86400,1)/86400+719529,15);
            plot(timevec, totalData);
            set(gca, 'FontSize',12,'XTick',[0,86400],'XTickLabel',{startTime,endTime});
            
            xlabel(datestr(timevec(86400,1)/86400+719529,1),'FontSize',14);
            ylabel('Power (W)','FontSize',14);
            
            figure(2)
            plot(temp);
            
            figure(3)
            for i = 1:100000
            TSdate{i,1} = datestr(timevec(i,1)./86400+719529,'mm/dd/yyyy HH:MM:SS');
            end
            powerDataTS = timeseries(totalData,TSdate);
            plot(powerDataTS);