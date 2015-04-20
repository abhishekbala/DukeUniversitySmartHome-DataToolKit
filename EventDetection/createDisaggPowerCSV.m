DisaggregatedPower = csvread('..\dataCollectors\13Hours.csv');

time = DisaggregatedPower(:,1);
refrigerator = DisaggregatedPower(:,14);
hotbox = DisaggregatedPower(:,13);
HVAC1 = DisaggregatedPower(:,6) + DisaggregatedPower(:,8);
HVAC2 = DisaggregatedPower(:,7) + DisaggregatedPower(:,9);

 dlmwrite('DisaggregatedPower.csv',[time refrigerator hotbox HVAC1 HVAC2],'newline','pc','precision',11);