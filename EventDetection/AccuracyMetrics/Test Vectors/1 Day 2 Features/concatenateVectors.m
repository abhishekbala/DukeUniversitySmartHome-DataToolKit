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
load('refrigerator.mat')
load('hotbox.mat')
load('HVAC1.mat')
load('HVAC2.mat')
h10onTruth = [h10onTruth*3]';
refOnTruth= [refOnTruth*1]';
hotOnTruth = [hotOnTruth*5]';
HVAC1onTruth = [HVAC1onTruth*7]';
HVAC2onTruth = [HVAC2onTruth*9]';
onTruths = h10onTruth + refOnTruth + hotOnTruth + HVAC1onTruth + HVAC2onTruth;
dummy.data = onTruths;
dummy.targets = dummy.data;
truthON = catObservations(truthON, dummy);