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
refOnTruth= [refOnTruth*1]';
h10onTruth = [h10onTruth*2]';
hotOnTruth = [hotOnTruth*3]';
HVAC1onTruth = [HVAC1onTruth*4]';
HVAC2onTruth = [HVAC2onTruth*5]';
onTruths = h10onTruth + refOnTruth + hotOnTruth + HVAC1onTruth + HVAC2onTruth;
dummy.data = onTruths;
dummy.targets = dummy.data;
truthON = catObservations(truthON, dummy);