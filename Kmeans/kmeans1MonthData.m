% clear
% load('Aug14_ProcessedData.mat') %% edit


% totalPower = minMeanPower(:,1);
% hvacPower1 = minMeanPower(:,2);
% hvacPower2 = minMeanPower(:,3);
% totalPower = completePowerData(:,1);
% timeIndex = completedateNum(:,3:5);

% appData = minMeanPower(:,6); %% edit
% timeIndex = minMeanDateNum(:,2:4);

appData = powerData(:,2)+powerData(:,3);
timeIndex = dateNum(:,3:6);

for gNum = 3:10

    kgroup = kmeans(appData,gNum);
    groupedData = [kgroup timeIndex appData];

    hourSummary = zeros(24,gNum);
    weekdaySummary = zeros(7,gNum);
    daySummary = zeros(31,gNum);
    minuteSummary = zeros(60,gNum);
    
    for k = 1:gNum
        for h = 0:23
            hourSummary(h+1,k)=length(find(groupedData(:,1)==k & groupedData(:,4)==h));
        end
        for wd = 1:7
            weekdaySummary(wd,k)=length(find(groupedData(:,1)==k & groupedData(:,3)==wd));
        end
        for d = 1:31
            daySummary(d,k)=length(find(groupedData(:,1)==k & groupedData(:,2)==d));
        end
        for m = 0:59
            minuteSummary(m+1,k)=length(find(groupedData(:,1)==k & groupedData(:,5)==m));
        end
    end
    
    figure(1)
    set(gcf,'position',[22 5 1400 800])
    
    subplot(4,1,2)
    plot(weekdaySummary,':o','MarkerSize',6)
    xlabel('Day of Week (1 = Sunday,...,7 = Saturday)');
    xlim([1,7]);
    ylabel('Frequency');
    switch gNum
        case 2
            legend('Group 1','Group 2','Location','EastOutside');
            for i = 1:gNum
                min_Power(i,:) = min(groupedData(find(groupedData(:,1)==i),5));
                max_Power(i,:) = max(groupedData(find(groupedData(:,1)==i),5));
                Freq(i,:) = sum(groupedData(:,1)==i);
            end
            g2 = table(min_Power, max_Power, Freq, 'RowNames', {'Group 1', 'Group 2'});

        case 3
            legend('Group 1','Group 2','Group 3','Location','EastOutside');
            for i = 1:gNum
                min_Power(i,:) = min(groupedData(find(groupedData(:,1)==i),5));
                max_Power(i,:) = max(groupedData(find(groupedData(:,1)==i),5));
                Freq(i,:) = sum(groupedData(:,1)==i);
            end
            g3 = table(min_Power, max_Power, Freq, 'RowNames', {'Group 1', 'Group 2', 'Group 3'});

        case 4
            legend('Group 1','Group 2','Group 3','Group 4','Location','EastOutside');
            for i = 1:gNum
                min_Power(i,:) = min(groupedData(find(groupedData(:,1)==i),5));
                max_Power(i,:) = max(groupedData(find(groupedData(:,1)==i),5));
                Freq(i,:) = sum(groupedData(:,1)==i);
            end
            g4 = table(min_Power, max_Power, Freq, 'RowNames', {'Group 1', 'Group 2','Group 3','Group 4'});
            
        case 5
            legend('Group 1','Group 2','Group 3','Group 4','Group 5','Location','EastOutside');
            for i = 1:gNum
                min_Power(i,:) = min(groupedData(find(groupedData(:,1)==i),5));
                max_Power(i,:) = max(groupedData(find(groupedData(:,1)==i),5));
                Freq(i,:) = sum(groupedData(:,1)==i);
            end
            g5 = table(min_Power, max_Power, Freq, 'RowNames', {'Group 1', 'Group 2','Group 3','Group 4','Group 5'});
            
        case 6
            legend('Group 1','Group 2','Group 3','Group 4','Group 5','Group 6','Location','EastOutside');
            for i = 1:gNum
                min_Power(i,:) = min(groupedData(find(groupedData(:,1)==i),5));
                max_Power(i,:) = max(groupedData(find(groupedData(:,1)==i),5));
                Freq(i,:) = sum(groupedData(:,1)==i);
            end
            g6 = table(min_Power, max_Power, Freq, 'RowNames', {'Group 1', 'Group 2','Group 3','Group 4','Group 5','Group 6'});

        case 7
            legend('Group 1','Group 2','Group 3','Group 4','Group 5','Group 6','Group 7','Location','EastOutside');
            for i = 1:gNum
                min_Power(i,:) = min(groupedData(find(groupedData(:,1)==i),5));
                max_Power(i,:) = max(groupedData(find(groupedData(:,1)==i),5));
                Freq(i,:) = sum(groupedData(:,1)==i);
            end
            g7 = table(min_Power, max_Power, Freq, 'RowNames', {'Group 1', 'Group 2','Group 3','Group 4','Group 5','Group 6','Group 7'});

        case 8
            legend('Group 1','Group 2','Group 3','Group 4','Group 5','Group 6','Group 7','Group 8','Location','EastOutside');
            for i = 1:gNum
                min_Power(i,:) = min(groupedData(find(groupedData(:,1)==i),5));
                max_Power(i,:) = max(groupedData(find(groupedData(:,1)==i),5));
                Freq(i,:) = sum(groupedData(:,1)==i);
            end
            g8 = table(min_Power, max_Power, Freq, 'RowNames', {'Group 1', 'Group 2','Group 3','Group 4','Group 5','Group 6','Group 7','Group 8'});

        case 9
            legend('Group 1','Group 2','Group 3','Group 4','Group 5','Group 6','Group 7','Group 8','Group 9','Location','EastOutside');
            for i = 1:gNum
                min_Power(i,:) = min(groupedData(find(groupedData(:,1)==i),5));
                max_Power(i,:) = max(groupedData(find(groupedData(:,1)==i),5));
                Freq(i,:) = sum(groupedData(:,1)==i);
            end
            g9 = table(min_Power, max_Power, Freq, 'RowNames', {'Group 1', 'Group 2','Group 3','Group 4','Group 5','Group 6','Group 7','Group 8','Group 9'});

        case 10
            legend('Group 1','Group 2','Group 3','Group 4','Group 5','Group 6','Group 7','Group 8','Group 9','Group 10','Location','EastOutside');
            for i = 1:gNum
                min_Power(i,:) = min(groupedData(find(groupedData(:,1)==i),5));
                max_Power(i,:) = max(groupedData(find(groupedData(:,1)==i),5));
                Freq(i,:) = sum(groupedData(:,1)==i);
            end
            g10 = table(min_Power, max_Power, Freq, 'RowNames', {'Group 1', 'Group 2','Group 3','Group 4','Group 5','Group 6','Group 7','Group 8','Group 9','Group 10'});

        case 11
            legend('Group 1','Group 2','Group 3','Group 4','Group 5','Group 6','Group 7','Group 8','Group 9','Group 10','Group 11','Location','EastOutside');
        case 12
            legend('Group 1','Group 2','Group 3','Group 4','Group 5','Group 6','Group 7','Group 8','Group 9','Group 10','Group 11','Group 12','Location','EastOutside');
    end
    p2 = get(gca,'position');
    
    
    
    subplot(4,1,1)
    plot(hourSummary,':o','MarkerSize',6);
    xlabel('Hour of Day (1 = 00:00,...,24 = 23:00)');
    xlim([1,24]);
    ylabel('Frequency');
