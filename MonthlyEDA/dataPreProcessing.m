load('Jan14Data.mat')

powerData(:,1) = sum(shData(:,2:3),2) - sum(shData(:,4:5),2); % A+B-Solar
powerData(:,2) = shData(:,6); % Air Handler 1
powerData(:,3) = shData(:,7); % Air Handler 2

dateNum = unixDateNum(shData(:,1));
dateNum(:,2) = month(dateNum(:,1));
dateNum(:,3) = day(dateNum(:,1));
dateNum(:,4) = weekday(dateNum(:,1));
dateNum(:,5) = hour(dateNum(:,1));
dateNum(:,6) = minute(dateNum(:,1));
dateNum(:,7) = second(dateNum(:,1));

miss = zeros(55000,2);
missIndex = [];
n = 0;
for i = 1:length(dateNum(:,1))-1
    if dateNum(i+1,7)-dateNum(i,7)~=1
        if dateNum(i+1,6) == dateNum(i,6)|| dateNum(i,7)-dateNum(i+1,7)~=59
            n = n+1;
            miss(n,1) = i;
             if dateNum(i+1,7)-dateNum(i,7)>=2
                miss(n,2) = dateNum(i+1,7)-dateNum(i,7)-1;
             else
                miss(n,2) = 59-dateNum(i,7)+dateNum(i+1,7);
             end
        end
    end
end
missIndex(1:n,1:2)=miss(1:n,:);

missdateNum = zeros(n,7);
for i = 1:n
    if dateNum(missIndex(i),7) == 59
        missdateNum(i,7) = 0;
        missdateNum(i,6) = dateNum(missIndex(i),6)+1;
        
        if missdateNum(i,6) == 60
            missdateNum(i,6) = 0;
            missdateNum(i,5) = dateNum(missIndex(i),5)+1;
        else
            missdateNum(i,5) = dateNum(missIndex(i),5);
        end
        
        if  missdateNum(i,5) == 24
            missdateNum(i,5) = 0;
            missdateNum(i,4) = dateNum(missIndex(i),4)+1;
        else
            missdateNum(i,4) = dateNum(missIndex(i),4);
        end
        
        if  missdateNum(i,4) == 8
            missdateNum(i,4) = 1;
            missdateNum(i,3) = dateNum(missIndex(i),3)+1;
        else
            missdateNum(i,3) = dateNum(missIndex(i),3);
        end
        
        if  missdateNum(i,3) == 32
            missdateNum(i,3) = 1;
        else
            missdateNum(i,2) = 1;
        end
    else
        missdateNum(i,7) = dateNum(missIndex(i),7)+1;
        missdateNum(i,2:6) = dateNum(missIndex(i),2:6);
    end
end
completedateNum = insertrows(dateNum,missdateNum,missIndex(:,1));
missPowerData = zeros(n,3);
for i = 1:n
    missPowerData(i,:) = powerData(missIndex(i),:);
end
completePowerData = insertrows(powerData,missPowerData,missIndex(:,1));

for num = 1:59
    clear miss missIndex missdateNum missPowerData
    miss = zeros(55000,1);
    n = 0;
    for i = 1:length(completedateNum(:,1))-1
        if completedateNum(i+1,7)-completedateNum(i,7)~=1
            if completedateNum(i+1,6) == completedateNum(i,6)|| completedateNum(i,7)-completedateNum(i+1,7)~=59
                n = n+1;
                miss(n,1) = i;
            end
        end
    end
    missIndex=miss(1:n,:);
    
    missdateNum = zeros(n,7);
    missPowerData = zeros(n,3);
    for i = 1:n
        if completedateNum(missIndex(i),7) == 59
            missdateNum(i,7) = 0;
            missdateNum(i,6) = completedateNum(missIndex(i),6)+1;
            
            if missdateNum(i,6) == 60
                missdateNum(i,6) = 0;
                missdateNum(i,5) = completedateNum(missIndex(i),5)+1;
            else
                missdateNum(i,5) = completedateNum(missIndex(i),5);
            end
            
            if  missdateNum(i,5) == 24
                missdateNum(i,5) = 0;
                missdateNum(i,4) = completedateNum(missIndex(i),4)+1;
            else
                missdateNum(i,4) = completedateNum(missIndex(i),4);
            end
            
            if  missdateNum(i,4) == 8
                missdateNum(i,4) = 1;
                missdateNum(i,3) = completedateNum(missIndex(i),3)+1;
            else
                missdateNum(i,3) = completedateNum(missIndex(i),3);
            end
            
            if  missdateNum(i,3) == 32
                missdateNum(i,3) = 1;
            else
                missdateNum(i,2) = 1;
            end
        else
            missdateNum(i,7) = completedateNum(missIndex(i),7)+1;
            missdateNum(i,2:6) = completedateNum(missIndex(i),2:6);
        end
        missPowerData(i,:) = powerData(missIndex(i),:);
    end
    completedateNum1 = insertrows(completedateNum,missdateNum,missIndex(:,1));
    completePowerData1 = insertrows(completePowerData,missPowerData,missIndex(:,1));
    clear completedateNum completePowerData
    completedateNum = completedateNum1;
    completePowerData = completePowerData1;
    clear completedateNum1 completePowerData1
end


minMeanPower=zeros(ceil(length(completePowerData)/60)-1,3);
for m = 1:length(minMeanPower)
    minStart = (m-1)*60+1;
    minEnd = m*60;
    minMeanPower(m,:) = mean(completePowerData(minStart:minEnd,:));
end


minMeanDateNum = zeros(length(minMeanPower),5);
for k = 1:length(minMeanPower)
    minMeanDateNum(k,:) = completedateNum(k*60,2:6);
end


