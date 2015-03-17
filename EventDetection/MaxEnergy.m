myTot = smartHomeData(:,2) + smartHomeData(:,3) + ...
    abs(smartHomeData(:,4)) + abs(smartHomeData(:,5)) - sum(abs(smartHomeData(:,6:11)),2);

dayTime = 8.4e4;

myPercents = zeros(1, (length(smartHomeData(1,:))));

myTotEnergyUsage = sum(myTot(1:dayTime));

for(i = 2:length(myPercents))
    appTot = smartHomeData(:,i);
    appTotEnergy = sum(appTot(1:dayTime));
    myPercents(i) = appTotEnergy ./ myTotEnergyUsage;
    endb