%     title('H10P Mean Power Data at Minute Level from January 2015 (Whole Month)',...
%         'FontSize',16); %% edit
    title('Power Data at Second Level from January (Whole Month)','FontSize',16);
    p1 = get(gca, 'position');
    p1(1,3)=p2(1,3);
    set(gca,'position',p1)
    
    
    
    subplot(4,1,3)
    plot(daySummary,':o','MarkerSize',6)
    xlabel('Day of Month (1 = Sunday,...,7 = Saturday)');
    xlim([1,31]);
    ylabel('Frequency');
    p3 = get(gca,'position');
    p3(1,3)=p2(1,3);
    set(gca,'position',p3)
    
    subplot(4,1,4)
    plot(minuteSummary,':o','MarkerSize',6);
    xlabel('Minutes');
    xlim([0,59]);
    ylabel('Frequency');
    p3 = get(gca,'position');
    p3(1,3)=p2(1,3);
    set(gca,'position',p3)
    
    filename = sprintf('%d%s',gNum, 'Groups1Month');
    saveas(gcf,filename,'jpg')
    saveas(gcf,filename,'fig')
    
    
%     figure(2)
%     plot(groupedData(:,1),groupedData(:,end),'.')
%     xlabel('K-means Group #');
%     ylabel('Power (W)');
%     set(gca,'XLim',[2 gNum])
%     set(gca,'XTick',[2:1:gNum])
% %     set(gca,'XTickLabel',['0';' ';'1';' ';'2';' ';'3';' ';'4'])
%     
%     filename = sprintf('%d%s',gNum, 'GroupsPowerRange');
%     saveas(gcf,filename,'jpg')
%     saveas(gcf,filename,'fig')

end

        
