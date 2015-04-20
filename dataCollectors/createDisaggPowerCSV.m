DisaggregatedPower = csvread('..\dataCollectors\12Hours.csv');

time = DisaggregatedPower(:,1);
refrigerator = DisaggregatedPower(:,14);
hotbox = DisaggregatedPower(:,13);
HVAC1 = DisagregatedPower(:,6) + DisaggregatedPower(:,8);
HVAC2 = DisaggregatedPower(:,7) + DisaggregatedPower(:,9);

csvwrite('DisaggregatedPower.csv',[time refrigerator hotbox HVAC1 HVAC2]);