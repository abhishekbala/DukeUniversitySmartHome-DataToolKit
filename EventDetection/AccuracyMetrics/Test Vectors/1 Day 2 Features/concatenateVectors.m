%concatanateVectors

ON = prtDataSetClass;
load('disaggID.mat');
ON.targets = ONdcsID';
ON.data = ONdcsID';

OFF = prtDataSetClass;
OFF.targets = OFFdcsID';
OFF.data = OFFdcsID';


%% Truth Values Concatenation
dummy = prtDataSetClass;
truthON = prtDataSetClass;
load('h10p.mat')
dummy.data = [h10onTruth*3]';
dummy.targets = dummy.data;
truthON = catObservations(truthON, dummy);

dummy = prtDataSetClass;
load('refrigerator.mat')
dummy.data = [refOnTruth*1]';
dummy.targets = dummy.data;
truthON = catObservations(truthON, dummy);

dummy = prtDataSetClass;
load('hotbox.mat')
dummy.data = [hotOnTruth*5]';
dummy.targets = dummy.data;
truthON = catObservations(truthON, dummy);

dummy = prtDataSetClass;
load('HVAC1.mat')
dummy.data = [HVAC1onTruth*7]';
dummy.targets = dummy.data;
truthON = catObservations(truthON, dummy);

dummy = prtDataSetClass;
load('HVAC2.mat')
dummy.data = [HVAC2onTruth*9]';
dummy.targets = dummy.data;
truthON = catObservations(truthON, dummy)