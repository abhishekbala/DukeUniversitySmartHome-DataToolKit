totalPower = minMeanPower(:,1);
hvacPower1 = minMeanPower(:,2);
hvacPower2 = minMeanPower(:,3);


for gNum = 2:12
    kgroup = kmeans(totalPower,gNum);
    groupedData = [kgroup, minMeanDateNum(:,2:4), totalPower];

    hourSummary = zeros(gNum,24);
    weekdaySummary = zeros(gNum,7);
    daySummary = zeros(gNum,31);
    
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
    end
    
    figure(1)
    set(gcf,'position',[22 5 1400 800])
    
    subplot(3,1,2)
    plot(weekdaySummary)
    xlabel('Day of Week (1 = Sunday,...,7 = Saturday)');
    xlim([1,7]);
    ylabel('Frequency');
    switch gNum
        case 2
            legend('Group 1','Group 2','Location','EastOutside');
        case 3
            legend('Group 1','Group 2','Group 3','Location','EastOutside');
        case 4
            legend('Group 1','Group 2','Group 3','Group 4','Location','EastOutside');
        case 5
            legend('Group 1','Group 2','Group 3','Group 4','Group 5','Location','EastOutside');
        case 6
            legend('Group 1','Group 2','Group 3','Group 4','Group 5','Group 6','Location','EastOutside');
        case 7
            legend('Group 1','Group 2','Group 3','Group 4','Group 5','Group 6','Group 7','Location','EastOutside');
        case 8
            legend('Group 1','Group 2','Group 3','Group 4','Group 5','Group 6','Group 7','Group 8','Location','EastOutside');
        case 9
            legend('Group 1','Group 2','Group 3','Group 4','Group 5','Group 6','Group 7','Group 8','Group 9','Location','EastOutside');
        case 10
            legend('Group 1','Group 2','Group 3','Group 4','Group 5','Group 6','Group 7','Group 8','Group 9','Group 10','Location','EastOutside');
        case 11
            legend('Group 1','Group 2','Group 3','Group 4','Group 5','Group 6','Group 7','Group 8','Group 9','Group 10','Group 11','Location','EastOutside');
        case 12
            legend('Group 1','Group 2','Group 3','Group 4','Group 5','Group 6','Group 7','Group 8','Group 9','Group 10','Group 11','Group 12','Location','EastOutside');
    end
    p2 = get(gca,'position');
    
    
    
    subplot(3,1,1)
    plot(hourSummary);
    xlabel('Hour of Day (1 = 00:00,...,24 = 23:00)');
    xlim([1,24]);
    ylabel('Frequency');
    title('Mean Power Data at Minute Level from January (Whole Month)','FontSize',16);
    p1 = get(gca, 'position');
    p1(1,3)=p2(1,3);
    set(gca,'position',p1)
    
    
    
    subplot(3,1,3)
    plot(daySummary)
    xlabel('Day of Month (1 = Sunday,...,7 = Saturday)');
    xlim([1,31]);
    ylabel('Frequency');
    p3 = get(gca,'position');
    p3(1,3)=p2(1,3);
    set(gca,'position',p3)
    
    filename = sprintf('%d%s',gNum, 'Groups1Month');
    saveas(gcf,filename,'jpg')
    saveas(gcf,filename,'fig')
end

        
