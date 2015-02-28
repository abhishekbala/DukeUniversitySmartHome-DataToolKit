load('Jan14Data.mat')

dateNum = unixDateNum(shData1(:,1));
dateNum(:,2) = month(dateNum(:,1));
dateNum(:,3) = day(dateNum(:,1));
dateNum(:,4) = weekday(dateNum(:,1));
dateNum(:,5) = hour(dateNum(:,1));

startRow = find(dateNum(:,3)==7,1);
endRow = find(dateNum(:,3)==14,1);
week2(:,1) = shData1(startRow:endRow-1,2);
week2(:,2) = dateNum(startRow:endRow-1,5);

gNo = 2;
kmeansGroups = kmeans(week2(:,1),gNo);
data = [week2(:,2), kmeansGroups, week2(:,1)];

result = [];
group =zeros(length(week2),2);
daySum = zeros(gNo,24);

for g=1:gNo
    n = 0;
    for i=1:length(data(:,1))
        if data(i,2)==g
            n = n+1;
            group(n,:)= [data(i,1) data(i,3)];
        end
        % result = [result group];
    end
    group( ~any(group,2), : ) = [];
    for k = 1:24
        daySum(g,k)= sum(group(:,1) == k-1);
    end
end

% gNo = 7;
% kmeansGroups = kmeans(shData1(:,2),gNo);
% data = [dateNum(:,4), kmeansGroups, shData1(:,2)];

% result = [];
% group =zeros(length(shData1),2);
% daySum = zeros(gNo,7);
% for g=1:gNo
%     n = 0;
%     for i=1:length(data(:,1))
%         if data(i,2)==g
%             n = n+1;
%             group(n,:)= [data(i,1) data(i,3)];
%         end
%         % result = [result group];
%     end
%     for k = 1:7
%         daySum(g,k)= sum(group(:,1) == k);
%     end
% end

figure(2)
plot(daySum(1,:),'r'); hold on
plot(daySum(2,:),'b');
plot(daySum(3,:),'g');
plot(daySum(4,:),'m');
plot(daySum(5,:),'y');
plot(daySum(6,:),'c');
plot(daySum(7,:),'k');
xlabel('Day of the Week (1 = Sunday, 2 = Monday,...,7 = Saturday');
xlabel('Hour of Dat (1 = 00:00, 2 = 01:00,...,24 = 23:00');
xlim([1,24]);
ylabel('Frequency in each group');
legend('Group 1','Group 2','Group 3','Group 4','Group 5','Group 6','Group 7');